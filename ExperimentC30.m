% vote in eighths

load('UsualParams.mat')
expnum = 'C30';

% 1-31, 32-62, 63-93, 94-124, 125-155, 156-186, 187-217, 218-248 (drop last
% 2)
frac = .125;
first = floor(frac * nobs);
tsplits = first:first:nobs;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)


exit;