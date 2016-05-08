function [theta, X] = CosineThenNoise(data, noisefn)

theta = data;
X = cos(theta);
X = noisefn(X);

end

