# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Description: This tests some of the extended cryptomatte features, including:
#                   * capturing multiple presence bounces
#                   * crypto beauty
#                   * crypto normals
#                   * crypto positions

add_rats_test(BASENAME moonray_render_output_cryptomatte_multipresence
    INPUTS
        ../common.rdla
        scene.rdla
           
    CANONICALS 
        scene.exr
        cryptomatte.exr
)
