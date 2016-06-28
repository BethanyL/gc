% for comparison between MVGC, GCCA, GCT, eGC (and basic GC coming with
% eGC)

% add path to code from Sameshmia, et al. 2015 paper 
% "On the statistical performance of Granger-causal connectivity
% estimators"
% code available at http://www.lcs.poli.usp.br/*baccala/BIHExtension2014/

current_root = fileparts(mfilename('fullpath')); % directory containing this file

addpath(current_root);
addpath(fullfile(current_root,'asymp_package_v3'));
addpath(fullfile(current_root,'asymp_package_v3','routines'));
addpath(fullfile(current_root,'asymp_package_v3','supporting'));
addpath(fullfile(current_root,'asymp_package_v3','supporting','suplabel'));


load('UsualParams.mat')
expnum = 'D2_GCT';

mats = smallMats;
ntrials = 1;
reps = 50;

networkInferenceFn = @(data) DemoGCT(data);
numDiagnostics = 1;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq, networkInferenceFn, ...
    numDiagnostics)

exit;