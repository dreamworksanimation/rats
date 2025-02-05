# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output bsdf lobe attributes as material aovs.

add_rats_test(moonray_render_output_aov_material_properties
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS result0.exr
)

