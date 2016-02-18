classdef brdouble < double
    %BDOUBLE double with automatic broadcasting enabled

    methods
        function obj=brdouble(data)
            obj = obj@double(data);
        end
        function r=plus(x,y)
            r=bsxfun(@plus,x,y);
        end
        function r=minus(x,y)
            r=bsxfun(@minus,x,y);
        end
        function r=power(x,y)
            r=bsxfun(@power,x,y);
        end
        function r=times(x,y)
            r=bsxfun(@times,x,y);
        end
        function r=rdivide(x,y)
            r=rdivide(@times,x,y);
        end
        function r=ldivide(x,y)
            r=ldivide(@times,x,y);
        end 
    end
end
