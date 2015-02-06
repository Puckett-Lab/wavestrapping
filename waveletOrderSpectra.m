
% Code to compare frequency spectra across wavelet order

clear

dwtmode('per')

% For natural images - Zurich
    imName = 'DSCN2190'
    X = imread(strcat('/data/projects/ImNatural/Zurich/',imName,'.JPG'));
    X = rgb2gray(X);

imageOrig = X;
imageOrig = imresize(imageOrig,1/2);%
imageOrig = imageOrig(:,round((size(imageOrig,2)-768)/2):size(imageOrig,2)-round((size(imageOrig,2)-768)/2)-1);

figure;
imagesc(imageOrig, [0 255])
colormap gray; axis square

[specOrigX specOrigY] = spec2(imageOrig(40:708,40:708));


%wv = {'sym2'; 'sym4'; 'sym6'; 'sym8'; 'sym10'; 'sym12'};
wv = {'db1'; 'db3'; 'db5'; 'db7'; 'db9'; 'db11'};
cz = 1; % 1 = permute, 2 = rotate
numLevels = 8; % 8 is maximum? why?
nMulti = [1 2 3 4 5 6 7 8 9]; % 768x768 affected up to level 9


figSample=figure(); %Create a figure and save the figure handle in a variable
figXspec=figure();
figYspec=figure();

for k = 1:size(wv,1)

%% Sample image
for i=1:1;
    imageDeg_multi = rectsurr2(imageOrig, nMulti, wv{k}, cz,19/20);
    imageDeg_multi = uint8(imageDeg_multi);

%     figure; imagesc(imageDeg_multi, [0 255])
%     colormap gray; axis square
    
    imageDeg_multi_crop = imageDeg_multi(40:708,40:708); %This will be region to crop to...
    figure(figSample)
    subplot(2,3,k);   
    imagesc(imageDeg_multi_crop, [0 255])
    colormap gray; axis square
    title(wv{k})
end
end
mtit('Sample Images - Degrade Scale 4')


for k = 1:size(wv,1)

%% Spectra
figure(figXspec)
subplot(2,3,k); loglog(specOrigX,'k', 'LineWidth', 2);
hold on

figure(figYspec)
subplot(2,3,k); loglog(specOrigY,'k', 'LineWidth', 2);
hold on

for i=1:50;
    imageDeg_multi = rectsurr2(imageOrig, nMulti, wv{k}, cz,19/20);
    imageDeg_multi = uint8(imageDeg_multi);

%     figure; imagesc(imageDeg_multi, [0 255])
%     colormap gray; axis square
    
    imageDeg_multi_crop = imageDeg_multi(40:708,40:708); %This will be region to crop to...
%     figure; imagesc(imageDeg_multi_crop, [0 255])
%     colormap gray; axis square
    
    [specDegX specDegY] = spec2(imageDeg_multi_crop);
    figure(figXspec)
    subplot(2,3,k); loglog(specDegX, 'Color',[0.5 0.5 0.5])
    
    figure(figYspec)
    subplot(2,3,k); loglog(specDegY, 'Color',[0.5 0.5 0.5])    

end
figure(figXspec)
subplot(2,3,k); loglog(specOrigX,'k', 'LineWidth', 2);
title(wv{k})

figure(figYspec)
subplot(2,3,k); loglog(specOrigY,'k', 'LineWidth', 2);
title(wv{k})


end
figure(figXspec)
mtit('Horizontal Spectra - Degrade Scale 4')

figure(figYspec)
mtit('Vertical Spectra - Degrade Scale 4')