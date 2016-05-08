% lower to 10 trials

load('UsualParams.mat')
expnum = 'C8';

ntrials = 10;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;