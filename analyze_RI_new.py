import QDF
from skimage.io import imsave
from skimage.io import imread
import numpy as np
from glob import glob
import os
import matplotlib.pyplot as plt



path = r'D:\22-02-03 - Shear PC3 refractiveindex_processed2\image_selection'

file_names = glob(path + '/*.qdf')


for file_num in range(40,46):
    
    for name_part in [str(file_num) + '_' + 'pred',str(file_num) + '_' + 'po']:
    

        fname = path + '/' + name_part + '/' + 'ido.tiff'
    
        ido = imread(path + '/' + name_part + '/' + 'ido.tiff')
    
        med = imread(path + '/' + name_part + '/' + 'med.tiff')
        
        
        
        phi1 = med
        
        phi2 = ido
        
        alpha = 0.18;
        lambda_ = 0.65;
        pi = np.pi
        
        nm1 = 1.3349
        nm2 = 1.3864
        
        ns = (phi1*nm2 - phi2*nm1)/(phi1-phi2)

        ns[ns<nm1] = nm1
        ns[ns>nm2] = nm2
        
        ns = ns.astype(np.float32)
            
        imsave(fname.replace('ido.tiff','')+'RI.tif',ns)
        
        
        hs = lambda_*(phi2 - phi1)/(2*pi*(nm1-nm2))
        imsave(fname.replace('ido.tiff','')+'_hs.tif',hs.astype(np.float32))


        plt.figure()
        plt.imshow(ns)
        plt.show()

        
        plt.figure()
        plt.imshow(hs)
        plt.show()
    
    
    
