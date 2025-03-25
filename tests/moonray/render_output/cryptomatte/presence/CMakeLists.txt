# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Description: Tests basic cryptomatte functionality with presence. 

add_rats_test(
    INPUTS 
        ../common.rdla
        scene.rdla
    CANONICALS 
        scene.exr
        cryptomatte.exr
)
