%% Calculates the mean luminance of a series of natural images

%%
imName = {'DSCN1572'; 'DSCN2190';'DSCN2173';'DSCN2192';'DSCN1577';'DSCN2124';...
    'DSCN2123'; 'DSCN2172';'DSCN2184';'DSCN2156';'DSCN2078';'DSCN2099';...
    'DSCN2138';'DSCN2152';'DSCN2176';'DSCN2169'; 'DSCN1573'; 'DSCN1578';...
    'DSCN1579'; 'DSCN2087';'DSCN2101';'DSCN2141';'DSCN2072';'DSCN2079'; ...
    'DSCN1575';'DSCN1574';'DSCN1576';'DSCN2092'; 'DSCN2093'; 'DSCN2100';...
    'DSCN2106'; 'DSCN2100';'DSCN2122';'DSCN2126';'DSCN2135';'DSCN2137';...
    'DSCN2139';'DSCN2142';'DSCN2149';'DSCN2153'; 'DSCN2155'; 'DSCN2167'; ...
    'DSCN2170';'DSCN2175';'DSCN2181';'DSCN2183';'DSCN2185';'DSCN2187';...
    'DSCN2188';'DSCN2191'};

for j = 1:size(imName,1)
    

X = imread(strcat('/data/projects/ImNatural/Zurich/',imName{j},'.JPG'));
X = rgb2gray(X);

imageOrig = X;
imageOrig = imageOrig(:,round((size(imageOrig,2)-1536)/2):size(imageOrig,2)-round((size(imageOrig,2)-1536)/2)-1);


% B1, B2_1, B7_1
imageOrigResize = imageOrig(111:1426,111:1426);
imageOrigResize = imresize(imageOrigResize,0.5835);

meanLumAll(j) = mean(imageOrigResize(:));

end

hist(meanLumAll(1,:))