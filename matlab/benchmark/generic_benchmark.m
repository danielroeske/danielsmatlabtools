function [ T_mean ] = generic_benchmark( N,inputGenerator,functions)
%GENERIC_BENCHMARK Summary of this function goes here
%   Detailed explanation goes here
string_params=gencode({N,inputGenerator,functions},'P');
fprintf('The benchmark was created using\n\n')

fprintf('\t%s\n',string_params{:});
fprintf('\t%s\n\n','generic_benchmark(P);');

function_names=cellfun(@func2str,functions,'UniformOutput',0);
T2=cell(numel(N),numel(functions));
wb=waitbar(0);
for n=1:numel(N)
    waitbar(n/numel(N));
    input = cell(size(inputGenerator));
    for ix=1:numel(input)
        input{ix}=inputGenerator{ix}(N(n));
    end
    for fix=1:numel(functions)
        thisInput=input;
        f=@()functions{fix}(thisInput{:});
        [~,X]=timeit2(f);
        [T2{n,fix}]=[T2{n,fix},X];
        
    end
end
delete(wb)
T_mean=cellfun(@mean,T2);
T_low=cellfun(@(X)quantile(X,[0.1]),T2);
T_high=cellfun(@(X)quantile(X,[0.9]),T2);
fprintf(['\n\t',repmat('%12s\t',1,numel(function_names)),'%12s\n'],'',function_names{:});
h=num2cell([N(:),T_mean]).';
fprintf(['\t%12d\t',repmat('%12.6f\t',1,numel(function_names)-1),'%12.6f\n'],h{:});
if sum(((max(N)/2)<N))/numel(N)<1/4
    %don't use linear axis
    linear=0;
else
    linear=1;
end
figure()
subplot(2,2,1);
if linear
    plot(N,T_mean,'x-');
    
    hold on
    plot(N,T_low,':');
    plot(N,T_high,':');
else
    plot(T_mean,'x-');
    hold on
    plot(T_low,':');
    plot(T_high,':');
    X=get(gca,'Xtick');
    X(X>0)=N(X(X>0));
    set(gca,'Xticklabel',X);
end
title('runtime in seconds');
ylabel('time [s]')
xlabel('N')
legend([function_names,'10%/90% Percentiles']);
subplot(2,2,2);
loglog(N,T_mean,'x-');
hold on
loglog(N,T_low,':');
loglog(N,T_high,':');
title('runtime in seconds (loglog)');
ylabel('time [s]')
xlabel('N')
subplot(2,2,3);
rp=bsxfun(@rdivide,min(T_mean,[],2),T_mean);
if linear
    plot(N,rp,'x-');
else
    plot(rp,'x-');
    X=get(gca,'Xtick');
    X(X>0)=N(X(X>0));
    set(gca,'Xticklabel',X);
end
title('relative performance (higher = better)');
xlabel('N');
ylim([0,1.1])
end

