% first experiment on two-community network

load('TwoCommunityParams.mat')
expnum = 'B1';

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;