% deltat 0.2, endtime 5

load('UsualParams.mat')
expnum = 'C17';

deltat = 0.2; % space between time points
endtime = 5; % solve Kuramoto model from 0 to T (endtime)
nobs = endtime / deltat; % number of time points (observations)
tsplits = nobs;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;