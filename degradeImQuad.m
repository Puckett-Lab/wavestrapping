%% AMP 2013
%  Created to perform wavelet degradation of images on separate quadrants
%  This method resizes natural image and then performs wavelet resampling
%  on the entire image ny quadrant. This may also suffer from border
%  distortions. Like degradeIm.m
%  Must test for these effects if decide to go this route. 

%%
clear
%% Read image
X = imread('/data/projects/ImNatural/test_images/barbara.png');
%X = imread('/data/projects/ImNatural/scene_categories/MITcoast/image_0005.jpg');
% f1=fopen('/data/projects/ImNatural/imk00001.imc','rb','ieee-be');
% w=1536;h=1024;
% X=fread(f1,[w,h],'uint16');
% X = X';

figure
colormap(gray);
imagesc(X);
axis square

imageOrig = X;

%% Resize image
% scale = 0.5;
%imageOrig = imresize(imageOrig,scale);

%% Split image into 4 quadrants
imSz = size(imageOrig);

imOrigQuad = cell(1,4);
imOrigQuad{1} = imageOrig(1:imSz(1)/2,(imSz(2)/2)+1:imSz(2));
imOrigQuad{2} = imageOrig(1:imSz(1)/2,1:imSz(2)/2);
imOrigQuad{3} = imageOrig((imSz(1)/2)+1:imSz(1),1:imSz(2)/2);
imOrigQuad{4} = imageOrig((imSz(1)/2)+1:imSz(1),(imSz(2)/2)+1:imSz(2));

%% Wavelet degradation
%  Parameters
wv = 'db12';
cz = 1; % 1 = permute, 2 = rotate
% Levels to be permuted for each quadrant
nQuad{1} = 4:8;
nQuad{2} = 4:8;
nQuad{3} = 4:8;
nQuad{4} = 4:8;

%  Execution
imDegQuad = cell(1,4);
imDegQuad{1} = wavesurr2(imOrigQuad{1}, nQuad{1}, wv, cz);
%imDegQuad{2} = wavesurr2(imOrigQuad{2}, nQuad{2}, wv, cz);
%imDegQuad{3} = wavesurr2(imOrigQuad{3}, nQuad{3}, wv, cz);
%imDegQuad{4} = wavesurr2(imOrigQuad{4}, nQuad{4}, wv, cz);

%imDegQuad{1} = imOrigQuad{1};
imDegQuad{2} = imOrigQuad{2};
imDegQuad{3} = imOrigQuad{3};
imDegQuad{4} = imOrigQuad{4};

%% Reconstruct full image
imDegTop = horzcat(imDegQuad{2},imDegQuad{1});
imDegBot = horzcat(imDegQuad{3},imDegQuad{4});
imageDeg = vertcat(imDegTop, imDegBot);

%% Plot
figure; imagesc(imageDeg, [min(min(imageOrig)) max(max(imageOrig))])
%figure; imagesc(imageDeg,[0 255])
colormap gray; 
axis square




