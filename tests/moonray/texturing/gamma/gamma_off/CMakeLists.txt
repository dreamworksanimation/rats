# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests gamma functionality on 8-bit input textures.  
# There is both a "gamma on" and a "gamma off" version of this test.
# The gamma off has a brighter canonical than gamma on.

add_rats_test(moonray_texturing_gamma_gamma_off
    INPUTS  ../common.rdla
            gamma_off.rdla
    CANONICALS scene.exr
)

