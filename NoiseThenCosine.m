function [theta, X] = NoiseThenCosine(data, noisefn)

theta = noisefn(data);
X = cos(theta);

end

