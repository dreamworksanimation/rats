# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests moisture component (second specular lobe) of the dwaskin material

add_rats_test(moonray_material_dwaskin_moisture
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

