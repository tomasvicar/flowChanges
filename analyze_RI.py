import QDF
from skimage.io import imsave
from skimage.io import imread
import numpy as np
from glob import glob
import os
import matplotlib.pyplot as plt



path = r'Z:\999992-nanobiomed\Holograf\21-03-25 - PC3 refractiveindex'



file_names = ['01.qdf','02.qdf','03.qdf','04.qdf']


frames_changes = [[10,197,212,412],[9,215,241,428],[14,201,259,449],[22,212,262,452]]


for file_name,frames_change in zip(file_names,frames_changes):
    
    
    fname = path + '/' + file_name
    
    reader = QDF.reader(fname)

    main_info = reader.main_info
    
    c = 'Compensated phase'
    p = 0
    z = 0

    N = reader.ranges[c]['t']


    imgs1 = []
    for t in range(frames_change[0]):
       img = reader.get_image(c, t, p, z).reshape(600,600).astype(np.float32)
       imgs1.append(img)

    imgs2 = []
    for t in range((frames_change[2]-10),frames_change[2]):
       img = reader.get_image(c, t, p, z).reshape(600,600).astype(np.float32)
       imgs2.append(img)
       
      
    imgs3 = []
    for t in range(frames_change[3]+10,min([N,frames_change[3]+25])):
       img = reader.get_image(c, t, p, z).reshape(600,600).astype(np.float32)
       imgs3.append(img)
    


    img1 = np.median(np.stack(imgs1,axis=0),axis=0)
    
    img2 = np.median(np.stack(imgs2,axis=0),axis=0)
    
    img3 = np.median(np.stack(imgs3,axis=0),axis=0)

    # plt.imshow(img1)
    # plt.show()
    
    # plt.imshow(img2)
    # plt.show()
    
    # plt.imshow(img3)
    # plt.show()
    
    
    phi1 = np.mean(np.stack((img1,img3),axis=0),axis=0)
    
    phi2 = img2
    
    
    nm1 = 1.3353
    nm2 = 1.3864
    
    ns = (phi1*nm2 - phi2*nm1)/(phi1-phi2)

    ns[ns<nm1] = nm1
    ns[ns>nm2] = nm2
    
    ns = ns.astype(np.float32)
        
    imsave(fname.replace('.qdf','')+'RI.tif',ns)

    plt.figure()
    plt.imshow(ns)
    plt.show()
klo
    





