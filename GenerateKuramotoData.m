function Y = GenerateKuramotoData(A, tSpan, N, K, randicfn, randwfn)
    
    n = size(A,1);
    m = length(tSpan);
    Y = zeros(n,m,N);
    
    for j = 1:N
        start = randicfn(n);
        freq = randwfn(n);

        Y(:,:,j) = kuramoto(start,A,freq,tSpan,K);
    end
    
    % if N == 1, want 2D Y
    Y = squeeze(Y);
end

