% deltat 0.1, endtime 35

load('UsualParams.mat')
expnum = 'C16';

deltat = 0.1; % space between time points
endtime = 35; % solve Kuramoto model from 0 to T (endtime)
nobs = endtime / deltat; % number of time points (observations)
tsplits = nobs;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;