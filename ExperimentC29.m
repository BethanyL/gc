% vote in fourths

load('UsualParams.mat')
expnum = 'C29';

% 1-62, 63-124, 125-186, 187-248 (drop last two)
frac = .25;
first = floor(frac * nobs);
tsplits = first:first:nobs;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)


exit;