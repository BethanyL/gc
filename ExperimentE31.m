% vary noise on 12-node E-R networks

load('UsualParams.mat')
expnum = 'E31';

measParam = 1;
noisefn  = @(data) WhiteGaussianNoise(data, measParam);
preprocfn = @(data) NoiseThenCosine(data, noisefn);

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;