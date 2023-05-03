# Copyright 2023 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

add_rats_test(bathroom
    WORKING_DIRECTORY /usr/pic1/jlanz/pbrt_scenes/bathroom/
    INPUTS scene.rdla scene.rdlb
    EXEC_MODES scalar vector xpu
)

