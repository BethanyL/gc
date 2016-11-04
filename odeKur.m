function dy = odeKur(t,y,param)

%     param{1} = number of nodes
%     param{2} = adjacency matrix
%     param{3} = natural frequencies
%     param{4} = connection strength

    % dy = change in phase
    % y  = phase
    
    % dy = w + sum over j (k * sin(y(j) - y(i)))
    r = repmat(y,1,param{1});
    
    % adj matrix: Aij non-zero if node j (colm) infl. node i (row)
    % sum over the columns (all the influences) 
    % ijth entry of r' - r should be jth node - ith node
    % example: 5,1 entry is 1st node - 5th node
    dy = param{3} + (param{4}/param{1})*sum(param{2} .* sin(r'-r),2);
    
end