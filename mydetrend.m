function dataD = mydetrend(data)

dataD = data;
[n,~,N] = size(data);
for j = 1:n
    for k = 1:N
        dataD(j,:,k) = detrend(squeeze(data(j,:,k)));
    end
end



end

