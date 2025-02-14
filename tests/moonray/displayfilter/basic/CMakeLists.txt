# Copyright 2024 DreamWorks Animation LLC
# SPDX-License-Identifier: Apache-2.0

# Description: This test covers almost all of the display filters, and is a simple scene 
# featuring a widget sitting on a grid-patterned plane. For readability, each display filter 
# is contained in its own sidecar rdla file. 

add_rats_test(BASENAME moonray_displayfilter_basic
    INPUTS scene.rdla
           fragments/BlendDisplayFilter.rdla
           fragments/ClampDisplayFilter.rdla
           fragments/ColorCorrectDisplayFilter.rdla
           fragments/ConstantDisplayFilter.rdla
           fragments/ConvolutionDisplayFilter.rdla
           fragments/DiscretizeDisplayFilter.rdla
           fragments/DofDisplayFilter.rdla
           fragments/HalftoneDisplayFilter.rdla
           fragments/ImageDisplayFilter.rdla
           fragments/OpDisplayFilter.rdla
           fragments/OverDisplayFilter.rdla
           fragments/RampDisplayFilter.rdla
           fragments/RemapDisplayFilter.rdla
           fragments/RgbToFloatDisplayFilter.rdla
           fragments/RgbToHsvDisplayFilter.rdla
           fragments/ShadowDisplayFilter.rdla
           fragments/ToonDisplayFilter.rdla
    CANONICALS
        # --------------- BlendDisplayFilter Outputs ------------------
        blend_linear.exr
        blend_cubic.exr
        # --------------- ClampDisplayFilter Outputs ------------------           
        clamp.exr
        # --------------- ColorCorrectDisplayFilter Outputs -----------
        exposure.exr
        saturation.exr
        contrast.exr
        gamma.exr
        offset.exr
        multiply_cc.exr
        # --------------- ConstantDisplayFilter Outputs ---------------
        constant.exr
        # --------------- ConvolutionDisplayFilter Outputs ------------
        guassian.exr
        box.exr
        laplacian.exr
        sharpen.exr
        # --------------- DiscretizeDisplayFilter Outputs -------------
        discretize.exr
        # --------------- DofDisplayFilter Outputs --------------------
        dof.exr
        # --------------- HalftoneDisplayFilter Outputs ---------------
        halftone.exr
        # --------------- ImageDisplayFilter Outputs ------------------
        image_no_scale.exr
        image_stretch.exr
        image_horizontal_fit.exr
        image_vertical_fit.exr
        image_fit_by_largest_dim.exr
        image_fit_by_smallest_dim.exr
        # --------------- OpDisplayFilter Outputs ---------------------
        add.exr
        subtract.exr
        multiply.exr
        divide.exr
        min.exr
        max.exr
        power.exr
        cross.exr
        dot.exr
        invert.exr
        normalize.exr
        abs.exr
        ceil.exr
        floor.exr
        modulo.exr
        length.exr
        sine.exr
        cosine.exr
        round.exr
        acos.exr
        greater_than.exr
        greater_than_or_equal.exr
        less_than.exr
        less_than_or_equal.exr
        equal.exr
        not_equal.exr
        logic_and.exr
        logic_or.exr
        logic_not.exr
        xor.exr
        # --------------- OverDisplayFilter Outputs -----------------
        over.exr
        # --------------- RampDisplayFilter Outputs -----------------
        u_ramp.exr
        v_ramp.exr
        diagonal_ramp.exr
        radial_ramp.exr
        circular_ramp.exr
        box_ramp.exr
        input_ramp.exr
        # --------------- RemapDisplayFilter Outputs ----------------
        remap_uniform.exr
        remap_RGB.exr
        # --------------- RgbToFloatDisplayFilter Outputs -----------
        r.exr
        g.exr
        b.exr
        rgb_min.exr
        rgb_max.exr
        average.exr
        sum.exr
        luminance.exr
        # --------------- RgbToHsvDisplayFilter Outputs -------------
        rgb_to_hsv.exr
        hsv_to_rgb.exr
        # --------------- ShadowDisplayFilter Outputs ---------------
        shadow.exr
        # --------------- ToonDisplayFilter Outputs -----------------
        toon.exr
)

