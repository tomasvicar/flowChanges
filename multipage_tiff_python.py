

from tifffile import TiffWriter
from tifffile import imread, imsave
import numpy as np




img = np.random.randn(3,50,40).astype(np.float32)
name = 'test.tiff'


# imsave(fname_save,imgs,'bigtiff',compress = 0)


with TiffWriter(name,bigtiff=True) as tif:
    
    for k in range(img.shape[0]):
    
        tif.write(img[k,:,:] ,compress = 0)
        

    
    
    ###https://github.com/scikit-image/scikit-image/blob/v0.14.3/skimage/external/tifffile/tifffile.py#L499
    # compress : int or 'lzma'
    # Values from 0 to 9 controlling the level of zlib compression.
    # If 0, data are written uncompressed (default).
    # Compression cannot be used to write contiguous files.
    # If 'lzma', LZMA compression is used, which is not available on
    # all platforms.



img2 = imread(name,key = range(3))


print(np.sum(np.abs(img - img2 )))



