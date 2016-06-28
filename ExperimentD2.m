% for comparison between MVGC, GCCA, GCT, eGC (and basic GC coming with
% eGC)

load('UsualParams.mat')
expnum = 'D2';

mats = smallMats;
ntrials = 1;
reps = 50;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)


exit;