% two-node networks 

load('UsualParams.mat')
expnum = 'A2';

% all four possible 2-node networks
mats = zeros(2,2,4);
mats(1,2,2) = 1;
mats(2,1,3) = 1;
mats(1,2,4) = 1;
mats(2,1,4) = 1;

Kvals = .1:.1:10; % more thorough: more K values
randwfn = @(n) 2*rand([n, 1]) - ones(n,1); % uniform [-1, 1]

measParam = .5;
noisefn  = @(data) WhiteGaussianNoise(data, measParam);
preprocfn = @(data) NoiseThenCosine(data, noisefn);

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;