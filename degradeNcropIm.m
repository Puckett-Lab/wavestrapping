%% Code for wavelet resampling natural images
%  This method performs wavelet resampling on an image but leaves a border
%  unaffected (by using rectsurr2.m). The border is then cropped. The way
%  this code currently stands the image is first resized then the
%  resampling is performed. This has since been improved upon as we now
%  resample and then resize. 
%  See createImages.m for more current approach. 

%%

clear

dwtmode('per')


% For natural images - Zurich
    imName = 'DSCN1572'
    X = imread(strcat('/data/projects/ImNatural/Zurich/',imName,'.JPG'));
    X = rgb2gray(X);



imageOrig = X;

% For natural images - Zurich
imageOrig = imresize(imageOrig,1/2);%
imageOrig = imageOrig(:,round((size(imageOrig,2)-768)/2):size(imageOrig,2)-round((size(imageOrig,2)-768)/2)-1);
 


figure;
imagesc(imageOrig, [0 255])
%imagesc(imageOrig, [min(min(imageOrig)) max(max(imageOrig))])
colormap gray; axis square
%specOrig = spec2(imageOrig,'k',1,1);
%figure; plot(specOrig);

wv = 'db12';
cz = 1; % 1 = permute, 2 = rotate
numLevels = 9; 
nMulti = [1 3 4 5 6 7 8 9];

%% Non-iterative approach
%for nMulti=[2 4] %This is for individual scales degraded separately
for i=1:1;
    imageDeg_multi = rectsurr2(imageOrig, nMulti, wv, cz,4/5);
    imageDeg_multi = uint8(imageDeg_multi);
    
    figure; imagesc(imageDeg_multi, [0 255])
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

imageDeg_multi_crop = imageDeg_multi(128:639,128:639); %This will be region to crop to...
figure; imagesc(imageDeg_multi_crop, [0 255])
colormap gray; axis square
    

%% Each level individually
%  imageDeg = cell(1,numLevels);
%      for n = 1:numLevels
%          imageDeg{n} = wavesurr2(imageOrig,n,wv,cz);
%          imageDeg{n} = uint8(imageDeg{n});
%      end
% 
%  
%   
%   
%  % % 
% figure
% for n = 1:numLevels
%     subplot(2,6,n)
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

