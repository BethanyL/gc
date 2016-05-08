% use differencing

load('UsualParams.mat')
expnum = 'C23';

preprocfn = @(data) NoiseThenDiff(data, noisefn);
tsplits = nobs - 1; % because preprocfn takes away a data point

BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;