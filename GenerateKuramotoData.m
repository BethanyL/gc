function Y = GenerateKuramotoData(A, tSpan, N, K, randicfn, randwfn)
%
% calls kuramoto.m to return solution of Kuramoto model
%
% INPUTS:
%
% A
%       an [n x n] adjacency matrix for the network
%
% tSpan
%       a [1 x m] vector of times for which you want the solution of the
%       ODE returned
%
% N
%       a scalar value for the number of random trials requested 
%
% K
%       a scalar value for connection strength of the network 
%
% randicfn 
%       a function that takes a scalar n and returns an [n x 1] vector 
%       of (possibly random) initial conditions, one for each node in the 
%       network 
%
% randwfn 
%       a function that takes a scalar n and retuns an [n x 1] vector 
%       of (possibly random) natural frequencies w, one for each node
%       in the network
%
% OUTPUTS:
%
% Y
%       an [n x m x N] matrix of the solution of the ODE for n nodes,
%       m time points, and N random trials
    
    n = size(A,1);
    m = length(tSpan);
    Y = zeros(n,m,N);
    
    for j = 1:N
        start = randicfn(n);
        freq = randwfn(n);

        Y(:,:,j) = kuramoto(start,A,freq,tSpan,K);
    end
    
    % if N == 1, want 2D Y
    Y = squeeze(Y);
end

