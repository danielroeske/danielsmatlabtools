function f=pieceWiseFunction(varargin)
%findInSorted implements pice wise defined functions and supports
%vectorized evaluation.
%
% f = pieceWiseFunction(r1,f1,r2,f2,...rn,fn)
%
% ri - range. Function handle which returns true for the interval in which
%      fi has to be evaluated.
%      Last interval might be "true" to cover all remaining intervals.
% fi - function handle or constant double
%
% Example which redefines abs
% abs2=pieceWiseFunction(@(x)(x<0),@(x)(-x),true,@(x)(x))
% Author Daniel Roeske <danielroeske.de>
if nargin==0
    disp('Received no input arguments, doing a short demonstration')
    fprintf('x < -5, y = 2\n-5 <= x < 0, y = sin(x)\n0 <= x < 2, y = x.^2\n2 <= x < 3, y = 6\n3 <= x, y = inf\n')
    C={ @(x)(x<-5)     ,2,...
        @(x)(-5<=x&x<0),@sin,...
        @(x)(0<=x&x<2) ,@(y)(y.^2),...
        @(x)(2<=x&x<3) ,6,...
        @(x)(3<=x)     ,inf};
    f=pieceWiseFunction(C{:});
    ezplot(f);
else
    
    for ip=1:numel(varargin)
        switch class(varargin{ip})
            case {'double','logical'}
                varargin{ip}=@(x)(repmat(varargin{ip},size(x)));
            case 'function_handle'
                %do nothing
            otherwise
                error('wrong input class')
        end
    end
    c=struct('cnd',varargin(1:2:end),'fcn',varargin(2:2:end));
    f=@(x)pweval(x,c);
end
end

function y=pweval(x,c)
todo=true(size(x));
y=x.*0;
for segment=1:numel(c)
    mask=todo;
    mask(mask)=logical(c(segment).cnd(x(mask)));
    y(mask)=c(segment).fcn(x(mask));
    todo(mask)=false;
end
assert(~any(todo));
end