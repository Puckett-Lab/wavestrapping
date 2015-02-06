% Code to compare frequency spectra across images

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
nMulti = [1 2 3 4 5 6 7 8 9]; % 868x868 affected up to level 9

figXspec=figure();
figYspec=figure();


%for j = 1:size(imName,1)
for j = 1:8

X = imread(strcat('/data/projects/ImNatural/Zurich/',imName{j},'.JPG'));
X = rgb2gray(X);

imageOrig = X;
% Change dimensions of image to 868x868
imageOrig = imresize(imageOrig, 0.5651);% 
imageOrig = imageOrig(:,round((size(imageOrig,2)-868)/2):size(imageOrig,2)-round((size(imageOrig,2)-868)/2)-1);
[specOrigX specOrigY] = spec2(imageOrig(51:818,51:818));


imageNoise = imread(strcat('/data/projects/ImNatural/noise_images/slope_1.125/',noiseName{j},'.tiff'));
[specNoiseX specNoiseY] = spec2(imageNoise);

imageDeg_multi = rectsurr2(imageOrig, nMulti, wv, cz, 19/20);
imageDeg_multi = uint8(imageDeg_multi);
imageDeg_multi_crop = imageDeg_multi(51:818,51:818); %This will be region to crop to...
[specDegX specDegY] = spec2(imageDeg_multi_crop);


figure(figXspec) 
loglog(specOrigX,'k')
hold on
loglog(specNoiseX,'b')
loglog(specDegX,'r')

figure(figYspec)
loglog(specOrigY,'k')
hold on
loglog(specNoiseY,'b')
loglog(specDegY,'r')

end




