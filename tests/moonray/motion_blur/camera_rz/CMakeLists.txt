# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion-blur due to camera rotation around its z axis

add_rats_test(moonray_motion_blur_camera_rz
    INPUTS ../common/motion_blur_common.rdla
           motion_blur_camera_rz.rdla
    CANONICALS scene.exr
)

