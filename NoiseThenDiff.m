function [theta, X] = NoiseThenDiff(data, noisefn)

theta = noisefn(data);
X = diff(theta,1,2);

end

