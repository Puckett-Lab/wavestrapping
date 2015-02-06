
%image=imread('/data/projects/ImNatural/ImDegrade/natural/16_DSCN2169_gray.tiff'); 
image=imread('/data/projects/ImNatural/ImDegrade/junk.tiff'); 

image=double(image);

imageNorm=image/255; 

cMean = mean(imageNorm(:));

 
a = (1/((numel(imageNorm))-1));
b = sum((imageNorm(:)-cMean).^2);
c = sqrt(a*b);

rms_cont = sqrt((1/(numel(imageNorm)-1))*sum((imageNorm(:) - cMean).^2))

ff = reshape(imageNorm,1,512*512);
delivered_contrast = std(ff)/mean(ff)

std(ff)

mean(ff)

% RMS defined as stdev of pixel intensities from 1990 paper
% make_fractal_RMS defines as std/mean
%
%
