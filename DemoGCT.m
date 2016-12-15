function [est, Portmanteau] = DemoGCT(u)
% base code posted at http://www.lcs.poli.usp.br/*baccala/BIHExtension2014/
% based on:
% Baccala & Sameshima. Overcoming the limitations of correlation analysis
% for many simultaneously processed neural structures, Progress in Brain
% Research, 130:33--47, 2001.
%            http://dx.doi.org/10.1016/S0079-6123(01)30004-3
%
% code adapted by Bethany Lusch
%
% INPUTS:
%
% u 
%       [n x m x N] matrix of time series data (n nodes, m time points, N time series)    
%
% OUTPUTS:
%
% est
%       [n x n] inferred adjacency matrix
%
% Portmanteau
%       BaseExperiment.m expects networkInferencefn to return diagnostics. 
%       if Portmanteau == 0, Poor MAR model fitting
%


[nvars, nobs, ~] = size(u);


%==========================================================================
%                     DTFn estimation and analysis parameters
%==========================================================================


%run example_analysis_parameters % Setting default paramaters

%==========================================================================
%                     Estimation and analysis parameters
%==========================================================================

%fs=1; 
maxIP=30;
criterion=1; % AIC - Akaike Information Criteria
alg=1; %1 = Nutall-Strand MVAR estimation algorithm
%nFreq=32;
%alpha=0.01;     % Significance level
gct_signif = 0.01; % Granger causality test significance level
%igct_signif = 0.01; % Instantaneous GCT significance level
MVARadequacy_signif = 0.05; % VAR model estimation adequacy significance
%metric='info'; % euc  = original PDC;
% diag = generalized PDC or gPDC;
% info = information PDC or iPDC.


%run example_pre_processing      % Detrending and/or standardization
%==========================================================================
%                    Detrend and normalization options
%==========================================================================
flgDetrend = 1;
flgStandardize = 0;


if flgDetrend,
    for i=1:nvars, u(i,:)=detrend(u(i,:)); end;
    disp('Time series were detrended.');
end;

if flgStandardize,
    for i=1:nvars, u(i,:)=u(i,:)/std(u(i,:)); end;
    disp('Time series were scale-standardized.');
end;



%run example_mvar_estimation     % Estimating VAR and testing adequacy of

%==========================================================================
%                            MVAR model estimation
%==========================================================================
[IP,pf,A,pb,B,ef,eb,vaic,Vaicv] = mvar(u,maxIP,alg,criterion);

disp(['Number of channels = ' int2str(nvars) ' with ' ...
    int2str(nobs) ' data points; MAR model order = ' int2str(IP) '.']);

%==========================================================================
%    Testing for adequacy of MAR model fitting through Portmanteau test
%==========================================================================
h=20; % testing lag
aValueMVAR = 1 - MVARadequacy_signif;
flgPrintResults = 0;
[Pass,Portmanteau,st,ths]=mvarresidue(ef,nobs,IP,aValueMVAR,h,...
    flgPrintResults);
% if Portmanteau == 0, Poor MAR model fitting


%==========================================================================
%         Granger causality test (GCT) and instantaneous GCT
%==========================================================================
flgPrintResults = 0;
[Tr_gct, pValue_gct, Tr_igct, pValue_igct] = gct_alg(u,A,pf,gct_signif, ...
    flgPrintResults);

est = zeros(nvars, nvars);
for r = 1:nvars,
    for s = 1:nvars,
        temp = -log10(pValue_gct(r,s));
        if temp > 2
            est(r,s) = 1;
        end
    end;
end;