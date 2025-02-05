# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output primitive attributes on parts of an rdlmesh as aovs.

add_rats_test(moonray_render_output_aov_prim_attr_part_rdlmesh
    INPUTS scene.rdla
    CANONICALS result0.exr
)

