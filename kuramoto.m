function Y = kuramoto(ic,adj,w,tSpan,K)
% calls ode45 to solve kuramoto model
% 
% INPUTS:
%
% ic
%       an [n x 1] vector of initial conditions for the ODE
%
% adj
%       an [n x n] adjacency matrix for the network
% 
% w 
%       an [n x 1] vector of natural frequencies, one for each node
%       in the network
%
% tSpan
%       a [1 x m] vector of times for which you want the solution of the
%       ODE returned
%
% K
%       a scalar value for connection strength of the network 
%
% OUTPUTS:
%
% Y
%       an [n x m] matrix of the solution of the ODE for all n 
%       nodes and m time points

    param{1} = size(ic,1); % number of nodes
    param{2} = adj; % adjacency matrix
    param{3} = w; % natural frequencies
    param{4} = K; % connection strength
    
    SOL = ode45(@(t,y) odeKur(t,y,param),tSpan,ic);
    Y = deval(SOL, tSpan); 
end 
