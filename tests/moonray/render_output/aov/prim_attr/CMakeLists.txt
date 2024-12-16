# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output primitive attributes as aovs.

add_rats_test(moonray_render_output_aov_prim_attr
    INPUTS aov_prim_attr.rdla
    CANONICALS result0.exr
)

