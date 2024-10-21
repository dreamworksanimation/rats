# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(moonray_render_output_aov_child_labels
    INPUTS aov_child_labels.rdla
    CANONICALS
        scene.exr
        lpe_diffuse.exr
        lpe_material.exr
        material_specular.exr
)

