# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This test exercises the VDB light filter. 

add_rats_test(BASENAME moonray_light_filter_vdb
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

