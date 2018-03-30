function [theta, X] = NoiseThenDetrend(data, noisefn)

theta = noisefn(data);
X = mydetrend(theta);

end

