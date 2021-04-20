import QDF
from skimage.io import imsave
from skimage.io import imread
import numpy as np
from glob import glob
import os
import matplotlib.pyplot as plt



path = r'Z:\999992-nanobiomed\Holograf\21-04-15 - 22Rv1 refractiveindex'



file_names = ['01_WP1_21-04-15_Well1_FOV1_22Rv1_idoxanol50prc_RI13846_48h_50.qdf',
              '02_WP1_21-04-15_Well1_FOV2_22Rv1_idoxanol50prc_RI13852_48h_50.qdf',
              '03_WP1_21-04-15_Well1_FOV3_22Rv1_idoxanol50prc_RI13852_48h_50.qdf',
              '04_WP1_21-04-15_Well1_FOV4_22Rv1_idoxanol50prc_RI13852_48h_50_40x.qdf',
              '05_WP1_21-04-15_Well1_FOV4_22Rv1_idoxanol50prc_RI13852_48h_50_40x_nocomp.qdf',
              ]


frames_changes = [[13,200,253,440],[21,207,271,469],[25,215,286,479],[18,180,228,352],[18,146,177,336]]



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


    plt.figure()
    plt.imshow(img1)
    plt.show()
    
    plt.figure()
    plt.imshow(img2)
    plt.show()
    
    # plt.imshow(img3)
    # plt.show()
    
    
    phi1 = np.mean(np.stack((img1,img3),axis=0),axis=0)
    
    phi2 = img2
    
    alpha = 0.18;
    lambda_ = 0.65;
    pi = np.pi
    
    nm1 = 1.3349
    nm2 = 1.3864
    
    ns = (phi1*nm2 - phi2*nm1)/(phi1-phi2)

    ns[ns<nm1] = nm1
    ns[ns>nm2] = nm2
    
    ns = ns.astype(np.float32)
        
    imsave(fname.replace('.qdf','')+'RI.tif',ns)
    
    
    hs = lambda_*(phi2 - phi1)/(2*pi*(nm1-nm2))
    imsave(fname.replace('.qdf','')+'_hs.tif',hs.astype(np.float32))

    plt.figure()
    plt.imshow(ns)
    plt.show()

    
    plt.figure()
    plt.imshow(hs)
    plt.show()




