% Split 1000 streams into 10 trials, 100 reps

load('UsualParams.mat')
expnum = 'C26';

ntrials = 10;
reps = 100;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;