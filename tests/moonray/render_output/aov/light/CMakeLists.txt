# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output light aovs.

add_rats_test(moonray_render_output_aov_light
    INPUTS ../common/aov_common.rdla
           aov_light.rdla
    CANONICALS result0.exr
)

