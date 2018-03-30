function un = WhiteGaussianNoise(u, strength)

% add white gaussian noise to u
ut = fft(u);
utn = ut + strength*(randn(size(u)) + 1i*randn(size(u)));
un = ifft(utn);
un = real(un);

end

