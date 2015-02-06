%% Code to compare frequency spectra across images
% "fullSize" means the original full size image was resampled THEN resized.
% This is in contrast to original way I was doing this which was to resize
% then resample. 

%%
clear

dwtmode('per')

% For natural images - Zurich
imName = {'DSCN1572'; 'DSCN2190';'DSCN2173';'DSCN2192';'DSCN1577';'DSCN2124';...
    'DSCN2123'; 'DSCN2172';'DSCN2184';'DSCN2156';'DSCN2078';'DSCN2099';...
    'DSCN2138';'DSCN2152';'DSCN2176';'DSCN2169'}

noiseName = {'01_noise'; '02_noise'; '03_noise';'04_noise'; '05_noise'; ...
    '06_noise';'07_noise'; '08_noise';'09_noise'; '10_noise'; '11_noise';...
    '12_noise'; '13_noise'; '14_noise';'15_noise'; '16_noise'}

wv = 'db6';
cz = 1; % 1 = permute, 2 = rotate
numLevels = 9; 
%nMulti = [4]; % 868x868 affected up to level 9
nMulti = [1 2 3 4 5 6 7 8 9]; % 868x868 affected up to level 9

figXspec=figure();
figYspec=figure();


for j = 1:size(imName,1)

X = imread(strcat('/data/projects/ImNatural/Zurich/',imName{j},'.JPG'));
X = rgb2gray(X);

imageOrig = X;
imageOrig = imageOrig(:,round((size(imageOrig,2)-1536)/2):size(imageOrig,2)-round((size(imageOrig,2)-1536)/2)-1);

% Get spec for original image - first crop and resize to match the degraded
imageOrigResize = imageOrig(151:1386,151:1386);
[specOrigFullX specOrigFullY] = spec2(imageOrigResize);
imageOrigResize = imresize(imageOrigResize,0.6213);
[specOrigX specOrigY] = spec2(imageOrigResize);


imageNoise = imread(strcat('/data/projects/ImNatural/noise_images/slope_1.125/',noiseName{j},'.tiff'));
[specNoiseX specNoiseY] = spec2(imageNoise);

imageNoisefullSize = imread(strcat('/data/projects/ImNatural/noise_images/slope_1.125_1236/',noiseName{j},'.tiff'));
[specNoiseFullSizeX specNoiseFullSizeY] = spec2(imageNoisefullSize);
imageNoiseResized = imresize(imageNoisefullSize,0.6213);
[specNoiseResizedX specNoiseResizedY] = spec2(imageNoiseResized);

imageDeg_multi = rectsurr2(imageOrig, nMulti, wv, cz, 19/20);
imageDeg_multi = uint8(imageDeg_multi);
imageDeg_multi_crop = imageDeg_multi(151:1386,151:1386); %This will be region to crop to...
[specDegNotResizedX specDegNotResizedY] = spec2(imageDeg_multi_crop);
imageDeg_multi_crop = imresize(imageDeg_multi_crop,0.6213);
[specDegX specDegY] = spec2(imageDeg_multi_crop);


figure(figXspec) 
loglog(specOrigX,'k') %cropped square, cropped non-degraded border, then resized
hold on
loglog(specNoiseX,'b') %noise image made to 768x768
loglog(specDegX,'r') % crop square, degrade, crop non-degraded border, then resize
%loglog(specOrigFullX,'g') %cropped only - cropped square, cropped non-degraded border
%loglog(specDegNotResizedX,'m') % crop square, degrade, crop non-degraded border
%loglog(specNoiseFullSizeX,'y')
loglog(specNoiseResizedX,'c') %noise image made larger then subjected to same resize as natural images


figure(figYspec)
loglog(specOrigY,'k')
hold on
loglog(specNoiseY,'b')
loglog(specDegY,'r')
loglog(specOrigFullY,'g')

end




