# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Tests motion blur specified with a velocity field.

add_rats_test(moonray_volume_velocity_motionblur
    INPUTS velocity_motionblur.rdla
    CANONICALS scene.exr
)

