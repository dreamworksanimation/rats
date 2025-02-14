# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests defaults for DwaVelvetMaterial

add_rats_test(BASENAME moonray_material_dwavelvet_defaults
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

