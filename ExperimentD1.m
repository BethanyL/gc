% main experiment for paper but shorter (only 5 values of K)
% really could just check subset of results from C1, but saving this as a 
% separate function is possibly less confusing

load('UsualParams.mat')
expnum = 'D1';

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;