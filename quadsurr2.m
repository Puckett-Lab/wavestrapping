%Creates surrogate data by permuting wavelet coefficents for 2-D data
% *Note: currently only set up for permtx (cz=1). 
% ***Not sure method is appropriate. It seems to me that it would be
% permuting the coef row by row rather than all at once, reducing the
% amt of randomization...This was modeled after MB's ellipsurr2.m. Perhaps
% take out for ii loops and define regions to be permuted like
% ch(1:m1,m2:n12)!

function f=quadsurr2(s,n,wv,cz,quad); 
if nargin<3, wv='db2'; end, 
if nargin<2 n=8; end
if nargin<4, cz=1; end    %choice of resampling scheme
if nargin<5, quad=[0 0 0 0]; end		%size of resampling window

[rr,col] = size(s); dim=1; N=max(n);
if ndims(s)>2, [rr,col,dim]=size(s); end
for j=1:dim;
   [c(j,:),l]=wavedec2(s(:,:,j),N,wv);
end
cc=c;

for i=n, ch=[]; cv=[]; cd=[]; i;
   st=sum(100*clock);
   nl1=l(N+2-i,1); nl2=l(N+2-i,2); m1=ceil(nl1/2); m2=ceil(nl2/2);

 
   for j=1:dim;
      ch=detcoef2('h',c(j,:),l,i);
      cv=detcoef2('v',c(j,:),l,i);
      cd=detcoef2('d',c(j,:),l,i);
      rand('state',st); 
      if cz==1,
         if quad(1) == 1
          for ii=1:m1, ch(ii,m2:nl2)=permtx(ch(ii,m2:nl2)); end
         end
         if quad(2) == 1
          for ii=1:m1, ch(ii,1:m2)=permtx(ch(ii,1:m2)); end
         end
         if quad(3) == 1
          for ii=m1:nl1, ch(ii,1:m2)=permtx(ch(ii,1:m2)); end
         end
         if quad(4) == 1
          for ii=m1:nl1, ch(ii,m2:nl2)=permtx(ch(ii,m2:nl2)); end
         end         
      elseif cz==2, 
         for ii=1:nl1, ch(ii,m1-r(i,ii):m1+r(i,ii))=rotmtx(ch(ii,m1-r(i,ii):m1+r(i,ii))); end
      else
         for ii=1:nl1, ch(ii,m1-r(i,ii):m1+r(i,ii))=blkmtx(ch(ii,m1-r(i,ii):m1+r(i,ii))); end
      end 
      %rand('state',st); 
      if cz==1,     
         if quad(1) == 1
          for ii=1:m1, cv(ii,m2:nl2)=permtx(cv(ii,m2:nl2)); end
         end
         if quad(2) == 1
          for ii=1:m1, cv(ii,1:m2)=permtx(cv(ii,1:m2)); end
         end
         if quad(3) == 1
          for ii=m1:nl1, cv(ii,1:m2)=permtx(cv(ii,1:m2)); end
         end
         if quad(4) == 1
          for ii=m1:nl1, cv(ii,m2:nl2)=permtx(cv(ii,m2:nl2)); end
         end
      elseif cz==2, 
         for ii=1:nl1, cv(ii,m1-r(i,ii):m1+r(i,ii))=rotmtx(cv(ii,m1-r(i,ii):m1+r(i,ii))); end
      else
         for ii=1:nl1, cv(ii,m1-r(i,ii):m1+r(i,ii))=blkmtx(cv(ii,m1-r(i,ii):m1+r(i,ii))); end
      end 
      %rand('state',st); 
      if cz==1,     
         if quad(1) == 1
          for ii=1:m1, cd(ii,m2:nl2)=permtx(cd(ii,m2:nl2)); end
         end
         if quad(2) == 1
          for ii=1:m1, cd(ii,1:m2)=permtx(cd(ii,1:m2)); end
         end
         if quad(3) == 1
          for ii=m1:nl1, cd(ii,1:m2)=permtx(cd(ii,1:m2)); end
         end
         if quad(4) == 1
          for ii=m1:nl1, cd(ii,m2:nl2)=permtx(cd(ii,m2:nl2)); end
         end
      elseif cz==2, 
         for ii=1:nl1, cd(ii,m1-r(i,ii):m1+r(i,ii))=rotmtx(cd(ii,m1-r(i,ii):m1+r(i,ii))); end
      else
         for ii=1:nl1, cd(ii,m1-r(i,ii):m1+r(i,ii))=blkmtx(cd(ii,m1-r(i,ii):m1+r(i,ii))); end
      end 
      ch=reshape(ch,1,nl1*nl2);
		cv=reshape(cv,1,nl1*nl2);
      cd=reshape(cd,1,nl1*nl2);
      cc(j,l(1,1)*l(1,2)+3*sum(l(2:N+1-i,1).*l(2:N+1-i,2))+1: ...
         l(1,1)*l(1,2)+3*sum(l(2:N+1-i,1).*l(2:N+1-i,2))+nl1*nl2)=ch;
      cc(j,l(1,1)*l(1,2)+3*sum(l(2:N+1-i,1).*l(2:N+1-i,2))+l(N+2-i,1)*l(N+2-i,2)+1:...
         l(1,1)*l(1,2)+3*sum(l(2:N+1-i,1).*l(2:N+1-i,2))+2*nl1*nl2)=cv;
      cc(j,l(1,1)*l(1,2)+3*sum(l(2:N+1-i,1).*l(2:N+1-i,2))+2*l(N+2-i,1)*l(N+2-i,2)+1:...
         l(1,1)*l(1,2)+3*sum(l(2:N+1-i,1).*l(2:N+1-i,2))+3*nl1*nl2)=cd;
   end
end
for j=1:dim
   f(:,:,j)=waverec2(cc(j,:),l,wv);
end
