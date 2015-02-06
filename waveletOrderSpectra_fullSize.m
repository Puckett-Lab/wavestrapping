%% Code to compare frequency spectra across wavelet order
% "fullSize" means the original full size image was resampled THEN resized.
% This is in contrast to original way I was doing this which was to resize
% then resample. 


%%
clear

dwtmode('per')

% For natural images - Zurich
    imName = 'DSCN1572'
    X = imread(strcat('/data/projects/ImNatural/Zurich/',imName,'.JPG'));
    X = rgb2gray(X);

imageOrig = X;
%imageOrig = imresize(imageOrig,1/2);%
imageOrig = imageOrig(:,round((size(imageOrig,2)-1536)/2):size(imageOrig,2)-round((size(imageOrig,2)-1536)/2)-1);

figure;
imagesc(imageOrig, [0 255])
colormap gray; axis square


imageOrigResize = imageOrig(151:1386,151:1386);
imageOrigResize = imresize(imageOrigResize,0.6213);
[specOrigX specOrigY] = spec2(imageOrigResize);


%wv = {'sym2'; 'sym4'; 'sym6'; 'sym8'; 'sym10'; 'sym12'};
wv = {'db2'; 'db4'; 'db6'; 'db8'; 'db10'; 'db12'};
cz = 1; % 1 = permute, 2 = rotate
numLevels = 8; % 8 is maximum? why?
nMulti = [1 2 3 4 5 6 7 8 9 10]; % 1536x1536 affected up to level 10


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
    
    imageDeg_multi_crop = imageDeg_multi(151:1386,151:1386); %This will be region to crop to...
    figure(figSample)
    subplot(2,3,k);   
    imagesc(imageDeg_multi_crop, [0 255])
    colormap gray; axis square
    title(wv{k})
end
end
mtit('Sample Images - Degrade All Scales')


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
    
    imageDeg_multi_crop = imageDeg_multi(151:1386,151:1386); %This will be region to crop to...
    imageDeg_multi_crop = imresize(imageDeg_multi_crop,0.6213);
    
    
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
mtit('Horizontal Spectra - Degrade All Scales')

figure(figYspec)
mtit('Vertical Spectra - Degrade All Scales')