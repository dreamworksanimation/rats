#!/usr/bin/env python3

# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

"""
Wrapper script for moonray renderer that injects -threads argument from
RATS_MOONRAY_THREADS environment variable if set.
"""

import argparse
import os
import subprocess
import sys


def main():
    """Execute moonray with optional -threads argument from environment."""
    parser = argparse.ArgumentParser(
        description='Moonray render wrapper that respects RATS_MOONRAY_THREADS'
    )
    
    parser.add_argument(
        'renderer',
        help='Renderer command (moonray, hd_render, etc.)'
    )
    
    parser.add_argument(
        'args',
        nargs=argparse.REMAINDER,
        help='Arguments to pass to the renderer'
    )
    
    parsed_args = parser.parse_args()
    
    # Build the command
    cmd = [parsed_args.renderer]
    
    # Check for RATS_MOONRAY_THREADS and inject -threads if it's moonray
    if parsed_args.renderer == 'moonray':
        moonray_threads = os.getenv('RATS_MOONRAY_THREADS', '')
        if moonray_threads:
            try:
                num_threads = int(moonray_threads)
                if num_threads > 0:
                    cmd.extend(['-threads', str(num_threads)])
                    print(f"[RATS DEBUG] Using {num_threads} threads for moonray", flush=True)
            except ValueError:
                print(f"[RATS WARNING] RATS_MOONRAY_THREADS={moonray_threads} is not a valid integer, ignoring", file=sys.stderr)
    
    # Add remaining arguments
    cmd.extend(parsed_args.args)
    
    # Execute the renderer
    try:
        result = subprocess.run(cmd, check=True)
        return result.returncode
    except subprocess.CalledProcessError as e:
        return e.returncode
    except Exception as e:
        print(f"Error executing renderer: {e}", file=sys.stderr)
        return 1


if __name__ == '__main__':
    sys.exit(main())
