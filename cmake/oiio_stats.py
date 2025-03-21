#! /bin/env python

# This script reports the OIIO stats from an image, in the same way as
# 'iinfo --stats' and 'oiiotool --stats'.  However, the output of both
# of those tools is limited to 6 decimal places of precision, making
# them useless for very small values.

# This script prints the full precision values using the OIIO python
# bindings

import sys
import OpenImageIO as oiio
from OpenImageIO import ImageInput, ImageOutput
from OpenImageIO import ImageBuf, ImageSpec, ImageBufAlgo

diff_image = sys.argv[1]
diff_buffer = ImageBuf(diff_image)
stats = ImageBufAlgo.computePixelStats(diff_buffer)

# mimic output of oiiotool --stats
print("    Stats Min: ", *stats.min)
print("    Stats Max: ", *stats.max)
print("    Stats Avg: ", *stats.avg)
print("    Stats StdDev: ", *stats.stddev)
print("    Stats NanCount: ", *stats.nancount)
print("    Stats InfCount: ", *stats.infcount)
print("    Stats FiniteCount: ", *stats.finitecount)
