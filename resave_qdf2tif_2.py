
import QDF
from tifffile import TiffWriter
from tifffile import imread, imsave
import numpy as np
from glob import glob
import os


path = r'Z:\999992-nanobiomed\Holograf\21-01-26 - Shearstress 24h-4h PC3'


filenames =  glob(path + os.sep + '*.qdf')


for fname in filenames:
    
    
    save_folder = fname[:-4]
    fname_save = save_folder + os.sep +'Compensated phase - [0000, 0000].tiff'
    fname_time_save = save_folder + os.sep +'time.txt'
    
    if not os.path.exists(save_folder):
        os.mkdir(save_folder)
    
    
    
    reader = QDF.reader(fname)
    main_info = reader.main_info
    
    
    
    with open(fname_time_save, 'w') as txt_writer:

        c = 'Compensated phase'
        p = 0
        z = 0
        imgs = np.zeros((reader.ranges[c]['t'] + 1,600,600),dtype = np.float32)
        
        for t in range(reader.ranges[c]['t'] + 1):
            img = reader.get_image(c, t, p, z).reshape(600,600).astype(np.float32)
            
            
            img = img * 0.65/(2 * np.pi * 0.18)
            
            imgs[t,:,:] = img
            
            img_info = reader.get_image_info(c, t, p, z)   
            
            txt_writer.write(img_info['image info']['time'] + '\n')
            
            
        imsave(fname_save,imgs,'bigtiff',compress = 0)
            
    break


tmp = imread(fname_save,key=t)
print(np.sum(np.abs(img - tmp )))





