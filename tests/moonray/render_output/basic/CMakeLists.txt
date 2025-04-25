# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the basic ability of the RenderOutput object to produce output.

# Because there are multiple sub-images, non-default channel names and
# several different compression schemes used we should also diff the headers.
# It could be that the diff thresholds are not particularly tight in order
# to pass with a variety of data types.

add_rats_test(
    DIFF_HEADERS
    INPUTS scene.rdla
    CANONICALS result0.exr
               result1.exr
)

