function t = tic_toc_overhead()
tic;x=toc;x=tic;x=toc;tic;x=toc;
x=zeros(100,1);
for i=1:numel(x)
    tic;
    h=toc;
    x(i)=h;
end
t=median(x);
t=tic();
end
