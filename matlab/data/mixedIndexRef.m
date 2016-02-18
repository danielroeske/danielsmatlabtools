function matrix=mixedIndexRef(matrix,varargin)

% Author Daniel Roeske <danielroeske.de>
dims=ones(1,numel(varargin));
index=cell(1,numel(varargin));
for ix=1:numel(varargin)
    e=varargin{ix};
    if iscell(e)
        dims(ix)=e{2};
        index{ix}=e{1};
    elseif islogical(e)
        dims(ix)=ndims(e);
        index{ix}=e;
    else
        dims(ix)=1;
        index{ix}=e;
    end
end
assert(sum(dims)==ndims(matrix))
osize=size(matrix);
pmap=nan(1,sum(dims));
b=cumsum(dims);
a=[1,b(1:end-1)+1];
for ix=1:numel(dims)
    pmap(a(ix):b(ix))=ix;
end
psize=accumarray(pmap.',osize.',[],@prod);
index=cellfun(@(x)(x(:)),index,'uni',false);
matrix=reshape(matrix,psize.');
matrix=matrix(index{:});
end