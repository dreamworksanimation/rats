# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test verifies that the r_lobe in the hair material shader is *functional*.
# It's settings are roughly default, unimportant values.  This test is meant to
# prevent unintended look changes or any break in its functionality.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS scene.exr
)

