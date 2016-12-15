%%
% this function is a slight variation on the demo provided by the MVGC
% toolbox, written by Bethany Lusch for testing
%
% INPUTS:
%
% X 
%       [n x m x N] matrix of time series data (n nodes, m time points, N time series)   
%
% OUTPUTS:
%
% mat
%       [n x n] inferred adjacency matrix
%
% diagnostics
%       vector of diagnostics about this run: [warningRho, morder, warningPosDef], where 
%       warningRho is binary: 1 if received 'WARNING: unstable VAR (unit root)' and 0 otherwise
%       morder is the model order chosen
%       warningPosDef is binary: 1 if received 'WARNING: residuals covariance matrix not positive-definite' and 0 otherwise
%
% below are comments from MVGC toolbox: 
%% MVGC "GCCA compatibility mode" demo
%
% Demonstrates usage of the MVGC toolbox in "GCCA compatibility mode"; see
% <mvgchelp.html#6 Miscellaneous issues> in the Help documentation. This is
% partly for the benefit of former users of the Granger Causal Connectivity
% Analysis (<http://www.sussex.ac.uk/Users/anils/aks_code.htm GCCA>) Toolbox
% [2], and partly as an implementation of a more "traditional" approach to
% Granger causality computation. The chief difference is that here two separate
% VAR regressions - the _full_ and _reduced_ regressions (see [1]) - are
% explicitly performed (see <GCCA_tsdata_to_pwcgc.html
% |GCCA_tsdata_to_pwcgc|>), in contrast to the MVGC Toolbox preferred
% approach (see <mvgc_demo.html |mvgc_demo|>), which only requires a full
% regression and is consequently more flexible and numerically accurate.
%
% Granger-causal pairwise-conditional analysis is demonstrated on generated
% VAR data for a 5-node network with known causal structure (see
% <var5_test.html |var5_test|>), as in the main MVGC Toolbox demonstration
% script, <mvgc_demo.html |mvgc_demo|>. A drawback of the traditional dual
% regression approach is that in the frequency domain, _conditional_
% spectral causalities cannot be estimated to an acceptable standard; see
% [1] and <GCCA_tsdata_to_smvgc.html |GCCA_tsdata_to_smvgc|> for more
% detail.
%
%% References
%
% [1] L. Barnett and A. K. Seth,
% <http://www.sciencedirect.com/science/article/pii/S0165027013003701 The MVGC
%     Multivariate Granger Causality Toolbox: A New Approach to Granger-causal
% Inference>, _J. Neurosci. Methods_ 223, 2014
% [ <matlab:open('mvgc_preprint.pdf') preprint> ].
%
% [2] A. K. Seth, "A MATLAB toolbox for Granger causal connectivity analysis",
% _J. Neurosci. Methods_ 186, 2010.
%
% (C) Lionel Barnett and Anil K. Seth, 2012. See file license.txt in
% installation directory for licensing terms.
%
%%
function [mat, diagnostics] = DemoGCCA(X)
%% Parameters

ntrials   = size(X, 3);     % number of trials
nobs      = size(X, 2);     % number of observations per trial
nvars     = size(X, 1);     % number of nodes

regmode   = 'OLS';  % VAR model estimation regression mode ('OLS', 'LWR' or empty for default)
icregmode = 'LWR';  % information criteria regression mode ('OLS', 'LWR' or empty for default)

morder    = 'AIC';  % model order to use ('actual', 'AIC', 'BIC' or supplied numerical value)
momax     = 20;     % maximum model order for model order estimation

tstat     = '';     % statistical test for MVGC:  'chi2' for Geweke's chi2 test (default) or'F' for Granger's F-test
alpha     = 0.05;   % significance level for significance test
mhtc      = 'FDR';  % multiple hypothesis test correction (see routine 'significance')

%seed      = 0;      % random seed (0 for unseeded)


%% We don't generate data here because we pass it in.

%% Model order estimation

% Calculate information criteria up to max model order

ptic('\n*** tsdata_to_infocrit\n');
[AIC,BIC] = tsdata_to_infocrit(X,momax,icregmode);
ptoc('*** tsdata_to_infocrit took ');

[~,bmo_AIC] = min(AIC);
[~,bmo_BIC] = min(BIC);

% Plot information criteria.

% figure(1); clf;
% plot((1:momax)',[AIC BIC]);
% legend('AIC','BIC');

%amo = size(AT,3); % actual model order

fprintf('\nbest model order (AIC) = %d\n',bmo_AIC);
fprintf('best model order (BIC) = %d\n',bmo_BIC);
%fprintf('actual model order     = %d\n',amo);

% Select model order

% if     strcmpi(morder,'actual')
%     morder = amo;
%     fprintf('\nusing actual model order = %d\n',morder);
if strcmpi(morder,'AIC')
    morder = bmo_AIC;
    fprintf('\nusing AIC best model order = %d\n',morder);
elseif strcmpi(morder,'BIC')
    morder = bmo_BIC;
    fprintf('\nusing BIC best model order = %d\n',morder);
else
    fprintf('\nusing specified model order = %d\n',morder);
end

%% Granger causality estimation

% Calculate time-domain pairwise-conditional causalities. Return VAR parameters
% so we can check VAR.

ptic('\n*** GCCA_tsdata_to_pwcgc... ');
[F,A,SIG] = GCCA_tsdata_to_pwcgc(X,morder,regmode); % use same model order for reduced as for full regressions
ptoc;

% Check for failed (full) regression

assert(~isbad(A),'VAR estimation failed');

% Check for failed GC calculation

assert(~isbad(F,false),'GC calculation failed');

% Check VAR parameters (but don't bail out on error - GCCA mode is quite forgiving!)

rho = var_specrad(A);
fprintf('\nspectral radius = %f\n',rho);
if rho >= 1,       
    fprintf(2,'WARNING: unstable VAR (unit root)\n'); 
    warningRho = rho; 
else
    warningRho = 0; 
end
if ~isposdef(SIG), 
    fprintf(2,'WARNING: residuals covariance matrix not positive-definite\n'); 
    warningPosDef = 1;
else
    warningPosDef = 0;
end

% Significance test using theoretical null distribution, adjusting for multiple
% hypotheses.

pval = mvgc_pval(F,morder,nobs,ntrials,1,1,nvars-2,tstat);
sig  = significance(pval,alpha,mhtc);

mat = sig;
mat(1:(nvars+1):end) = 0;

% Plot time-domain causal graph, p-values and significance.

% figure(2); clf;
% subplot(1,3,1);
% plot_pw(F);
% title('Pairwise-conditional GC');
% subplot(1,3,2);
% plot_pw(pval);
% title('p-values');
% subplot(1,3,3);
% plot_pw(sig);
% title(['Significant at p = ' num2str(alpha)])

fprintf(2,'\nNOTE: no frequency-domain pairwise-conditional causality calculation in GCCA compatibility mode!\n');

diagnostics = [warningRho, morder, warningPosDef];
%%
% <mvgc_demo_GCCA.html back to top>
