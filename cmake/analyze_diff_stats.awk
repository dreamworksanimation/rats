#!/bin/awk -f

# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

function isnum(x) { return x+0 == x }

# Expects a one-dimensional associative awk array.
# Returns a string representing a flat JSON object or array.
# The values associated with each key in the associative awk array can
# also be JSON strings representing JSON structures.
function to_json_object(data) {
    # CMake's JSON parser cannot handle infs/nans, so we'll convert them to strings
    conversions["inf"] = "\"inf\""
    conversions["nan"] = "\"nan\""
    conversions["NaN"] = "\"NaN\""

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
        val = data[key]

        if (val in conversions) {
            val = conversions[val]
        }

        if (isnum(key)) {
            json = sprintf("%s%s%s", json, comma, val)
        } else {
            json = sprintf("%s%s\"%s\": %s", json, comma, key, val)
        }
        comma = ", "
    }
    json = sprintf("%s%s", json, closer)
    return json
}


# skip blank lines.
/^\s*$/ { next }

# Parse relevant lines from idiff
/Num tests:/ {
    num_tests = $3
}
/Image:/ {
    current_canonical = $2
    canonicals[current_canonical] = current_canonical
}
/Candidate/ {
    current_candidate = $2
    candidates[current_candidate] = current_candidate
}
/Test/ {
    current_test = $2
}
/ channels/ {
    num_channels[current_canonical] = $(NF-1) # second to last field
}
/Mean error/ {
    mean_error = $4
    candidate_mean_error[current_canonical,current_candidate] += mean_error / num_tests

    if (canonical_largest_mean_error[current_canonical] == "" ||
           mean_error > canonical_largest_mean_error[current_canonical]) {
           canonical_largest_mean_error[current_canonical] = mean_error
    }
}
/RMS error/ {
    rms_error = $4

    # We use this to choose the best candidate
    candidate_total_rms_error[current_canonical,current_candidate] += rms_error
}
/Max error/ {
    max_error = $4

    # This is only needed for reporting info about the best candidate
    if (candidate_largest_max_error[current_canonical,current_candidate] == "" ||
           max_error > candidate_largest_max_error[current_canonical,current_candidate]) {
           candidate_largest_max_error[current_canonical,current_candidate] = max_error
    }

    if (canonical_largest_max_error[current_canonical] == "" ||
           max_error > canonical_largest_max_error[current_canonical]) {
           canonical_largest_max_error[current_canonical] = max_error
    }
}

# Parse relevant lines from oiio_stats.py
/Stats Avg/ {
    # Find the avg across all channels for each candidate
    field_offset = 3
    for (i = field_offset; i <= NF; ++i) {
        avg = $i
        if (candidate_largest_avg[current_canonical,current_candidate] == "" || avg > candidate_largest_avg[current_canonical,current_candidate]) {
            candidate_largest_avg[current_canonical,current_candidate] = avg
        }

        if (canonical_largest_avg[current_canonical] == "" || avg > canonical_largest_avg[current_canonical]) {
            canonical_largest_avg[current_canonical] = avg
        }
    }
}

/Stats StdDev/ {
    # Find the maximum stddev across all channels for each candidate
    field_offset = 3
    for (i = field_offset; i <= NF; ++i) {
        stddev = $i
        if (candidate_largest_stddev[current_canonical,current_candidate] == "" || stddev > candidate_largest_stddev[current_canonical,current_candidate]) {
            candidate_largest_stddev[current_canonical,current_candidate] = stddev
        }

        if (canonical_largest_stddev[current_canonical] == "" || stddev > canonical_largest_stddev[current_canonical]) {
            canonical_largest_stddev[current_canonical] = stddev
        }
    }
}

END {
    for (canonical in canonicals) {
        # Find best candidate.
        # To keep things simple we'll choose the candidate with the smallest RMSE.
        best_candidate_smallest_total_rms_error = ""

        for (candidate in candidates) {
            total_rms_error = candidate_total_rms_error[canonical,candidate]
            if (best_candidate_smallest_total_rms_error == "" || total_rms_error < best_candidate_smallest_total_rms_error) {
                best_candidate_smallest_total_rms_error = total_rms_error
                best_candidate = candidate
            }
        }

        # Because our sample size is so small (just a handful of candidates), we'll choose
        # the largest mean and largest stddev found across all tests and all channels for
        # this canonical as the basis for our diff thresholds.
        mean_error = canonical_largest_avg[canonical]
        stddev = canonical_largest_stddev[canonical]

        # Here we choose heuristics in the form of arguments that will be passed to the idiff
        # command when running the tests.

        # Chebyshev's inequality says that for any distribution for which the standard
        # deviation is defined, the amount of data within a number of stddevs from
        # the mean is at least as much as 75% for +/-2 stddevs and 88.8888% for +/-3 stddevs.
        # This tell us as many as 11.1111% of the error values are outside of the mean + 3 stddevs
        # range, but we do not know what portion of those values exceed the mean. Still, if more than
        # 11.1111% of pixels exceed this upper limit we'll consider it a failure.
        # Cases where fewer than 11.1111 % of pixels over the limit will be considered passing.
        diff_args["-warn"] = mean_error + 2 * stddev
        diff_args["-warnpercent"] = 25.0 # (100 - 75)
        diff_args["-fail"] = mean_error + 3 * stddev
        diff_args["-failpercent"] = 11.1111 # (100 - 88.8888)

        # Setting a -hardfail threshold is also more art than science. Our dataset is incomplete
        # in that we only analyzing results from a handful of test cases. The very next render may
        # produce new/brighter fireflies that result in larger errors than previously encountered,
        # but that should still be considered passable. We'd like to have some upper boundary for
        # the error that is based on historical data, while still allowing for some additional range.
        # The best we can do here is probably to start with the maximum error encountered and allow
        # for new errors to exceed this by some amount, perhaps by one order of magnitude.
        hardfail = canonical_largest_max_error[canonical] * 10

        # While this is a bit arbitrary it seems to be a reasonable starting point through trial and error.
        # The hope is that the combination of -hardfail, -fail and -failpercent thresholds are sufficient to detect
        # real problems, while still allowing for small noise/firefly differences to consistently pass.

        # In scalar mode it is common for all of the candidates to be numerically identical. This
        # can happen in vector and xpu modes, too, although it is quite rare. In these cases our
        # largest recorded "max error" is zero.  However, this does not mean that in all future
        # renders the error will also be exactly zero.  If we set the -hardfail to zero a single
        # firefly or any miniscule change in noise pattern would cause a failure, so we'll use
        # a minimum -hardfail value of 0.004 (which is just above 1/255 and is the default for idiff).
        default_hardfail = 0.004
        diff_args["-hardfail"] = hardfail > default_hardfail ? hardfail : default_hardfail

        # Build the JSON string for reporting the results of the analysis.
        best_candidate_stats["index"] = best_candidate
        best_candidate_stats["mean error"] = candidate_mean_error[canonical,best_candidate]
        best_candidate_stats["largest max error"] = candidate_largest_max_error[canonical,best_candidate]
        best_candidate_stats["largest std dev"] = candidate_largest_stddev[canonical,best_candidate]

        canonical_findings["best candidate"] = to_json_object(best_candidate_stats)
        canonical_findings["largest mean error"] = canonical_largest_mean_error[canonical]
        canonical_findings["largest max error"] = canonical_largest_max_error[canonical]
        canonical_findings["largest std dev"] = canonical_largest_stddev[canonical]
        canonical_findings["diff args"] = to_json_object(diff_args)

        output[canonical] = to_json_object(canonical_findings)
    }

    # print findings in JSON format
    printf("%s\n", to_json_object(output))
}
