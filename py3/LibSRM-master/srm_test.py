import matplotlib.pyplot as plt
import numpy as np
from scipy import ndimage as ndi
from skimage import io, img_as_float, segmentation, filters
from skimage.measure import regionprops, label
#img_as_ubyte
from skimage.exposure import equalize_hist
from skimage import restoration as rt

from pysrm import srm

if __name__ == '__main__':
    minSize = 50
    img = io.imread('data/rocks.png')
    img2 = rt.denoise_bilateral(img_as_float(img),sigma_color=0.05,sigma_spatial=5,multichannel = False)

  #img = img_as_ubyte(equalize_hist(img))
  # img = ndi.median(io.imread('data/rocks.png').astype(np.uint8))
    #img = img
    #img = img_as_ubyte(equalize_hist(img))

    avg_out, lbl_out = srm.segment(img2, q=32)
    #segm
    mask = avg_out > filters.threshold_otsu(avg_out)
    mask = segmentation.clear_border(mask)
    labels = label(mask)
    result = np.zeros_like(mask)
    for R in regionprops(labels):
        if R.area > minSize:
            for c in R.coords:
                result[c[0],c[1]]=1


    #Visualization for debugging
    print(avg_out.shape)
    print(type(avg_out))
    fig = plt.figure(figsize=(15,15))
    ax1 = fig.add_subplot(2,2,1)
    ax1.imshow(img, cmap='gray')
    ax1.set_axis_off()
    ax1.set_title('Original')

    ax2 = fig.add_subplot(2,2,2)
    ax2.imshow(img2, cmap='gray')
    ax2.set_axis_off()
    ax2.set_title('Filtered')

    ax3 = fig.add_subplot(2,2,3)
    ax3.imshow(avg_out, cmap='plasma')
    ax3.set_axis_off()
    ax3.set_title('Clustered')

    ax4 = fig.add_subplot(2,2,4)
    ax4.imshow(result, cmap='gray')
    ax4.set_axis_off()
    ax4.set_title('Segmented')


    #plt.imshow(avg_out)
