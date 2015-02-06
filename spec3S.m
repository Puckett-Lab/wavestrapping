%Spectrum of 3-D data - only calculates 'spatial' (1st) dimension
function [Fx,Fy]=spec3S(X,col,h,l);
if nargin<2, col='k'; end
if nargin<3, h=0; end
if nargin<4, l=1; end
[wX,wY,wZ]=size(X);
Y=fftn(X);
Y=Y(1:round(wX/2),1:round(wY/2),4:round(wZ/2));
sY=size(Y);
Z=zeros(sY(2),sY(1),sY(3));
Fy=trapz(squeeze(trapz(abs(Y)))')/(sY(3)*sY(1));
for i=1:sY(3)
    Z(:,:,i)=shiftdim(Y(:,:,i),1);
end
Fx=trapz(squeeze(trapz(abs(Z)))')/(sY(3)*sY(2));
if nargin>1,
figure(3), if h==1, hold on, else hold off, end
semilogy(Fx,col,'linewidth',l);
xlim([1 length(Fx)])
ylim([min(Fx)/1.25 1.25*max(Fx)])
figure(4), if h==1, hold on, else hold off, end
semilogy(Fy,col,'linewidth',l);
xlim([1 length(Fy)])
ylim([min(Fy)/1.25 1.25*max(Fy)])
end