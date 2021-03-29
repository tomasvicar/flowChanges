import QDF
from skimage.io import imsave
from skimage.io import imread
import numpy as np
from glob import glob
import os
import matplotlib.pyplot as plt


# path = r'Z:\999992-nanobiomed\Holograf\21-03-25 - PC3 refractiveindex'
# file_names = ['01.qdf','02.qdf','03.qdf','04.qdf']
# output_folder = r'Z:\999992-nanobiomed\Holograf\21-03-25 - PC3 refractiveindex\height_RIdata'



path = r'Z:\999992-nanobiomed\Holograf\21-03-25 - PC3 cellight_gfp'
file_names = ['01.qdf','02.qdf','03.qdf','04.qdf','05.qdf','06.qdf','07.qdf']
output_folder = r'Z:\999992-nanobiomed\Holograf\21-03-25 - PC3 refractiveindex\height_GFPdata'






for file_name in file_names:
    
    
    fname = path + '/' + file_name
    
    reader = QDF.reader(fname)

    main_info = reader.main_info
    
    c = 'Compensated phase'
    p = 0
    z = 0


    alpha = 0.18;
    lambda_ = 0.65;
    pi = np.pi
    
    nm = 1.3349

    ns = 1.3588

    t = 0
    img = reader.get_image(c, t, p, z).reshape(600,600).astype(np.float32)


    
    
    
    img_h = (img*lambda_)/(2*pi*(ns-nm))
    
    plt.figure()
    plt.imshow(img_h)
    plt.show()

    imsave(fname.replace('.qdf','').replace(path,output_folder)+'_h.tif',img_h)
    
    






