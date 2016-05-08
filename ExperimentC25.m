% Split 1000 streams into 1000 reps, 1 trial

load('UsualParams.mat')
expnum = 'C25';

ntrials = 1;
reps = 1000;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;