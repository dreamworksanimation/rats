# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests curve rendering of the three curve types and three curve subtypes.
# From left to right are types linear, bspline, and bezier curves.
# From top to bottom are subtypes ray_facing, round, and normal_oriented.
# It also tests primitive data which uses UserData Rgb values to color the curves.
# It also tests motion blur where the third(blue) curve in each set has different values
# for the vertex data.
# The 3 curves in the lower left corner test tessellation rate

# https://jira.dreamworks.net/browse/MOONRAY-5409
# Skipped are linear normal_oriented curves which are unsupported and crash the renderer.
# Also skipped are bspline and bezier motion blur for normal oriented curves which crash.


add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        scene.exr
    DISABLED # MOONRAY-5670
)

