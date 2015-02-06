%% Creates images for natural image project
%  Currently set up to create images for pilot experiment. See powerpoint
%  Paradigm_v3.pptx slide 3 for description of blocks

clear
dwtmode('per')

%% Inputs

% For natural images - Zurich
imName = {'DSCN1572';...
    'DSCN2190';'DSCN2173';'DSCN2192';'DSCN1577';'DSCN2124';...
    'DSCN2123'; 'DSCN2172';'DSCN2184';'DSCN2156';'DSCN2078';'DSCN2179';...
    'DSCN2138';'DSCN2152';'DSCN2176';'DSCN2169'; 'DSCN1573'; 'DSCN1578';...
    'DSCN1579'; 'DSCN2087';'DSCN2101';'DSCN2141';'DSCN2174';'DSCN2144'; ...
    'DSCN1575';'DSCN1574';'DSCN1576';'DSCN2164'; 'DSCN2145'; 'DSCN2128';...
    'DSCN2119'; 'DSCN2189';'DSCN2122';'DSCN2126';'DSCN2135';'DSCN2137';...
    'DSCN2139';'DSCN2142';'DSCN2149';'DSCN2153'; 'DSCN2155'; 'DSCN2167'; ...
    'DSCN2170';'DSCN2175';'DSCN2181';'DSCN2183';'DSCN2185';'DSCN2187';...
    'DSCN2188';'DSCN2191'};

wv = 'db6';
cz = 1; % 1 = permute, 2 = rotate
numLevels = 10; 
nNoise = [1 2 3 4 5 6 7 8 9 10]; % 1536x1536 affected up to level 10
nS1 = 3;
%nS1 = [ 1 2 3 4 5 6 7 8 9 10];
nS2 = 5;
nS12 = [3 5];
nAllButS12 = [1 2 4 6 7 8 9 10];

N = 768;
origImageDim = [1536 1536];

%nAllButS1 = [1 2 4 5 6 7 8 9 10];
%nAllButS2 = [1 2 3 4 6 7 8 9 10];
%figXspec=figure();
%figYspec=figure();


%% Image creation
for j = 20:20
    

    inImage = imread(strcat('/data/projects/ImNatural/Zurich/',imName{j},'.JPG'));
    inImage = rgb2gray(inImage);

    imageOrig = im2double(inImage);
    imageOrig = imageOrig(:,round((size(imageOrig,2)-1536)/2):size(imageOrig,2)-round((size(imageOrig,2)-1536)/2)-1);

    % All image blocks:
    % B1, B2_1, B7_1
    imageOrigResize = imageOrig(111:1426,111:1426);
    imageOrigResize = imresize(imageOrigResize,0.5835);
    imwrite(im2uint8(imageOrigResize),strcat('/data/projects/ImNatural/ImDegrade/B1/N1S0F0R0_',num2str(j),'_1.tiff'))
    imwrite(im2uint8(imageOrigResize),strcat('/data/projects/ImNatural/ImDegrade/B2/N1S1F1R1_',num2str(j),'_1.tiff'))
    imwrite(im2uint8(imageOrigResize),strcat('/data/projects/ImNatural/ImDegrade/B7/N1S2F1R1_',num2str(j),'_1.tiff'))
    %figure; imagesc(imageOrigResize); colormap gray; axis square

    % B2_2
    imageN1S1F1R1 = rectsurr2(imageOrig, nS1, wv, cz, 19/20);
    imageN1S1F1R1Resize = imageN1S1F1R1(111:1426,111:1426); %This will be region to crop to...
    imageN1S1F1R1Resize = imresize(imageN1S1F1R1Resize,0.5835);

    %Adjust amplitudes so histogram of degraded iamge matches natural
    X=imageOrigResize(:);           %Natural image; e.g. loadwbarb 
    sX=imageN1S1F1R1Resize(:);       %wavelet shuffled image
    M(:,1)=sX; M(:,2)=1:N^2;
    M=sortrows(M,1);
    M(:,1)=sortrows(X);
    M=sortrows(M,2);
    Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one



    %imwrite(imageN1S1F1R1Resize,strcat('/data/projects/ImNatural/ImDegrade/B2/N1S1F1R1_',num2str(j),'_2.tiff'))
    imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B2/N1S1F1R1_',num2str(j),'_2.tiff'))
    clear sX M Y

    % B3
    for k = 1:16
        imageN1S1F2R1 = rectsurr2(imageOrig, nS1, wv, cz, 19/20);
        imageN1S1F2R1Resize = imageN1S1F2R1(111:1426,111:1426); %This will be region to crop to...
        imageN1S1F2R1Resize = imresize(imageN1S1F2R1Resize,0.5835);

        %Adjust amplitudes so histogram of degraded iamge matches natural
        sX=imageN1S1F2R1Resize(:);       %wavelet shuffled image
        M(:,1)=sX; M(:,2)=1:N^2;
        M=sortrows(M,1);
        M(:,1)=sortrows(X);
        M=sortrows(M,2);
        Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one

        imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B3/N1S1F2R1_',num2str(j),'_',num2str(k),'.tiff'))
        clear sX M Y
    end

    % B7_2
    imageN1S2F1R1 = rectsurr2(imageOrig, nS2, wv, cz, 19/20);
    imageN1S2F1R1Resize = imageN1S2F1R1(111:1426,111:1426); %This will be region to crop to...
    imageN1S2F1R1Resize = imresize(imageN1S2F1R1Resize,0.5835);
    
    %Adjust amplitudes so histogram of degraded iamge matches natural
    sX=imageN1S2F1R1Resize(:);       %wavelet shuffled image
    M(:,1)=sX; M(:,2)=1:N^2;
    M=sortrows(M,1);
    M(:,1)=sortrows(X);
    M=sortrows(M,2);
    Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one
    
    imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B7/N1S2F1R1_',num2str(j),'_2.tiff'))
    clear sX M Y

    % B8
    for k = 1:16
        imageN1S2F2R1 = rectsurr2(imageOrig, nS2, wv, cz, 19/20);
        imageN1S2F2R1Resize = imageN1S2F2R1(111:1426,111:1426); %This will be region to crop to...
        imageN1S2F2R1Resize = imresize(imageN1S2F2R1Resize,0.5835);

        %Adjust amplitudes so histogram of degraded iamge matches natural
        sX=imageN1S2F2R1Resize(:);       %wavelet shuffled image
        M(:,1)=sX; M(:,2)=1:N^2;
        M=sortrows(M,1);
        M(:,1)=sortrows(X);
        M=sortrows(M,2);
        Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one

        imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B8/N1S2F2R1_',num2str(j),'_',num2str(k),'.tiff'))
        clear sX M Y
    end

    % ----------------

    % All noise blocks:
    imageNoiseAllButS12 = rectsurr2(imageOrig, nAllButS12, wv, cz, 19/20);
    
    %Adjust amplitude so histogram of degraded image matches natural
    X_notResized=imageOrig(:);           %Natural image; e.g. loadwbarb 
    sX=imageNoiseAllButS12(:);       %wavelet shuffled image
    M(:,1)=sX; M(:,2)=1:origImageDim(1)*origImageDim(2);
    M=sortrows(M,1);
    M(:,1)=sortrows(X_notResized);
    M=sortrows(M,2);
    Y=reshape(M(:,1),origImageDim(1),origImageDim(2));   %surrogate image with amplitude spectra of natural one
        
    imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/imageNoiseAllButS12_',num2str(j),'_Father.tiff'))
    clear sX M Y

    
    imageNoise = rectsurr2(imageNoiseAllButS12, nS12, wv, cz, 19/20);
    %Adjust amplitude so histogram of degraded image matches natural
    sX=imageNoise(:);       %wavelet shuffled image
    M(:,1)=sX; M(:,2)=1:origImageDim(1)*origImageDim(2);
    M=sortrows(M,1);
    M(:,1)=sortrows(X_notResized);
    M=sortrows(M,2);
    Y=reshape(M(:,1),origImageDim(1),origImageDim(2));   %surrogate image with amplitude spectra of natural one
    
    imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B12/imageNoise_',num2str(j),'_Father.tiff'))
    clear sX M Y

    %B4 and B5
    for k = 1:16
        imageN2S1F2R1_Child = rectsurr2(imageNoise, nS1, wv, cz, 19/20);
        imageN2S1F2R1_ChildResize = imageN2S1F2R1_Child(111:1426,111:1426); %This will be region to crop to...
        imageN2S1F2R1_ChildResize = imresize(imageN2S1F2R1_ChildResize,0.5835);
        
        %Adjust amplitudes so histogram of degraded iamge matches natural
        sX=imageN2S1F2R1_ChildResize(:);       %wavelet shuffled image
        M(:,1)=sX; M(:,2)=1:N^2;
        M=sortrows(M,1);
        M(:,1)=sortrows(X);
        M=sortrows(M,2);
        Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one
        
        if k == 1 || k == 2
            imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B4/N2S1F1R1_',num2str(j),'_',num2str(k),'.tiff'))
            imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B5/N2S1F2R1_',num2str(j),'_',num2str(k),'.tiff'))
        else
            imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B5/N2S1F2R1_',num2str(j),'_',num2str(k),'.tiff'))
        end
        clear sX M Y
    end

    % B6
    imageN3S1F1R1_Father = rectsurr2(imageNoiseAllButS12, nS2, wv, cz, 19/20);
    %Adjust amplitude so histogram of degraded image matches natural
    sX=imageN3S1F1R1_Father(:);       %wavelet shuffled image
    M(:,1)=sX; M(:,2)=1:origImageDim(1)*origImageDim(2);
    M=sortrows(M,1);
    M(:,1)=sortrows(X_notResized);
    M=sortrows(M,2);
    Y=reshape(M(:,1),origImageDim(1),origImageDim(2));   %surrogate image with amplitude spectra of natural one
        
    imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B6/N3S1F1R1_',num2str(j),'_Father.tiff'))
    clear sX M Y
    
    imageN3S1F1R1_FatherResize = imageN3S1F1R1_Father(111:1426,111:1426); %This will be region to crop to...
    imageN3S1F1R1_FatherResize = imresize(imageN3S1F1R1_FatherResize,0.5835);
    
    %Adjust amplitudes so histogram of degraded iamge matches natural
    sX=imageN3S1F1R1_FatherResize(:);       %wavelet shuffled image
    M(:,1)=sX; M(:,2)=1:N^2;
    M=sortrows(M,1);
    M(:,1)=sortrows(X);
    M=sortrows(M,2);
    Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one
        
    imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B6/N3S1F1R1_',num2str(j),'_1.tiff'))
    clear sX M Y

    imageN3S1F1R1_Child = rectsurr2(imageN3S1F1R1_Father, nS1, wv, cz, 19/20);
    imageN3S1F1R1_ChildResize = imageN3S1F1R1_Child(111:1426,111:1426); %This will be region to crop to...
    imageN3S1F1R1_ChildResize = imresize(imageN3S1F1R1_ChildResize,0.5835);
    
    %Adjust amplitudes so histogram of degraded iamge matches natural
    sX=imageN3S1F1R1_ChildResize(:);       %wavelet shuffled image
    M(:,1)=sX; M(:,2)=1:N^2;
    M=sortrows(M,1);
    M(:,1)=sortrows(X);
    M=sortrows(M,2);
    Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one
    
    imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B6/N3S1F1R1_',num2str(j),'_2.tiff'))
    clear sX M Y
    
    
    % B9 and B10 
    for k = 1:16
        imageN2S2F2R1_Child = rectsurr2(imageNoise, nS2, wv, cz, 19/20);
        imageN2S2F2R1_ChildResize = imageN2S2F2R1_Child(111:1426,111:1426); %This will be region to crop to...
        imageN2S2F2R1_ChildResize = imresize(imageN2S2F2R1_ChildResize,0.5835);
        
        %Adjust amplitudes so histogram of degraded iamge matches natural
        sX=imageN2S2F2R1_ChildResize(:);       %wavelet shuffled image
        M(:,1)=sX; M(:,2)=1:N^2;
        M=sortrows(M,1);
        M(:,1)=sortrows(X);
        M=sortrows(M,2);
        Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one
                
        if k == 1 || k == 2
            imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B9/N2S2F1R1_',num2str(j),'_',num2str(k),'.tiff'))
            imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B10/N2S2F2R1_',num2str(j),'_',num2str(k),'.tiff'))
        else
            imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B10/N2S2F2R1_',num2str(j),'_',num2str(k),'.tiff'))
        end
        clear sX M Y
    end

    % B11 
    imageN3S2F1R1_Father = rectsurr2(imageNoiseAllButS12, nS1, wv, cz, 19/20);
    %Adjust amplitude so histogram of degraded image matches natural
    sX=imageN3S2F1R1_Father(:);       %wavelet shuffled image
    M(:,1)=sX; M(:,2)=1:origImageDim(1)*origImageDim(2);
    M=sortrows(M,1);
    M(:,1)=sortrows(X_notResized);
    M=sortrows(M,2);
    Y=reshape(M(:,1),origImageDim(1),origImageDim(2));   %surrogate image with amplitude spectra of natural one
    imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B11/N3S2F1R1_',num2str(j),'_Father.tiff'))
    clear sX M Y
    
    imageN3S2F1R1_FatherResize = imageN3S2F1R1_Father(111:1426,111:1426); %This will be region to crop to...
    imageN3S2F1R1_FatherResize = imresize(imageN3S2F1R1_FatherResize,0.5835);
    %Adjust amplitudes so histogram of degraded iamge matches natural
    sX=imageN3S2F1R1_FatherResize(:);       %wavelet shuffled image
    M(:,1)=sX; M(:,2)=1:N^2;
    M=sortrows(M,1);
    M(:,1)=sortrows(X);
    M=sortrows(M,2);
    Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one
    imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B11/N3S2F1R1_',num2str(j),'_1.tiff'))
    clear sX M Y
    
    imageN3S2F1R1_Child = rectsurr2(imageN3S2F1R1_Father, nS2, wv, cz, 19/20);
    imageN3S2F1R1_ChildResize = imageN3S2F1R1_Child(111:1426,111:1426); %This will be region to crop to...
    imageN3S2F1R1_ChildResize = imresize(imageN3S2F1R1_ChildResize,0.5835);
    
    %Adjust amplitudes so histogram of degraded iamge matches natural
    sX=imageN3S2F1R1_ChildResize(:);       %wavelet shuffled image
    M(:,1)=sX; M(:,2)=1:N^2;
    M=sortrows(M,1);
    M(:,1)=sortrows(X);
    M=sortrows(M,2);
    Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one
    imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B11/N3S2F1R1_',num2str(j),'_2.tiff'))
    clear sX M Y
    
    % B12
    imageNoiseResize = imageNoise(111:1426,111:1426); %This will be region to crop to...
    imageNoiseResize = imresize(imageNoiseResize,0.5835);
    
    %Adjust amplitudes so histogram of degraded iamge matches natural
    sX=imageNoiseResize(:);       %wavelet shuffled image
    M(:,1)=sX; M(:,2)=1:N^2;
    M=sortrows(M,1);
    M(:,1)=sortrows(X);
    M=sortrows(M,2);
    Y=reshape(M(:,1),N,N);   %surrogate image with amplitude spectra of natural one
    
    imwrite(im2uint8(Y),strcat('/data/projects/ImNatural/ImDegrade/B12/N2S0F0R0_',num2str(j),'_1.tiff'))

    clear X sX M Y X_notResized
end

