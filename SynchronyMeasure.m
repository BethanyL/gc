function r = SynchronyMeasure(X)

nvars = size(X,1);
r = (1/nvars) * abs(sum(exp(1i * X), 1));
r = squeeze(r);

end

