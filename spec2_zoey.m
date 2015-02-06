%Spectrum of 2-D data
function [Fx,Fy]=spec2(X,col,h,l);
if nargin<2, col='k'; end
if nargin<3, h=0; end
if nargin<4, l=1; end
[wX,wY]=size(X);
Y=fft2(X);
Y=Y(1:round(wX/2),1:round(wY/2));
Fx=trapz(abs(Y));
Fy=trapz(abs(Y'));
if nargin>1,
x = 1:length(Fx);
figure, if h==1, hold on, else hold off, end
figure; loglog(x,Fx)
%xlim([1 length(Fx)])
%ylim([min(Fx)/1.25 1.25*max(Fx)])
figure, if h==1, hold on, else hold off, end
figure; loglog(x,Fy)
%xlim([1 length(Fy)])
%ylim([min(Fy)/1.25 1.25*max(Fy)])
end