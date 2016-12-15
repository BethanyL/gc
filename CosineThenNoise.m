function [theta, X] = CosineThenNoise(data, noisefn)
%
% applies cosine to the data, then adds noise
% See SetUsualParams.m for an example of how to use it for preprocfn
% (there NoiseThenCosine is the default)
%
% INPUTS:
%
% data
%       matrix of data from solving Kuramoto model
%
% noisefn
%       function that takes data as input and returns 
%       the data with noise added
%
%
% OUTPUTS: 
% 
% theta 
%       a version of the data that makes sense for 
%       calculating r, the synchrony measure
%
% X
%       the version of the data that we want to apply
%       the network inference function to
%

theta = data;
X = cos(theta);
X = noisefn(X);

end

