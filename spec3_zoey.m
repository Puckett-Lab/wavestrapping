%Spectrum of 3-D data - only calculates 'temporal' (3rd) dimension
function P=spec3(X,col,h,l);
if nargin<2, col='k'; end
if nargin<3, h=1; end
if nargin<4, l=1; end
[wX,wY,wZ]=size(X);
Y=fftn(X);
Y=Y(1:round(wX/2),1:round(wY/2),3:round(wZ/2));
P=trapz(trapz(abs(Y)));
if nargin>1,
x = 1:length(P);
figure, if h==1, hold on, else hold off, end
loglog(x,(squeeze(P)),col,'linewidth',l);
xlim([1 log(length(P))])
%ylim([min(P)/1.25 1.25*max(P)])
end