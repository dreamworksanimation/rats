#!/usr/bin/env python3

# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

"""
This script is run during execution of the rats tests to generate and update canonical images.

It is responsible for:
1. Rendering a series of images to find the best candidates to become official canonicals
2. Analyzing the rendered images using statistical methods
3. Copying the best canonicals to RATS_CANONICALS_DIR
4. Updating a test's diff.json with new ideal thresholds for the idiff command
"""

import argparse
import json
import os
import shutil
import subprocess
import sys
import time
from concurrent.futures import ThreadPoolExecutor, as_completed
from pathlib import Path
from typing import Dict, List, Tuple, Any, Optional

try:
    import OpenImageIO as oiio
    from OpenImageIO import ImageBuf, ImageBufAlgo
except ImportError:
    print("ERROR: OpenImageIO Python bindings not found", file=sys.stderr)
    print("Please ensure OIIO Python bindings are available", file=sys.stderr)
    sys.exit(1)


class CanonicalUpdater:
    """Handles the generation and analysis of canonical images for RATS tests."""

    def __init__(self, args):
        """Initialize the updater with parsed command-line arguments."""
        self.test_rel_path = args.test_rel_path
        self.canonicals = args.canonicals
        # Parse the space-separated render command string into a list
        import shlex
        self.render_cmd = shlex.split(args.render_cmd)
        # Map 'default' to 'auto' for moonray compatibility
        self.exec_mode = 'auto' if args.exec_mode == 'default' else args.exec_mode
        self.exec_mode_arg = args.exec_mode  # Keep original for directory naming
        self.idiff = args.idiff
        self.diff_json = args.diff_json
        self.num_renders = args.num_renders
        self.generate_new_canonical = args.generate_new_canonical
        
        # Check for environment variable first, then command-line arg
        env_concurrent = os.getenv('RATS_RUN_CONCURRENT', '')
        self.max_workers = None  # None means use default (number of CPUs)
        
        if env_concurrent:
            # Try to parse as integer for max workers
            try:
                workers = int(env_concurrent)
                if workers > 0:
                    self.run_concurrent = True
                    self.max_workers = workers
                else:
                    self.run_concurrent = False
            except ValueError:
                # Not an integer, check for boolean values
                self.run_concurrent = env_concurrent.lower() in ('true', 'yes')
        else:
            self.run_concurrent = args.run_concurrent
        
        if env_concurrent:
            print(f"[RATS DEBUG] RATS_RUN_CONCURRENT={env_concurrent}, run_concurrent={self.run_concurrent}, max_workers={self.max_workers}", flush=True)
        
        # Check for RATS_MOONRAY_THREADS environment variable and inject -threads argument
        moonray_threads = os.getenv('RATS_MOONRAY_THREADS', '')
        if moonray_threads:
            try:
                num_threads = int(moonray_threads)
                if num_threads > 0:
                    # Inject -threads argument into render command
                    self.render_cmd.extend(['-threads', str(num_threads)])
                    print(f"[RATS DEBUG] RATS_MOONRAY_THREADS={moonray_threads}, added -threads {num_threads} to render command", flush=True)
            except ValueError:
                print(f"[RATS WARNING] RATS_MOONRAY_THREADS={moonray_threads} is not a valid integer, ignoring", file=sys.stderr)
        
        # Validate and setup paths
        self.canonicals_root = os.getenv('RATS_CANONICAL_DIR')
        if not self.canonicals_root:
            raise RuntimeError("RATS_CANONICAL_DIR environment variable is not set")
        
        if not os.path.exists(self.canonicals_root):
            raise RuntimeError(f"RATS_CANONICAL_DIR {self.canonicals_root} does not exist")
        
        self.full_canonical_path = os.path.join(
            self.canonicals_root, self.test_rel_path, self.exec_mode
        )
        
        self.tmp_dir = "update_canonicals_tmp"
        self.diff_results = {}
        self.stats_data = {}

    def get_oiio_stats(self, image_path: str) -> Dict[str, List[float]]:
        """
        Get OpenImageIO stats from an image with full precision.
        
        Args:
            image_path: Path to the image file
            
        Returns:
            Dictionary containing min, max, avg, stddev, and count statistics
        """
        try:
            diff_buffer = ImageBuf(image_path)
            stats = ImageBufAlgo.computePixelStats(diff_buffer)
            
            return {
                'min': list(stats.min),
                'max': list(stats.max),
                'avg': list(stats.avg),
                'stddev': list(stats.stddev),
                'nancount': list(stats.nancount),
                'infcount': list(stats.infcount),
                'finitecount': list(stats.finitecount),
            }
        except Exception as e:
            print(f"Error getting stats for {image_path}: {e}", file=sys.stderr)
            raise

    def compute_diff_in_memory(self, image1: str, image2: str) -> Tuple[ImageBuf, Dict[str, float]]:
        """
        Compute diff between two images in memory using OIIO.
        
        Args:
            image1: Path to first image
            image2: Path to second image
            
        Returns:
            Tuple of (diff_buffer, stats_dict with mean/rms/max errors)
        """
        try:
            buf1 = ImageBuf(image1)
            buf2 = ImageBuf(image2)
            
            # Compute absolute difference
            diff_buf = ImageBufAlgo.sub(buf1, buf2)
            diff_buf = ImageBufAlgo.abs(diff_buf)
            
            # Get pixel statistics from diff
            stats = ImageBufAlgo.computePixelStats(diff_buf)
            
            # Compute mean error (average of avg across channels)
            mean_error = sum(stats.avg) / len(stats.avg) if stats.avg else 0.0
            
            # Compute RMS error (using stddev as approximation)
            # RMS = sqrt(mean(square(diff))) ≈ sqrt(avg^2 + stddev^2)
            rms_error = 0.0
            for i in range(len(stats.avg)):
                rms_error += stats.avg[i]**2 + stats.stddev[i]**2
            rms_error = (rms_error / len(stats.avg))**0.5 if stats.avg else 0.0
            
            # Max error is the maximum across all channels
            max_error = max(stats.max) if stats.max else 0.0
            
            return diff_buf, {
                'mean_error': mean_error,
                'rms_error': rms_error,
                'max_error': max_error
            }
        except Exception as e:
            print(f"Error computing diff for {image1} vs {image2}: {e}", file=sys.stderr)
            raise

    def _render_single_candidate(self, render_index: int) -> Tuple[int, bool, str]:
        """Render a single candidate. Returns (index, success, error_msg)."""
        working_dir = os.path.join(self.tmp_dir, str(render_index))
        os.makedirs(working_dir, exist_ok=True)
        
        try:
            subprocess.run(
                self.render_cmd,
                cwd=working_dir,
                check=True,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT
            )
            return (render_index, True, "")
        except subprocess.CalledProcessError as e:
            return (render_index, False, str(e))

    def render_candidates(self):
        """Render N sets of candidate canonical images."""
        mode_str = ' concurrently' if self.run_concurrent else ' sequentially'
        print(f"[RATS] Rendering {self.num_renders} candidate sets{mode_str}...", flush=True)
        
        start_time = time.time()
        
        if self.run_concurrent:
            # Run renders in parallel using threads (more efficient for I/O bound subprocess calls)
            with ThreadPoolExecutor(max_workers=self.max_workers) as executor:
                futures = {executor.submit(self._render_single_candidate, i): i 
                          for i in range(self.num_renders)}
                
                completed = 0
                for future in as_completed(futures):
                    render_index, success, error_msg = future.result()
                    completed += 1
                    if success:
                        print(f"[RATS] Finished canonical candidate render {completed}/{self.num_renders}")
                    else:
                        print(f"Error rendering candidate {render_index}: {error_msg}", file=sys.stderr)
                        raise RuntimeError(f"Render {render_index} failed: {error_msg}")
        else:
            # Run renders sequentially
            for i in range(self.num_renders):
                render_index, success, error_msg = self._render_single_candidate(i)
                if success:
                    print(f"[RATS] Finished canonical candidate render {i+1}/{self.num_renders}")
                else:
                    print(f"Error rendering candidate {render_index}: {error_msg}", file=sys.stderr)
                    raise RuntimeError(f"Render {render_index} failed: {error_msg}")
        
        elapsed = time.time() - start_time
        print(f"[RATS PROFILE] Rendering completed in {elapsed:.2f} seconds ({elapsed/self.num_renders:.2f}s per render)", flush=True)

    def _compare_images(self, args_tuple):
        """Compare two images and return statistics. Used for parallel execution."""
        i, j, image_filename = args_tuple
        
        candidate_image = os.path.join(self.tmp_dir, str(i), image_filename)
        test_image = os.path.join(self.tmp_dir, str(j), image_filename)
        
        # Compute diff in memory (much faster than external idiff + disk I/O)
        diff_buf, error_stats = self.compute_diff_in_memory(candidate_image, test_image)
        
        # Get detailed OIIO stats from the diff buffer
        stats = ImageBufAlgo.computePixelStats(diff_buf)
        oiio_stats = {
            'min': list(stats.min),
            'max': list(stats.max),
            'avg': list(stats.avg),
            'stddev': list(stats.stddev),
            'nancount': list(stats.nancount),
            'infcount': list(stats.infcount),
            'finitecount': list(stats.finitecount),
        }
        
        # Return comparison results with indices
        return (i, j, {
            'mean_error': error_stats['mean_error'],
            'rms_error': error_stats['rms_error'],
            'max_error': error_stats['max_error'],
            'oiio_stats': oiio_stats,
        })

    def analyze_candidates(self):
        """
        Compare each candidate with all other candidates and gather statistics.
        
        This populates self.stats_data with comprehensive comparison results.
        """
        print(f"[RATS] Analyzing candidates...", flush=True)
        start_time = time.time()
        
        for canonical_idx, image_filename in enumerate(self.canonicals):
            print(f"[RATS] Processing canonical {canonical_idx+1}/{len(self.canonicals)}: {image_filename}", flush=True)
            
            image_stats = {
                'candidates': {},
                'largest_mean_error': 0.0,
                'largest_max_error': 0.0,
                'largest_avg': 0.0,
                'largest_stddev': 0.0,
            }
            
            # Build list of all comparisons to perform (only i < j to avoid duplicates)
            comparisons_to_run = []
            for i in range(self.num_renders):
                for j in range(i + 1, self.num_renders):
                    comparisons_to_run.append((i, j, image_filename))
            
            num_skipped = self.num_renders  # self-comparisons
            num_copies = 0
            
            # Run comparisons in parallel if enabled
            comparison_results = {}
            if self.run_concurrent and len(comparisons_to_run) > 1:
                print(f"[RATS] Running {len(comparisons_to_run)} comparisons in parallel...", flush=True)
                with ThreadPoolExecutor(max_workers=self.max_workers) as executor:
                    futures = {executor.submit(self._compare_images, args): args 
                              for args in comparisons_to_run}
                    
                    completed = 0
                    for future in as_completed(futures):
                        i, j, comparison = future.result()
                        comparison_results[(i, j)] = comparison
                        completed += 1
                        if completed % 50 == 0 or completed == len(comparisons_to_run):
                            print(f"[RATS] Completed {completed}/{len(comparisons_to_run)} comparisons", flush=True)
            else:
                # Sequential execution
                for args in comparisons_to_run:
                    i, j, comparison = self._compare_images(args)
                    comparison_results[(i, j)] = comparison
            
            # Now aggregate the results
            for i in range(self.num_renders):
                candidate_stats = {
                    'comparisons': {},
                    'total_rms_error': 0.0,
                    'largest_max_error': 0.0,
                    'largest_avg': 0.0,
                    'largest_stddev': 0.0,
                    'mean_error_sum': 0.0,
                }
                
                for j in range(self.num_renders):
                    if i == j:
                        continue
                    
                    # Get comparison result (either from (i,j) or (j,i))
                    if (i, j) in comparison_results:
                        comparison = comparison_results[(i, j)]
                        num_copies += 1
                    elif (j, i) in comparison_results:
                        comparison = comparison_results[(j, i)]
                        num_copies += 1
                    else:
                        continue
                    
                    candidate_stats['comparisons'][j] = comparison
                    oiio_stats = comparison['oiio_stats']
                    
                    # Update candidate aggregates (only for j > i to avoid double counting)
                    if j > i:
                        candidate_stats['total_rms_error'] += comparison['rms_error']
                        candidate_stats['mean_error_sum'] += comparison['mean_error']
                        candidate_stats['largest_max_error'] = max(
                            candidate_stats['largest_max_error'], comparison['max_error']
                        )
                        
                        # Find largest avg and stddev across all channels
                        for avg_val in oiio_stats['avg']:
                            candidate_stats['largest_avg'] = max(
                                candidate_stats['largest_avg'], avg_val
                            )
                        for stddev_val in oiio_stats['stddev']:
                            candidate_stats['largest_stddev'] = max(
                                candidate_stats['largest_stddev'], stddev_val
                            )
                        
                        # Update image-level aggregates
                        image_stats['largest_mean_error'] = max(
                            image_stats['largest_mean_error'], comparison['mean_error']
                        )
                        image_stats['largest_max_error'] = max(
                            image_stats['largest_max_error'], comparison['max_error']
                        )
                        image_stats['largest_avg'] = max(
                            image_stats['largest_avg'], candidate_stats['largest_avg']
                        )
                        image_stats['largest_stddev'] = max(
                            image_stats['largest_stddev'], candidate_stats['largest_stddev']
                        )
                
                # Calculate mean error for this candidate
                if self.num_renders > 1:
                    candidate_stats['mean_error'] = (
                        candidate_stats['mean_error_sum'] / (self.num_renders - 1)
                    )
                
                image_stats['candidates'][i] = candidate_stats
            
            self.stats_data[image_filename] = image_stats
            
            print(f"[RATS] Finished analysis for canonical {image_filename}")
            print(f"[RATS] {len(comparisons_to_run)} unique diffs performed.")
            print(f"[RATS] {num_copies} result references created.")
            print(f"[RATS] {num_skipped} diffs skipped (self-comparisons).")
        
        elapsed = time.time() - start_time
        total_comparisons = len(self.canonicals) * self.num_renders * (self.num_renders - 1) // 2
        print(f"[RATS PROFILE] Analysis completed in {elapsed:.2f} seconds ({total_comparisons} total comparisons, {elapsed/total_comparisons:.3f}s per comparison)", flush=True)

    def choose_best_candidates(self) -> Dict[str, int]:
        """
        Choose the best candidate for each canonical image.
        
        Returns:
            Dictionary mapping image filename to best candidate index
        """
        best_candidates = {}
        
        for image_filename, image_stats in self.stats_data.items():
            best_candidate = None
            smallest_total_rms = None
            
            for candidate_idx, candidate_stats in image_stats['candidates'].items():
                total_rms = candidate_stats['total_rms_error']
                
                if smallest_total_rms is None or total_rms < smallest_total_rms:
                    smallest_total_rms = total_rms
                    best_candidate = candidate_idx
            
            best_candidates[image_filename] = best_candidate
            print(f"[RATS] {image_filename}: best candidate is {best_candidate}")
        
        return best_candidates

    def calculate_diff_thresholds(self, image_filename: str) -> Dict[str, float]:
        """
        Calculate idiff threshold arguments based on statistical analysis.
        
        Uses Chebyshev's inequality to determine reasonable thresholds:
        - At least 75% of data within mean ± 2 stddev
        - At least 88.8888% of data within mean ± 3 stddev
        
        Args:
            image_filename: Name of the canonical image
            
        Returns:
            Dictionary of diff arguments (warn, warnpercent, fail, failpercent, hardfail)
        """
        image_stats = self.stats_data[image_filename]
        
        mean_error = image_stats['largest_avg']
        stddev = image_stats['largest_stddev']
        max_error = image_stats['largest_max_error']
        
        # Calculate thresholds using Chebyshev's inequality
        diff_args = {
            '-warn': mean_error + 2 * stddev,
            '-warnpercent': 25.0,  # 100 minus 75
            '-fail': mean_error + 3 * stddev,
            '-failpercent': 11.1111,  # 100 minus 88.8888
        }
        
        # Set hardfail threshold allowing for some additional range
        # beyond the maximum error encountered
        hardfail = max_error * 10
        
        # Use minimum hardfail to avoid failures on tiny noise differences
        default_hardfail = 0.004
        diff_args['-hardfail'] = max(hardfail, default_hardfail)
        
        return diff_args

    def copy_best_candidates(self, best_candidates: Dict[str, int]):
        """
        Copy the best candidate images to the RATS_CANONICALS directory.
        
        Args:
            best_candidates: Dictionary mapping image filename to candidate index
        """
        os.makedirs(self.full_canonical_path, exist_ok=True)
        
        for image_filename, candidate_idx in best_candidates.items():
            source = os.path.join(self.tmp_dir, str(candidate_idx), image_filename)
            dest = os.path.join(self.full_canonical_path, image_filename)
            
            shutil.copyfile(source, dest)
            print(f"[RATS] Copied canonical from {source}")

    def update_diff_json(self, best_candidates: Dict[str, int]):
        """
        Update the diff.json file with new thresholds for each canonical.
        
        Args:
            best_candidates: Dictionary mapping image filename to candidate index
        """
        diff_json_path = os.path.join(self.canonicals_root, self.diff_json)
        
        # Load existing diff.json if it exists
        if os.path.exists(diff_json_path):
            with open(diff_json_path, 'r') as f:
                diff_json_data = json.load(f)
        else:
            diff_json_data = {}
        
        # Update thresholds for each canonical image
        for image_filename in best_candidates.keys():
            diff_args = self.calculate_diff_thresholds(image_filename)
            
            # Ensure the image entry exists
            if image_filename not in diff_json_data:
                diff_json_data[image_filename] = {}
            
            # Update for this execution mode
            diff_json_data[image_filename][self.exec_mode] = diff_args
            
            print(f"[RATS] Updated idiff args for image {image_filename}, "
                  f"exec_mode {self.exec_mode}")
        
        # Write updated JSON back to disk
        os.makedirs(os.path.dirname(diff_json_path), exist_ok=True)
        with open(diff_json_path, 'w') as f:
            json.dump(diff_json_data, f, indent=2)
        
        print(f"[RATS] Wrote updated diff.json to {diff_json_path}")

    def cleanup(self):
        """Remove temporary directory containing candidate images."""
        if os.path.exists(self.tmp_dir):
            shutil.rmtree(self.tmp_dir)
            print(f"[RATS] Cleaned up temporary directory: {self.tmp_dir}")

    def run(self):
        """Execute the full canonical update workflow."""
        print("[RATS] Using Python-based canonical updater")
        print(f"[RATS] Test: {self.test_rel_path}, Exec Mode: {self.exec_mode}")
        print(f"[RATS] Canonicals: {', '.join(self.canonicals)}")
        
        try:
            if self.generate_new_canonical:
                # Render candidate images
                self.render_candidates()
                
                # Analyze all candidates
                self.analyze_candidates()
                
                # Choose best candidates
                best_candidates = self.choose_best_candidates()
                
                # Copy best candidates to canonical directory
                self.copy_best_candidates(best_candidates)
                
                # Update diff.json with new thresholds
                self.update_diff_json(best_candidates)
            else:
                print("[RATS] Skipping render and analysis (--no-generate flag set)")
                print("[RATS] No operations performed in skip mode")
            
            # Cleanup temporary files
            if self.generate_new_canonical:
                self.cleanup()
            
            print("[RATS] Canonical update completed successfully")
            
        except Exception as e:
            print(f"[RATS] Error during canonical update: {e}", file=sys.stderr)
            raise


def main():
    """Main entry point for the script."""
    parser = argparse.ArgumentParser(
        description='Update canonical images for RATS tests'
    )
    
    parser.add_argument(
        '--test-rel-path',
        required=True,
        help='Relative test path from RATS_CANONICAL_DIR'
    )
    
    parser.add_argument(
        '--canonicals',
        required=True,
        action='append',
        help='Output image to be stored as canonical (can be specified multiple times)'
    )
    
    parser.add_argument(
        '--render-cmd',
        required=True,
        help='Render command as a space-separated string'
    )
    
    parser.add_argument(
        '--exec-mode',
        required=True,
        choices=['scalar', 'vector', 'xpu', 'auto', 'default'],
        help='Execution mode (default/auto will use moonray auto mode)'
    )
    
    parser.add_argument(
        '--idiff',
        required=True,
        help='Full path to the openimageio idiff command'
    )
    
    parser.add_argument(
        '--diff-json',
        required=True,
        help='Relative path to diff.json file to be created/updated'
    )
    
    parser.add_argument(
        '--num-renders',
        type=int,
        default=25,
        help='Number of candidate renders to generate (default: 25)'
    )
    
    parser.add_argument(
        '--no-generate',
        action='store_false',
        dest='generate_new_canonical',
        help='Skip rendering and use existing data (for testing)'
    )
    
    parser.add_argument(
        '--run-concurrent',
        action='store_true',
        help='Run all renders in parallel (default: sequential)'
    )
    
    args = parser.parse_args()
    
    # Create and run the updater
    updater = CanonicalUpdater(args)
    updater.run()
    
    return 0

if __name__ == '__main__':
    sys.exit(main())
