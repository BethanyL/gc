function A = MakeNetworkER(nvars, p)

% uniformly distributed 0 -> 1, if >= 1-p, add connection
% connection there with probability p

A = zeros(nvars,nvars);
dice = rand(nvars);
A(dice >= 1-p) = 1; 