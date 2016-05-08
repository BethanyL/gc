% main experiment for paper

load('UsualParams.mat')
expnum = 'C1';

% main experiment more thorough: more K values
Kvals = .1:.1:10;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;