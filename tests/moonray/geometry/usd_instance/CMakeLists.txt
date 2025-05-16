# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

if(IsDarwinPlatform) # macOS
    add_rats_test(
        INPUTS scene.rdla
        CANONICALS scene.exr
        DISABLED_XPU # MOONRAY-5670
    )
else()
    add_rats_test(
        INPUTS scene.rdla
        CANONICALS scene.exr
    )
endif()

