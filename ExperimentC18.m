% deltat 0.2, endtime 15

load('UsualParams.mat')
expnum = 'C18';

deltat = 0.2; % space between time points
endtime = 15; % solve Kuramoto model from 0 to T (endtime)
nobs = endtime / deltat; % number of time points (observations)
tsplits = nobs;

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;