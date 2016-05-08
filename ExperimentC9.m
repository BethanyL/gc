% raise to 1000 trials

load('UsualParams.mat')
expnum = 'C9';

ntrials = 1000;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;