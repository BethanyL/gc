% shift omega dist to middle: [-1, 1]

load('UsualParams.mat')
expnum = 'C7';

randwfn = @(n) 2*rand([n, 1]) - ones(n,1); % uniform [-1, 1]

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;