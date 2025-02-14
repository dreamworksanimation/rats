# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output material aovs with labels

add_rats_test(BASENAME moonray_render_output_aov_material_labels
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS result0.exr
)

