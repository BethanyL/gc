% deltat 0.05, endtime 25

load('UsualParams.mat')
expnum = 'C12';

deltat = 0.05; % space between time points
endtime = 25; % solve Kuramoto model from 0 to T (endtime)
nobs = endtime / deltat; % number of time points (observations)
tsplits = nobs;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;