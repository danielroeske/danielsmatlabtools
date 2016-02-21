function M=sumnd(M,dim)
s=size(M);
M=permute(M,[setdiff(1:ndims(M),dim),dim]);
M=reshape(M,[],s(dim));
M=sum(M,2);
s(dim)=1;
M=reshape(M,s);
end
