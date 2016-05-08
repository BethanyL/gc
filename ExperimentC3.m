% change to 24 oscillators

load('UsualParams.mat')
expnum = 'C3';

% make different set of networks for 24 oscillators
nvars = 24;
mats = zeros(nvars, nvars, npvals);
for j = 1:npvals
    p = pvals(j);
    A = MakeNetworkER(nvars, p);
    % make sure diagonal is all zeros
    A(1:(nvars+1):end)=0;
    mats(:,:,j) = A;
end


BaseExperiment(expnum, mats, Kvals, randwfn, randicfn, preprocfn, ...
    deltat, endtime, ntrials, reps, tsplits, freq)

exit;