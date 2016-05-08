% vote in halves

load('UsualParams.mat')
expnum = 'C28';

% 1-125, 126 - 250 
frac = .5;
first = floor(frac * nobs);
tsplits = first:first:nobs;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)


exit;