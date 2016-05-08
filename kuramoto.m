function Y = kuramoto(ic,adj,w,tSpan,K)

    param{1} = size(ic,1); % number of nodes
    param{2} = adj; % adjacency matrix
    param{3} = w; % natural frequencies
    param{4} = K; % connection strength
    
    SOL = ode45(@(t,y) odeKur(t,y,param),tSpan,ic);
    Y = deval(SOL, tSpan); 
end 
