# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Description: This test is intended to encompass any controls that might be used to limit or otherwise suppress 
# the shadows from certain lights. The test is composed of three spheres and three colored spotlights. The yellow
# spotlight is pointed at the sphere in the center. The red and green spotlights are positioned at opposite sides 
# and are pointing across the room. 

# The center sphere would typically cast a shadow across the lefthand sphere and corner of the room. However, it is 
# suppressed because a clear radius was applied to the red spotlight, leaving only the shadow cast by the lefthand sphere. 

# The yellow spotlight's shadow, cast by the center sphere, is reduced due to max_shadow_distance. 

# The shadow cast by the green spotlight off of the center sphere is suppressed
# because the green spotlight is part of the center sphere's shadow set.

add_rats_test(BASENAME moonray_light_shadow_controls
    INPUTS scene.rdla
    CANONICALS
        scene.exr
)

