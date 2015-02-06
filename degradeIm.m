%% Code for wavelet resampling natural images
%  This method resizes natural image and then performs wavelet resampling
%  on the entire image. This has since been improved upon. See
%  degradeNcropIm.m and createImages.m for more current approaches. 

%%
clear

dwtmode('per')

%load('woman');
%X = imread('/data/projects/ImNatural/test_images/barbara.png');

% For natural images - Zurich
    imName = 'DSCN1572'
    X = imread(strcat('/data/projects/ImNatural/Zurich/',imName,'.JPG'));
    X = rgb2gray(X);

% For Noise image
% imName = '01_noise_1_512_036'
% X = imread(strcat('/data/projects/ImNatural/ImDegrade/noise/',imName,'.tiff'));

% For already degraded image
%imName = 'DSCN1572_n1235678_wvdb12_cz1_2'
%X = imread(strcat('/data/projects/ImNatural/ImDegrade/01_n1235678_cz1/',imName,'.tiff'));

% f1=fopen('/data/projects/ImNatural/vanHateren/imk00006.imc','rb','ieee-be');
% w=1536;h=1024;
% X=fread(f1,[w,h],'uint16');
% X = X';
% X = X(:,512/2+1:size(X,2)-512/2);


imageOrig = X;
%imageOrig = X(:,:,1);

% For natural images - Zurich
imageOrig = imresize(imageOrig,1/3);% 
imageOrig = imageOrig(:,round((size(imageOrig,2)-512)/2):size(imageOrig,2)-round((size(imageOrig,2)-512)/2));



figure;
imagesc(imageOrig, [0 255])
%imagesc(imageOrig, [min(min(imageOrig)) max(max(imageOrig))])
colormap gray; axis square
%specOrig = spec2(imageOrig,'k',1,1);
%figure; plot(specOrig);
%xlim([0 125])
%ylim([1000000 10000000])

wv = 'db12';
cz = 1; % 1 = permute, 2 = rotate
numLevels = 8; % 8 is maximum? why?
nMulti = [1 2 3 4 5 6 7 8];

%% Non-iterative approach
%for nMulti=[2 4] %This is for individual scales degraded separately
for i=1:1;
    imageDeg_multi = wavesurr2(imageOrig, nMulti, wv, cz);
    imageDeg_multi = uint8(imageDeg_multi);
    %imageDeg_multi = quadsurr2(imageOrig, nMulti, wv, cz,[1 0 0 0]);
    %imageDeg_multi = elipsurr2(imageOrig, nMulti, wv, cz,[100 100]);

    figure; imagesc(imageDeg_multi, [0 255])
    %figure; imagesc(imageDeg_multi, [min(min(imageOrig)) max(max(imageOrig))])
    colormap gray; axis square
    
     %specDeg_multi = spec2(imageDeg_multi,'k',1,1);
    
     %figure; plot(specDeg_multi);

    %imwrite(imageDeg_multi,strcat('/data/projects/ImNatural/ImDegrade/',imName,'_n',num2str(nMulti),'_wv',wv,'_cz',num2str(cz),'_',num2str(i),'.tiff'))
    
    %For simultaneous n
    %imwrite(imageDeg_multi,strcat('/data/projects/ImNatural/ImDegrade/',imName,'_n','1345678','_wv',wv,'_cz',num2str(cz),'_',num2str(i),'.tiff'))
    
    % For natural image --> noise
    %imwrite(imageDeg_multi,strcat('/data/projects/ImNatural/ImDegrade/',imName,'_noise_',num2str(i),'.tiff'))
end
%end


%% Iterative approach
%  imageDeg = cell(1,numLevels);
% 
%  %specDeg = cell(1,numLevels);
%   for i = 1:1
%      imageIter = imageOrig;
%      for n = 1:numLevels
%          imageDeg{n} = wavesurr2(imageIter,n,wv,cz);
%          imageDeg{n} = uint8(imageDeg{n});
%          %imageDeg{n} = quadsurr2(imageOrig,n,wv,cz,[1 0 0 0]);
%          %specDeg{n} = spec2(imageDeg{n});
%          imageIter = imageDeg{n}; %iteratively degrades various scales
%      end
%      specDeg_iter = spec2(imageDeg{numLevels},'k',1,1);
%      %figure; plot(specDeg_iter);
%      imwrite(imageDeg{numLevels},strcat('/data/projects/ImNatural/ImDegrade/',imName,'_n','12345678_iter','_wv',wv,'_cz',num2str(cz),'_',num2str(i),'.tiff'))
%   end
 
  
  
 % % 
% figure
% for n = 1:numLevels
%     subplot(2,4,n)
%     imagesc(imageDeg{n},[0 255])
%     %imagesc(imageDeg{n},[min(min(imageOrig)) max(max(imageOrig))])
%     colormap gray
%     axis square
% end
% % 
% % % figure
% % % for n = 1:numLevels
% % %     subplot(2,5,n)
% % %     plot(specDeg{n})
% % % end


%imwrite(imageOrig,strcat('/data/projects/ImNatural/ImDegrade/natural/16_',imName,'_gray','.tiff'));

