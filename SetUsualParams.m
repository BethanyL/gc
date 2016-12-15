% This script saves a .mat file with the parameters we usually want to use in
% our experiments. We can then load that .mat file and change the parts that we
% want to experiment with.

clear all; close all; clc;

% First, generate Erdos-Renyi networks
% p is the probability that an edge exists (roughly, the density of the
% network)
pvals = .05:.05:1;
npvals = length(pvals);
% nvars is the number of variables/nodes (oscillators for us)
nvars = 12;
nvarsSmall = 6;
mats = zeros(nvars, nvars, npvals);
smallMats = zeros(nvarsSmall, nvarsSmall, npvals);

for j = 1:npvals
    p = pvals(j);
    A = MakeNetworkER(nvars, p);
    Asmall = MakeNetworkER(nvarsSmall, p);
    % make sure diagonal is all zeros to make it easier to compare to
    % results
    % (the diagonal is not used in the Kuramoto model anyway)
    A(1:(nvars+1):end)=0;
    Asmall(1:(nvarsSmall+1):end)=0;
    mats(:,:,j) = A;
    smallMats(:,:,j) = Asmall;
end

% Pick K values to try (connection strengths)
Kvals = [.5, 1, 2, 4, 8];
nKvals = length(Kvals);

% set distributions for random frequencies (w), initial conditions, and
% noise
measParam = 2.5;
randwfn = @(n) 2*rand([n, 1]); % uniform [0, 2]
randicfn = @(n) 2*pi*rand([n, 1]); % uniform [0, 2pi]

% set preprocessing step for data
noisefn  = @(data) WhiteGaussianNoise(data, measParam);
preprocfn = @(data) NoiseThenCosine(data, noisefn);

% set the sampling in time
deltat = 0.1; % space between time points
endtime = 25; % solve Kuramoto model from 0 to T (endtime)
nobs = endtime / deltat; % number of time points (observations)

% Decide how many times to solve Kuramoto model, randomizing the
% frequencies, initial conditions, and noise each time.
% We generate ntrials * reps random instances.
ntrials = 100; % number of instances to pass to GC algorithm at once
reps = 1; % number of times to run GC algorithm (each with a different ...
% set of ntrials instances

% if splitting the data in time, where do we split it?
% standard experiment: no split, so use time index 1 to nobs
tsplits = nobs;

% How often save workspace (after freq runs of GC)
freq = 10;

% A, j, p were temporary, so no need to save them
clearvars A Asmall j p
save('UsualParams.mat')