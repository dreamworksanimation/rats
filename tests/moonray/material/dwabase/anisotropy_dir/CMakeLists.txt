# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests mapped anisotropic direction

add_rats_test(moonray_material_dwabase_anisotropy_dir
    INPUTS dwabase_anisotropy_dir.rdla
    CANONICALS
        scene.exr
)

