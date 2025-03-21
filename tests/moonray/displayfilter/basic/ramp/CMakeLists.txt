# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the RampDisplayFilter.

add_rats_test(BASENAME moonray_displayfilter_basic_ramp
    INPUTS
        ../common.rdla
        scene.rdla
    CANONICALS
        u_ramp.exr
        v_ramp.exr
        diagonal_ramp.exr
        radial_ramp.exr
        circular_ramp.exr
        box_ramp.exr
        input_ramp.exr
)

