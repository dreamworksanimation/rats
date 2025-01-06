# Copyright 2024-2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Description: Tests reflected/refracted cryptomatte functionality.

add_rats_test(moonray_render_output_cryptomatte_reflected_refracted
    INPUTS scene.rdla
    CANONICALS
        beauty.exr
        cryptomatte.exr
    DIFF_HEADERS
)
