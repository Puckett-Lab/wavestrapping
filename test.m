load('woman')
origX = X;
%X = uint8(X);
sX = wavesurr2(X,[1 2 3 4 5 6 7 8]);
%sX = uint8(sX);
sX2 = sX;
N=256;           %number of voxels for this image
X=X(:);           %Natural image; e.g. loadwbarb 
sX=sX(:);       %wavelet shuffled image
M(:,1)=sX; M(:,2)=1:N^2;
M=sortrows(M,1);
M(:,1)=sortrows(X);
M=sortrows(M,2);
Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one
imwrite(uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B2/Degrade_Adjust.tiff'))
imwrite(uint8(sX2),strcat('/data/projects/ImNatural/ImDegrade/B2/Degrade.tiff'))

sX2min = min(min(sX2));
sX2_scaled = sX2 + abs(sX2min);
sX2max = max(max(sX2_scaled));
sX2_scaled = sX2_scaled./sX2max;
sX2_scaled = (sX2_scaled.*255);
imwrite(uint8(sX2_scaled),strcat('/data/projects/ImNatural/ImDegrade/B2/Degrade_scaled.tiff'))


Ymin = min(min(Y));
Y_scaled = Y + abs(Ymin);
Ymax = max(max(Y_scaled));
Y_scaled = Y_scaled./Ymax;
Y_scaled = (Y_scaled.*255);
imwrite(uint8(Y_scaled),strcat('/data/projects/ImNatural/ImDegrade/B2/Degrade_scaled_Adjust.tiff'))


inImage = imread(strcat('/data/projects/ImNatural/Zurich/DSCN1572.JPG'));
inImage = rgb2gray(inImage);
imOrig = im2double(inImage);
imageOrigResize = imOrig(111:1426,111:1426);
imageOrigResize = imresize(imageOrigResize,0.5835);
origX = imageOrigResize;
%X = uint8(X);
sX = wavesurr2(origX,[1 2 3 4 5 6 7 8]);
%sX = uint8(sX);
sX2 = sX;
N=768;           %number of voxels for this image
X=origX(:);           %Natural image; e.g. loadwbarb 
sX=sX(:);       %wavelet shuffled image
M(:,1)=sX; M(:,2)=1:N^2;
M=sortrows(M,1);
M(:,1)=sortrows(X);
M=sortrows(M,2);
Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one
imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B2/Degrade_Adjust_imfuns.tiff'))
imwrite(im2uint8(sX2),strcat('/data/projects/ImNatural/ImDegrade/B2/Degrade_imfuns.tiff'))

inImageResize = inImage(111:1426,111:1426);
inImageResize = imresize(inImageResize,0.5835);
inImageResizeDeg = wavesurr2(inImageResize,[1 2 3 4 5 6 7 8]);
imwrite(uint8(inImageResizeDeg),strcat('/data/projects/ImNatural/ImDegrade/B2/Degrade_clipping.tiff'))
