
import QDF
from tifffile import TiffWriter
from tifffile import imread
import numpy as np
from glob import glob
import os


# path = r'Z:\999992-nanobiomed\Holograf\21-01-29 - Shearsress CytD 10um 4h vs untreated PC3 48h pos seed'


# path = r'Z:\999992-nanobiomed\Holograf\21-03-25 - Shearstress 22Rv1'

# path = r'Z:\999992-nanobiomed\Holograf\21-03-25 - PC3 refractiveindex\PC3_vymenamedia_hs+vypocitane_h\height+RI_vymenamedia'

# path = r'Z:\999992-nanobiomed\Holograf\22-01-26 - Shear 22Rv1-vzestup_potreti'

path = r'Z:\999992-nanobiomed\Holograf\22-02-03 - Shear PC3 konfluence_processed'


filenames =  glob(path + os.sep + '*.qdf')


for fname in filenames[11:]:
    
    
    save_folder = fname[:-4]
    fname_save = save_folder + os.sep +'Compensated phase - [0000, 0000].tiff'
    fname_time_save = save_folder + os.sep +'time.txt'
    
    if not os.path.exists(save_folder):
        os.mkdir(save_folder)
    
    
    
    reader = QDF.reader(fname)
    main_info = reader.main_info
    
    
    with open(fname_time_save, 'w') as txt_writer:
    
        with TiffWriter(fname_save,bigtiff=True) as tif:
    
            
            c = 'Compensated phase'
            p = 0
            z = 0
            
            for t in range(reader.ranges[c]['t'] + 1):  ##### není v ve tvé verzi +1? 
                
                print(t)
                
                if t ==1:######################################################################je to nutné ve tvojí verzi? v jedné verzi chyběl timepoint 1 dat
                    continue;
                
                img = reader.get_image(c, t, p, z).reshape(600,600).astype(np.float32)

                img = img * 0.65/(2 * np.pi * 0.18)
            
            
                img_info = reader.get_image_info(c, t, p, z)   
                
                txt_writer.write(img_info['image info']['time'] + '\n')
                tif.write(img ,compression = 0)
            


tmp = imread(fname_save,key=t-1)
print(np.sum(np.abs(img - tmp )))





