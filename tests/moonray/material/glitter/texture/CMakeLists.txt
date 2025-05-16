# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Test glitter textures
if(IsDarwinPlatform) # macOS
    add_rats_test(
        INPUTS scene.rdla
        CANONICALS scene.exr
        DISABLED_VECTOR DISABLED_XPU # MOONRAY-5670 test fails with 'Bus error***Exception'
    )
else()
    add_rats_test(
        INPUTS scene.rdla
        CANONICALS scene.exr
    )
endif()


