# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the aperture window, region window, pixel aspect ratio, and subviewport.

add_rats_test(BASENAME moonray_misc_render_window
    INPUTS scene.rdla
    CANONICALS scene.exr
               result0.exr
)

