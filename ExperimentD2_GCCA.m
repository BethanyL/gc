% for comparison between MVGC, GCCA, GCT, eGC (and basic GC coming with
% eGC)
% GCCA is Granger Causal Connectivity Analysis, the predecessor 
% to MVGC. In DemoGCCA, we use an option in the MVGC to use the
% GCCA version. 

load('UsualParams.mat')
expnum = 'D2_GCCA';

mats = smallMats;
ntrials = 1;
reps = 50;

networkInferenceFn = @(data) DemoGCCA(data);
numDiagnostics = 3;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq, networkInferenceFn, ...
    numDiagnostics)

exit;