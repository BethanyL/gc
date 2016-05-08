% shift IC to left [-2pi, 0]

load('UsualParams.mat')
expnum = 'C4';

randicfn = @(n) -2*pi*rand([n, 1]); % uniform [-2pi, 0]

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;