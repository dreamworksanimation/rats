# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Test glitter deformation compensation

add_rats_test(BASENAME moonray_material_glitter_deformation_compensation
    INPUTS scene.rdla
    CANONICALS scene.exr
)

