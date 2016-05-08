% Split 1000 streams into 100 trials, 10 reps

load('UsualParams.mat')
expnum = 'C27';

ntrials = 100;
reps = 10;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;