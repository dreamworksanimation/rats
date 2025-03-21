# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests subdivision surface creases for the RdlMeshGeometry procedural

add_rats_test(BASENAME moonray_geometry_usd_instance
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

