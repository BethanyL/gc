function BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, ...
    preprocfn, deltat, endtime, ntrials, reps, tsplits, freq, ...
    networkInferenceFn, numDiagnostics)

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

% est holds Granger Causality's estimate of the networks
est = zeros(nvars, nvars, reps, numSplits);
%decay = cell(reps,numSplits);

% rseries holds the average of r(t) (synchrony measure) for each rep
rseries = zeros(nobs, reps);

count = 1; % number of times have run GC (so know how often to save work)

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
                % run Granger Causality on this time interval
                [est(:,:,r,s), diagnostics] = networkInferenceFn(X(:,beg:tsplits(s),:));
                %[est(:,:,r,s), acminlags, morder, diffCheck, decay{r,s}] = networkInferenceFn(X(:,beg:tsplits(s),:), truth);
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
                    % after every 10 runs of GC, save the current state,
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
        
        save(sprintf('./exp%s/Exp%s-Mat%d-k%d.mat',expnum,expnum,j,k),'truth','X1','theta1','Y1','rseries','est','tsplits')
    end
end
save(sprintf('./exp%s/exp%s-partial.mat',expnum,expnum));
save(sprintf('./exp%s/exp%s.mat',expnum,expnum));
    