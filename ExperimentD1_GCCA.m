% main experiment for paper but shorter (only 5 values of K)
% compare using GCCA toolbox

load('UsualParams.mat')
expnum = 'D1_GCCA';

networkInferenceFn = @(data) DemoGCCA(data);
numDiagnostics = 3;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq, networkInferenceFn, ...
    numDiagnostics)

exit;