function A = MakeNetworkER(nvars, p)

% Make a random Erdos-Renyi network: for each pair of nodes,
% add a connection with probability p 
% (uniform distribution)
%
% INPUTS:
%
% nvars
%       scalar for number of nodes in network
%
% p
%       probability than an edge is included in the network
%
% OUTPUTS:
%
% A
%       adjacency matrix for the network created
%



A = zeros(nvars,nvars);
dice = rand(nvars);

% if >= 1-p, add connection
A(dice >= 1-p) = 1; 