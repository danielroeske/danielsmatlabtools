function matrix=mixedIndexAssign(matrix,value,varargin)

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
osizev=size(value);
osizev(end+1:ndims(matrix))=1;
pmap=nan(1,sum(dims));
b=cumsum(dims);
a=[1,b(1:end-1)+1];
for ix=1:numel(dims)
    pmap(a(ix):b(ix))=ix;
end
psize=accumarray(pmap.',osize.',[],@prod);
psizev=accumarray(pmap.',osizev.',[],@prod);
index=cellfun(@(x)(x(:)),index,'uni',false);
matrix=reshape(matrix,psize.');
value=reshape(value,psizev.');
area=size(matrix(index{:}));
expand=area./psizev.';
if all(mod(expand,1)==0)&&all(expand>0);
    value=repmat(value,expand);
elseif prod(area)==prod(psizev)
    warning('Value has wrong size but numel is correct, reshaping.');
    value=reshape(value,area);
else
    s=sprintf('Value has wrong size. Expecting matrix of size [%s] where:\n',sprintf('s%d ',1:max(pmap)));
    for ix=1:max(pmap)
        if numel(find(pmap==ix))==1
           s=[s,sprintf('%s==%d\n',sprintf('s%d ',find(pmap==ix)),area(ix))];
        else
           s=[s,sprintf('sum([%s])==%d\n',sprintf('s%d ',find(pmap==ix)),area(ix))];
        end
        
    end
    error(s);
end
matrix(index{:})=value;
matrix=reshape(matrix,osize);
end