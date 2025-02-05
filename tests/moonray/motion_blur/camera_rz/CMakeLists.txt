# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion-blur due to camera rotation around its z axis

add_rats_test(moonray_motion_blur_camera_rz
    INPUTS ../common.rdla
           scene.rdla
    CANONICALS scene.exr
)

