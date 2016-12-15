function dataD = mydetrend(data)

% For each node and random trial, we have a time series. 
% Apply the detrend function to each of these times series 
% separately.
%
% INPUT:
%
% data
%       [n x m x N] matrix of data: nodes by time
%       by number of random trials
%
% OUTPUT:
%
% dataD
%       data of same size, but detrended 
%

dataD = data;
[n,~,N] = size(data);
for j = 1:n
    for k = 1:N
        dataD(j,:,k) = detrend(squeeze(data(j,:,k)));
    end
end



end

