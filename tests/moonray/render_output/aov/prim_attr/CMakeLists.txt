# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# This tests the ability of the RenderOutput objects to output primitive attributes as aovs.

add_rats_test(
    INPUTS scene.rdla
    CANONICALS
        vid.exr
        mataov_vid.exr
        st.exr
        mataov_st.exr
        ref_P.exr
        mataov_ref_P.exr
        cd.exr
        mataov_cd.exr
)

