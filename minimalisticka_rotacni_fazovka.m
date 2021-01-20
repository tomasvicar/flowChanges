clc;clear all;close all;


f1  = im2double(imread('cameraman.tif'));
f2 = imrotate(f1,20,'crop');

imshowpair(f1,f2,'montage')


w = hamming(size(f1,1))*hamming(size(f1,2))';


F1 = abs(fftshift(fft2(f1.*w )));
F2 = abs(fftshift(fft2(f2.*w)));


cx = size(F1,1)/2;
cy = size(F1,2)/2;
delka_pul_uhlopricky = sqrt(cx^2+cy^2);


rho = linspace(0,delka_pul_uhlopricky,size(F1,1));
theta = linspace(0,pi,size(F1,1));

[theta,rho] = meshgrid(theta,rho);
[X,Y] = pol2cart(theta,rho);  %%dělat zpernou interpolaci je snazší....
            
X = X+cx;
Y = Y+cy;

F1_polar  = interp2(F1,X,Y,'bilinear',0);
F2_polar  = interp2(F2,X,Y,'bilinear',0);


FF1 = fft2(F1_polar.*w);
FF2 = fft2(F2_polar.*w);

C = FF1 .* conj(FF2);
d = real(ifft2(C ./ abs(eps+C)));

figure;
imshow(d,[])

peak_pos = 29;%%tady dát detektor píku

rotace = theta(1,29)/pi*180;


figure
imshowpair(f1,imrotate(f2,-rotace),'montage')





