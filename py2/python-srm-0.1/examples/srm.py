#! /usr/bin/env python

import sys
from scipy.misc import imread
from matplotlib import pyplot

from SRM import SRM

q = int(sys.argv[1])
im = imread(sys.argv[2])

srm = SRM(im, q)
segmented = srm.run()

pyplot.imshow(segmented/256)
pyplot.show()

