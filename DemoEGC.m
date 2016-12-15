%% test of GC and eGC analysis on simulated data
% this is a variation of code provided with 
% Schiatti L, Nollo G, Rossato G, and Faes L 2015 Extended Granger causality: a new tool to identify the structure of physiological networks. Physiological Measurement
% that interfaces with the rest of their code. See ExperimentD2_EGCandGC.m for an example of its use.  
%
% INPUTS:
%
% X 
%       [n x m x N] matrix of time series data (n nodes, m time points, N time series)
%
% p
%       scalar: model order
%
% eFlag
%       1 for extended GC, 0 for non-extended     
%
% OUTPUTS:
%
% votingmat
%       [n x n] inferred adjacency matrix
%
% dummy
%       BaseExperiment.m expects networkInferencefn to return diagnostics. We don't have 
%       any here, so we return a dummy variable
%

function [votingmat, dummy] = DemoEGC(X, p, eFlag)

dummy = []; % don't have any diagnostics, but caller code expects return

M=size(X,1); %number of simulated time series
%N=size(X,2); %length of simulated time series
%pmax % maximum lag in the simulation
%insteff='y'; % 'n' for strictly causal, 'y' for extended with instantaneous effects
numsimu=size(X,3); %number of simulations

alpha=0.01; % statistical significance for F-test on GC and eGC

% Parameters of eGC analysis
numboot=1000;   % number of bootstrap samples
LRmethod=1; % which pairwise measure to be chosen [see Hyvarinen and Smith 2013]


%% estimation from several realizations
pvals = zeros(M, M, numsimu);

for i=1:numsimu
    disp(['Simulation ' int2str(i) ' of ' int2str(numsimu)]);

    Y = X(:,:,i);

    
    %estimation of GC
    [~,p_val1,~,~,~,Res]=egc_gcMVAR(Y,p);

    if eFlag
        % estimation of extended GC
        % uses Res from above
        [~,pval_e1]=egc_gceMVAR(Y,p,Res,LRmethod,numboot);
        pvals(:,:,i)=pval_e1;
    else
        pvals(:,:,i)=p_val1;
    end
         
end

%% counts nonzero causality values and tests differences btw GC and eGC
pvals_sum = zeros(M, M);
ind=0;
for i=1:M
    for j=1:M
        ind=ind+1;
        pvals_sum(i,j)=sum(pvals(i,j,:)<alpha);
    end
end


votingmat = round(pvals_sum/numsimu);
% to be fair for our data comparison
votingmat(1:(M+1):end) = 0;
    


