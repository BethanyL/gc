% shift IC to middle [-pi, pi]

load('UsualParams.mat')
expnum = 'C5';

randicfn = @(n) 2*pi*rand([n, 1]) - pi*ones(n,1); % uniform [-pi, pi]

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;