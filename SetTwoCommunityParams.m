% exactly as in cylinder picture

load('UsualParams.mat')

mats = [0 1 1 0 1 1, 0 0 0 0 0 0;
      1 0 0 0 0 0, 0 0 0 0 0 0;
      0 1 0 1 0 0, 0 0 0 0 0 0;
      0 1 0 0 0 1, 0 0 0 0 0 0;
      0 0 0 1 0 1, 0 0 0 0 0 0;
      1 0 0 0 0 0, 0 0 0 0 0 0; % 6
      0 0 0 0 0 0, 0 1 1 0 1 1;
      0 0 0 0 0 0, 1 0 0 0 0 0;
      0 0 0 0 0 0, 0 1 0 1 0 0;
      0 0 0 0 0 0, 0 1 0 0 0 1;
      0 0 0 0 0 0, 0 0 0 1 0 1;
      0 0 0 0 0 0, 1 0 0 0 0 0];


ntrials = 1;

ic = [10, 11, 6, 9, 5, 3, 8, 4, 0, 2, 7, 1]'*(2*pi)/11;
randicfn = @(n) ic;

w = [repmat(.5,6,1); repmat(-.2,6,1)];
w = w + repmat([.1, -.1, .15, -.15, .05, -.05]',2,1);
randwfn = @(n) w;

measParam = .1;
noisefn  = @(data) WhiteGaussianNoise(data, measParam);
preprocfn = @(data) NoiseThenCosine(data, noisefn);
              
Kvals = 5;

save('TwoCommunityParams.mat')
