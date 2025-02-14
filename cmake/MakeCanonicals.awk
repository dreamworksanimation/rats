#!/bin/awk -f

# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0


# Compute min, max, avg for all test data
# Each record (line) of input data is expected in the following form:
#
#   image_filename;candidate_index;metric_name;value;[value]...
#

BEGIN { FS = ";" } # field separator

function isnum(x) { return x+0 == x }
function isnan(x) { return (x+0 == "+nan"+0) }
function isinf(x) { return ! isnan(x) && isnan(x-x)  }
function isfinite(x) { return isnum(x) && ! isnan(x) && ! isinf(x) }

# Expects a one-dimensional associative awk array.
# Returns a string representing a flat JSON object or array.
# The values associated with each key in the associative awk array can
# also be JSON strings representing JSON structures.
function to_json_object(data) {
    opener = "{ "
    closer = " }"
    comma = ""

    # Check first key, if it is a number than we'll assume they all are and
    # construct a JSON array [].  If not, we'll construct a JSON object {}.
    for (key in data) {
        if (isnum(key)) {
            opener = "[ "
            closer = " ]"
        }
        break
    }

    json = sprintf("%s", opener)
    for (key in data) {
        if (isnum(key)) {
            json = sprintf("%s%s%s", json, comma, data[key])
        } else {
            json = sprintf("%s%s\"%s\": %s", json, comma, key, data[key])
        }
        comma = ", "
    }
    json = sprintf("%s%s", json, closer)
    return json
}

# Match and skip blank records (lines).
/^\s*$/ { next }

# Matches each non-blank record:
{
    image_filename = $1
    candidate_index = $2
    metric_name = $3
    first_data_field = 4

    # Build arrays of unique items for easier looping the multidimensional
    # associative arrays
    if (image_filename in image_filenames == 0) {
        image_filenames[image_filename] = ""
    }

    if (candidate_index in candidate_indices == 0) {
        candidate_indices[candidate_index] = ""
    }

    if (metric_name in metric_names == 0) {
        metric_names[metric_name] = ""
    }

    # Initialize associative arrays with starting min values
    if ((image_filename,metric_name,candidate_index) in min_value == 0) {
        min_value[image_filename,metric_name,candidate_index] = 2.0^1023
    }
    if ((image_filename,metric_name) in global_min_value == 0) {
        global_min_value[image_filename,metric_name] = 2.0^1023
    }

    # Initialize associative arrays with starting max values
    if ((image_filename,metric_name,candidate_index) in max_value == 0) {
        max_value[image_filename,metric_name,candidate_index] = 0
    }
    if ((image_filename,metric_name) in global_max_value == 0) {
        global_max_value[image_filename,metric_name] = 0
    }

    # Initialize associative arrays with starting total values and
    # number of values.. used to compute averages once all records
    # have been processed.
    if ((image_filename,metric_name,candidate_index) in total_value == 0) {
        total_value[image_filename,metric_name,candidate_index] = 0
        test_count[image_filename,metric_name,candidate_index] = 0
    }
    if ((image_filename,metric_name) in global_total_value == 0) {
        global_total_value[image_filename,metric_name] = 0
        global_test_count[image_filename,metric_name] = 0
    }


    for (i = first_data_field; i <= NF; ++i) {
        if (isfinite($i)) {
            # Keep track of the minimum value for each image/metric, ignoring infs and nans
            if ($i < min_value[image_filename,metric_name,candidate_index]) {
                min_value[image_filename,metric_name,candidate_index] = $i
            }
            if ($i < global_min_value[image_filename,metric_name]) {
                global_min_value[image_filename,metric_name] = $i
            }

            # Keep track of the maximum value for each image/metric, ignoring infs and nans
            if ($i > max_value[image_filename,metric_name,candidate_index]) {
                max_value[image_filename,metric_name,candidate_index] = $i
            }
            if ($i > global_max_value[image_filename,metric_name]) {
                global_max_value[image_filename,metric_name] = $i
            }

            # Compute the total of all values for each image/metric, ignoring infs and nans
            total_value[image_filename,metric_name,candidate_index] += $i
            ++test_count[image_filename,metric_name,candidate_index]
            global_total_value[image_filename,metric_name] += $i
            ++global_test_count[image_filename,metric_name]
        }
    }
}

# All records have been processed.  Collect final stats, compute a score for each
# canonical candidate, decide on a winning canonical, and suggest ideal thresholds
# for idiff for this test.
END {
    # for each canonical image...
    for (image_filename in image_filenames) {
        # for each candidate whose idiff output we analyzed...
        for (candidate_index in candidate_indices) {
            for (metric in metric_names) {
                num_tests = test_count[image_filename,metric,candidate_index]
                metric_stats["minimum"] = min_value[image_filename,metric,candidate_index]
                metric_stats["maximum"] = max_value[image_filename,metric,candidate_index]
                metric_stats["average"] = total_value[image_filename,metric,candidate_index] / (num_tests > 0 ? num_tests : 1)
                score_values[candidate_index,metric] = metric_stats["average"]
                candidate_stats[metric] = to_json_object(metric_stats)
            }

            # Assign some weight for each metric towards a final "score" for this candidate.
            # This is probably mostly useless, but it may be worth experimenting with.
            weight_max_error = 0.0
            weight_mean_error = 0.0
            weight_peak_snr = 0.0
            weight_rms_error = 1.0  # <-- RMSE seems like the most important metric
            weight_pixels_warning = 0.0
            weight_pixels_error = 0.0

            score[image_filename,candidate_index] = \
                 score_values[candidate_index,"max_error"] * weight_max_error + \
                 score_values[candidate_index,"mean_error"] * weight_mean_error + \
                 score_values[candidate_index,"peak_snr"] * weight_peak_snr + \
                 score_values[candidate_index,"rms_error"] * weight_rms_error + \
                 score_values[candidate_index,"pixels_warning"] * weight_pixels_warning + \
                 score_values[candidate_index,"pixels_error"] * weight_pixels_error

            candidate_stats["score"] = score[image_filename,candidate_index]
            test_stats[candidate_index] = to_json_object(candidate_stats)
        }

        # choose candidate with lowest score
        lowest_score = 2.0^1023
        best_candidate_index = "-1"

        for (candidate_index in candidate_indices) {
            this_score = score[image_filename,candidate_index]
            if (this_score < lowest_score) {
                lowest_score = this_score
                best_candidate_index = candidate_index
            }
        }

        # report global min, max, avg for each metric
        for (metric in metric_names) {
            num_tests = global_test_count[image_filename,metric]
            stats["minimum"] = global_min_value[image_filename,metric]
            stats["maximum"] = global_max_value[image_filename,metric]
            stats["average"] = global_total_value[image_filename,metric]  / (num_tests > 0 ? num_tests : 1)
            image_stats[metric] = to_json_object(stats)
        }

        image_stats["test stats"] = to_json_object(test_stats)
        image_stats["best candidate"] = sprintf("\"%s\"", best_candidate_index)

        # Choose appropriate diff args for this test. In theory we should be able to use the maximum
        # difference between the winning canonical and all other candidates, as it represents the most
        # "central" image in difference space. All of the candidates we have encountered so far lie
        # within this distance.  However, in practice this may be insufficient, as we are only considering
        # a relatively small number of images.  New renders may produce an image outside this range, which
        # may result in test failure.  To account this, we might use the global maximum difference between
        # any two candidates and/or consider padding the max error value by some amount.
        #
        # Other considerations:
        # * we may want to set -pixels_error or -fail_percent to some number > 0, to allow for the occasional
        #   fireflies.

        # diff_args["-fail"] = max_value[image_filename,"max_error",best_candidate_index] * 1.1 # pad 10%
        diff_args["-fail"] = global_max_value[image_filename,"max_error"] * 1.1 # pad by 10%
        image_stats["diff args"] = to_json_object(diff_args)

        all_stats[image_filename] = to_json_object(image_stats)
    }

    # print all stats in JSON form to be read by the MakeCanonicals.cmake script as it finishes processing.
    printf("%s\n", to_json_object(all_stats))
}
