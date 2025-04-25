# Copyright 2025 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output state aovs.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
       pos.exr
       material_pos.exr
       geometricNormal.exr
       normal.exr
       st.exr
       dpds.exr
       dpdt.exr
       dsdx.exr
       dsdy.exr
       dtdx.exr
       dtdy.exr
       worldPos.exr
       depth.exr
)

