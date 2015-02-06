%Function to randomly permute a matrix in each of its dimensions
function f=permtx(mtx);
sz=size(mtx); s1=sz(1); s2=sz(2);
mtx(1:s1,:,:)=mtx(randperm(s1),:,:);
mtx(:,1:s2,:)=mtx(:,randperm(s2),:);
if ndims(mtx)>2,  s3=sz(3);
   mtx(:,:,1:s3)=mtx(:,:,randperm(s3));
end
f=mtx;





%cp(:,j+1)=randperm(l(n+2-i))'; 											%Random permutation
