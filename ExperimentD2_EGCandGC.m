% for comparison between MVGC, GCCA, GCT, eGC (and basic GC coming with
% eGC)

% add path to code from Schiatti, et al. 2015 paper 
% "Extended Granger causality: a new tool to identify the structure of 
% physiological networks"
% toolbox available at www.lucafaes.net/eGC.html

current_root = fileparts(mfilename('fullpath')); % directory containing this file
addpath(fullfile(current_root,'EGC'));
addpath(fullfile(current_root,'EGC','functions'));



load('UsualParams.mat')
expnum = 'D2_EGC';

mats = smallMats;
ntrials = 1;
reps = 50;

p = 5; % model order: tried 2-7
eFlag = 1; % do extended version of GC
networkInferenceFn = @(data) DemoEGC(data, p, eFlag);
numDiagnostics = 0;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq, networkInferenceFn, ...
    numDiagnostics)

%%%%%%%%%%%%%%%%%%%
expnum = 'D2_GC';

eFlag = 0; % do non-extended version of GC
networkInferenceFn = @(data) DemoEGC(data, p, eFlag);

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq, networkInferenceFn, ...
    numDiagnostics)

exit;