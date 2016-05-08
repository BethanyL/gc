% vote in 10ths and detrend instead of cosine

load('UsualParams.mat')
expnum = 'C24';

% 1 - 25, 26 - 50, ..., 226 - 250
tsplits = 25:25:250;

preprocfn = @(data) NoiseThenDetrend(data, noisefn);

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)


exit;