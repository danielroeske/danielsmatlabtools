function [t,raw] = timeit2( f,n )
%TIMEIT2 Summary of this function goes here
%   Detailed explanation goes here
if ~exist('n','var')
    n=abs(nargout(f));
    if n==0
        n=1;
    end
end
max_iterations=1000;
min_iterations=3;
max_time=10;
overhead=tictocoverhead();
raw=nan(1,max_iterations);
for repeat=1:max_iterations
    varargout = cell(1:n);
    switch n
        case 0
            tic;
            f();
            raw(repeat)=toc;
        case 1
            tic;
            x1=f();
            raw(repeat)=toc;
        case 2
            tic;
            [x1,x2]=f();
            raw(repeat)=toc;
        case 3
            tic;
            [x1,x2,x3]=f();
            raw(repeat)=toc;
        otherwise
            tic;
            [varargout{1:n}]=f();
            raw(repeat)=toc;
    end
    if repeat>min_iterations&&sum(raw(1:repeat))>max_time
        warning('timeit canceled because computation time exceeded')
        break;
    end
end
raw=raw(1:repeat);
t=mean(raw);
end


