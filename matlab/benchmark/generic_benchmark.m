function [ T_mean ] = generic_benchmark( N,inputGenerator,functions)
%GENERIC_BENCHMARK Summary of this function goes here
%   Detailed explanation goes here
string_params=gencode({N,inputGenerator,functions},'P');
fprintf('The benchmark was created using\n\n')

fprintf('\t%s\n',string_params{:});
fprintf('\t%s\n\n','generic_benchmark(P); %GITHUB: https://goo.gl/0tzvbz');

function_names=cellfun(@func2str,functions,'UniformOutput',0);
function_failed=false(size(function_names));
T2=cell(numel(N),numel(functions));
wb=waitbar(0);
for n=1:numel(N)
    waitbar(n/numel(N));
    input = cell(size(inputGenerator));
    for ix=1:numel(input)
        input{ix}=inputGenerator{ix}(N(n));
    end
    for fix=1:numel(functions)
        if not(function_failed(fix))
            thisInput=input;
            f=@()functions{fix}(thisInput{:});
            try
                [~,X]=timeit2(f);
                [T2{n,fix}]=[T2{n,fix},X];
            catch ME
                fprintf(2,'error while calling %s\n',function_names{fix});
                fprintf(2,'%s\n',getReport(ME));
                fprintf(2,'skip futher executions of that function\n');
                function_failed(fix)=true;
            end
            
        end
    end
end
delete(wb)
T_mean=cellfun(@mean,T2);
T_low=cellfun(@(X)quantile(X,[0.1]),T2);
T_high=cellfun(@(X)quantile(X,[0.9]),T2);
T_iterations=cellfun(@numel,T2);
fprintf('\nExection Times (mean)\n\n');
fprintf(['\t',repmat('%12s\t',1,numel(function_names)),'%12s\n'],'',function_names{:});
h=num2cell([N(:),T_mean]).';
fprintf(['\t%12d\t',repmat('%12.6f\t',1,numel(function_names)-1),'%12.6f\n'],h{:});

if min(T_iterations(:))~=max(T_iterations(:))
    fprintf('\nIterations\n\n');
    fprintf(['\t',repmat('%12s\t',1,numel(function_names)),'%12s\n'],'',function_names{:});
    h=num2cell([N(:),T_iterations]).';
    fprintf(['\t%12d\t',repmat('%12d\t',1,numel(function_names)-1),'%12d\n'],h{:});
else
    fprintf('Every function was called %d times\n',max(T_iterations(:)));
end
if sum(((max(N)/2)<N))/numel(N)<1/4
    %don't use linear axis
    linear=0;
else
    linear=1;
end
figure()
subplot(3,1,1);
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
subplot(3,1,2);
loglog(N,T_mean,'x-');
hold on
loglog(N,T_low,':');
loglog(N,T_high,':');
title('runtime in seconds (loglog)');
ylabel('time [s]')
xlabel('N')
subplot(3,1,3);
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

