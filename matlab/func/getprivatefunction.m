function handle=getPrivateFunction(varargin)
%GETPRIVATEFUNCTION returns a function handle to a (private) function. It
%was implemented to allow uint tests for private functions. 
%
% [HANDLE] = getPrivateFunction(FILENAME)
% 
% Example usage
%
% get handle for E:\WORKSPACE\MATLAB\private\object_of_test.m
% testfun=getPrivateFunction('E:\WORKSPACE','MATLAB','private','object_of_test.m')
% call function
% testfun(pi)
%
% Author Daniel Roeske <danielroeske.de>

p=fullfile(varargin{:});
[d,f,~]=fileparts(p);
olddir=pwd;
cd(d);
handle=str2func(f);
cd(olddir);
end

