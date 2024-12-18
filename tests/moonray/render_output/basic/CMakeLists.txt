# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the basic ability of the RenderOutput object to produce output.

add_rats_test(moonray_render_output_basic
    INPUTS render_output_basic.rdla
    CANONICALS result0.exr
               result1.exr
)

