# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Test binding a map to glitter size

add_rats_test(moonray_material_glitter_bind_flake_size
    INPUTS glitter_bind_flake_size.rdla
    CANONICALS
        scene.exr
)

