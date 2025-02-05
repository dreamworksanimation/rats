# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput light aovs to handle presence

add_rats_test(moonray_render_output_aov_light_presence
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS result0.exr
)

