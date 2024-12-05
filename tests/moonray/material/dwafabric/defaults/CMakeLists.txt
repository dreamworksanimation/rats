# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests defaults for DwaFabricMaterial

add_rats_test(moonray_material_dwafabric_defaults
    INPUTS dwafabric_defaults.rdla
    CANONICALS
        scene.exr
)

