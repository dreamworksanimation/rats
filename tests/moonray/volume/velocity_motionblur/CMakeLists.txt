# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion blur specified with a velocity field.

add_rats_test(BASENAME moonray_volume_velocity_motionblur
    INPUTS scene.rdla
    CANONICALS scene.exr
)

