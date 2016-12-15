function BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, ...
    preprocfn, deltat, endtime, ntrials, reps, tsplits, freq, ...
    networkInferenceFn, numDiagnostics)

%
% Core function of this codebase: runs a basic experiment. There are
% many inputs so that everything can be varied. Default parameters are
% saved in UsualParams.mat. See ExperimentA1.m for an example of calling
% this function.
%
% INPUTS:
%
% expnum
%       a string giving the experiment "number," such as "A1" - this 
%       determines the subdirectory where the results are saved
%
% mats
%       an [n x n x numMats] sequence of true network structures 
%       (binary adjacency matrices) to try. The outer loop in 
%       this function loops over each network to generate data
%       on that network 
%
% Kvals
%       a vector of scalar values for connection strength K of the network. 
%       Inside the loop over networks is a loop over these options for K
%
% randwfn 
%       a function that takes a scalar n and retuns an [n x 1] vector 
%       of (possibly random) natural frequencies w, one for each node
%       in the network
%
% randicfn 
%       a function that takes a scalar n and returns an [n x 1] vector 
%       of (possibly random) initial conditions, one for each node in the 
%       network 
%
% preprocfn
%       a function that takes the [n x m x N] matrix of the solution Y of 
%       the ODE for n nodes, m time points, and N random trials, preprocesses
%       it, and returns theta (the version of Y used to calculate r)
%       and X, the version of Y used as the input to the network inference
%       function. Default is that theta is the noisy version of Y and X is
%       cos(theta).
%
% deltat
%       scalar for size of time step we want in the data we generate
%
% endtime
%       scalar for the last time point to solve the system at. (solve the 
%       system of ODEs for t = [0, endtime])
%
% ntrials
%       a scalar value for the number of random trials requested 
%
% reps
%       a scalar value for the number of times to generate data and
%       apply the network inference method for a single network + K pair. 
%       We can optionally generate the data repeatedly and infer the 
%       network on each instantiation. Then the final inferred network
%       is a "vote" over these repetitions for whether or not each 
%       edge is included. Default is 1: no repetitions.
%
% tsplits
%       a vector of time indices. We can optionally split the data into
%       smaller time intervals. We infer the network on each time interval,
%       then "vote" over the results for whether or not each edge is included.
%       This vector should contain the endpoints of each interval. Default is 
%       no splitting: tpslits = nobs (number of observations / time points in
%       data).
%
% freq
%       integer for how often to save the current workspace. Default is 10: 
%       after every 10 runs of the network inference method, save the 
%       current workspace so we can check preliminary results while the
%       code continues to run. Saving the workspace also makes it easier
%       to restart the experiment close to where we left off if something
%       goes wrong with the computer.
%
% networkInferenceFn
%       function that accepts the time series data as input and outputs an 
%       adjacency matrix and any number of diagnostics. 
% 
% numDiagnostics 
%       scalar that states how many diagnostics you expect networkInferenceFn 
%       to output.
%

    
    
    

if nargin <= 12
    networkInferenceFn = @(data) DemoMVGC(data);
    numDiagnostics = 3;
end

% make directory to hold results files
mkdir(sprintf('exp%s',expnum))

nvars = size(mats,1); % number of variables / oscillators
numMats = size(mats,3); % number of matrices we try
numSplits = length(tsplits); % number of splits in time
possedges = nvars^2-nvars; % possible edges for this number of variables
numVoters = reps * numSplits; % number of estimated matrices to vote over

nKvals = length(Kvals); % number of connection strengths

% tables to hold results
tableTrueEdges = zeros(numMats, 1);
tableResultsNorm = zeros(numMats, nKvals, reps, numSplits); 
tableResultsNormVoting = zeros(numMats, nKvals);
tableResultsDiagnostics = zeros(numMats, nKvals, reps, numSplits, numDiagnostics);
tableResultsInfEdges = zeros(numMats, nKvals, reps, numSplits);
tableResultsInfEdgesVoting = zeros(numMats, nKvals);
tableResultsFalsePos = zeros(numMats, nKvals, reps, numSplits);
tableResultsFalsePosVoting = zeros(numMats, nKvals);
tableResultsFalseNeg = zeros(numMats, nKvals, reps, numSplits);
tableResultsFalseNegVoting = zeros(numMats, nKvals);
tableResultsPerWrong = zeros(numMats, nKvals, reps, numSplits);
tableResultsPerWrongVoting = zeros(numMats, nKvals);

% set up time sampling
nobs = endtime / deltat;
tSpan = linspace(0,endtime,nobs);

% X1 and Y1 hold first trial 
Y1 = zeros(nvars, nobs, reps);
[theta1, X1] = preprocfn(Y1); % changes size if need be based on fn

% est holds network inference method's estimate of the networks
est = zeros(nvars, nvars, reps, numSplits);

% rseries holds the average of r(t) (synchrony measure) for each rep
rseries = zeros(nobs, reps);

count = 1; % number of times have run network inference method (so know how often to save work)

% loop over the networks 
for j = 1:numMats
    truth = mats(:,:,j);
    tableTrueEdges(j) = nnz(truth);
    
    % try each connection strength
    for k = 1:nKvals
        K = Kvals(k);
        
        % for each rep, different random frequencies, initial conditions, and noise
        for r = 1:reps
            % generate the data and save information about it
            Y = GenerateKuramotoData(truth, tSpan, ntrials, K, randicfn, randwfn);
            [theta, X] = preprocfn(Y);
            X1(:,:,r) = X(:,:,1);
            theta1(:,:,r) = theta(:,:,1);
            Y1(:,:,r) = Y(:,:,1);
            rseries(:,r) = mean(SynchronyMeasure(theta),2);
            
            % potentially split the time interval 
            beg = 1; % beginning of first time interval
            for s = 1:numSplits
                % run network inference on this time interval
                [est(:,:,r,s), diagnostics] = networkInferenceFn(X(:,beg:tsplits(s),:));
                beg = tsplits(s)+1; % beginning for next time interval
                count = count + 1;

                % save results
                tableResultsNorm(j, k, r, s) = norm(est(:,:,r,s) - truth)/norm(truth);
                tableResultsDiagnostics(j, k, r, s, :) = diagnostics;
                tableResultsInfEdges(j, k, r, s) = nnz(est(:,:,r,s)); 
                tableResultsFalsePos(j, k, r, s) = length(find(est(:,:,r,s) - truth == 1)); 
                tableResultsFalseNeg(j, k, r, s) = length(find(truth - est(:,:,r,s) == 1));
                tableResultsPerWrong(j, k, r, s) = length(find(truth ~= est(:,:,r,s)))/possedges;
                
                if mod(count,freq) == 0
                    % after every freq runs of networkInferenceFn, save the current state,
                    % in case want to check on preliminary results
                    save(sprintf('./exp%s/exp%s-partial.mat',expnum,expnum));
                end
            end
        end
        
        votingMat = round(sum(sum(est,3),4)/numVoters);
        tableResultsNormVoting(j, k) = norm(votingMat - truth)/norm(truth);
        tableResultsInfEdgesVoting(j, k) = nnz(votingMat);      
        tableResultsFalsePosVoting(j, k) = length(find(votingMat - truth == 1)); 
        tableResultsFalseNegVoting(j, k) = length(find(truth - votingMat == 1));
        tableResultsPerWrongVoting(j, k) = length(find(truth ~= votingMat))/possedges;
        
        % save little file with results from this network + K combination
        save(sprintf('./exp%s/Exp%s-Mat%d-k%d.mat',expnum,expnum,j,k),'truth','X1','theta1','Y1','rseries','est','tsplits')
    end
end

% update partial results and save whole workspace (including all those tables of results)
save(sprintf('./exp%s/exp%s-partial.mat',expnum,expnum));
save(sprintf('./exp%s/exp%s.mat',expnum,expnum));
    