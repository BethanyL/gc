% shift omega dist to far left: [-2, 0]

load('UsualParams.mat')
expnum = 'C6';

randwfn = @(n) -2*rand([n, 1]); % uniform [-2, 0]

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;
