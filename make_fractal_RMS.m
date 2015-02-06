function f = make_fractal_RMS(expo,imsize,contrast);

for i = 1:16

% Generates fractal textures with a given exponent of the amplitude spectrum & RMS contrast
%
% CC - 9.2.02
%
% CC - 15.4.02 commented 04.06.07
%
% CC - modified from make_fractal 14.03.13 to give arbitrary RMS contrast

xsize = imsize;
ysize = imsize;

a = zeros(xsize,ysize);
b = zeros(xsize,ysize);
c = zeros(xsize,ysize);
e = zeros(xsize,ysize);

a = random('Normal',0,1,xsize,xsize); % generate image of Gaussian white noise
dc = mean(mean(a)); % set the mean level to zero ...
b = fft2(a-dc);     % ... and Fourier transform to get the frequency spectrum

b = fftshift(b);    % rearrange the frequency spectrum so that zero is at the centre

x0 = (xsize+1)/2;
y0 = (ysize+1)/2;

for x = 1:xsize     % create an amplitude spectrum with the desired "fractal" drop-off with frequency
    for y = 1:ysize
        d = sqrt((x-x0)^2+(y-y0)^2);
        c(x,y) = d.^(-expo);
    end
end

b = b.*c;   % multiply the frequency spectrum of your noise by the fractal amplitude spectrum to get fractal noise

b = ifftshift(b); % rearrange the frequency spectrum so that zero is in the corner

e = ifft2(b); % inverse Fourier transform your spectrum to get a fractal noise image

% normalize image ...
f = real(e);
maxf = max(max(f));
minf = min(min(f));
ampf = max(maxf,-minf);
f = f./ampf;
ff = reshape(f,1,imsize*imsize);
f = f./std(ff); % mean is 0, std is 1
f = min(255,max(127.5.*(1 + f.*contrast),0)); % clip to 0-255 with chosen contrast

g = uint8(f); % convert to unsigned 8-bit integer and write as bitmap ...
%imwrite(g, 'new_test_fractal.bmp', 'bmp');
name = strcat(num2str(i),'_noise.tiff')
imwrite(g, name, 'tiff');

% check the actual rms contrast of the 8-bit image ...
ff = reshape(double(g),1,imsize*imsize);
delivered_contrast = std(ff)/mean(ff);

pcolor(f);
shading flat;
colormap gray;
axis equal;
caxis([0 255])
axis off;

end

