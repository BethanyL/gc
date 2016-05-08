% for comparison to GCT

load('UsualParams.mat')
expnum = 'D2';

load('../GCT/UsualParams.mat','mats')
ntrials = 1;
reps = 50;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)


exit;