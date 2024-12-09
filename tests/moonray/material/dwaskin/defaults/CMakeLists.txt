# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests default properties of the dwaskin material

add_rats_test(moonray_material_dwaskin_defaults
    INPUTS dwaskin_defaults.rdla
    CANONICALS
        scene.exr
)

