% change to 6 oscillators

load('UsualParams.mat')
expnum = 'C2';

% use different set of networks for only 6 oscillators
mats = smallMats;


BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;