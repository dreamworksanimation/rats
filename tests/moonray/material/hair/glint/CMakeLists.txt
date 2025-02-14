# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests hair glints added as a part of the TRT lobe.

add_rats_test(BASENAME moonray_material_hair_glint
    INPUTS scene.rdla
    CANONICALS scene.exr
)

