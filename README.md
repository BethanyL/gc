This is the code used for [the paper](https://journals.aps.org/pre/abstract/10.1103/PhysRevE.94.032220) "Inferring connectivity in networked dynamical systems: Challenges using Granger causality" by Bethany Lusch, Pedro D. Maia, and J. Nathan Kutz, published in Physical Review E in September 2016. 

We systematically test pairwise-conditional Granger causality on data generated from a nonlinear model with known causal network structure. Specifically, we simulate networked systems of Kuramoto oscillators and use the [Multivariate Granger Causality Toolbox](http://users.sussex.ac.uk/~lionelb/MVGC/) to reconstruct the underlying network. We compare the results to the ground truth for a wide range of parameters.

The code was written by Bethany Lusch and is entirely in Matlab. It is posted so that you can recreate the results of the paper, but it is also designed so that it can be a suite of tests for any network inference method. 

BaseExperiment.m is the main function. It has many parameters so that everything can be varied. UsualParams.mat contain the default parameters. ExperimentA1.m, ExperimentA2.m, ... are scripts that call BaseExperiment.m. They load UsualParams.mat and change whichever parameters are different for that experiment. See SetUsualParams.m for how UsualParams.mat was created.

Instructions:

1. Download the code from Github.

2. To test the same toolboxes that we did did, download & install their code:

  - [Multivariate Granger Causality Toolbox](http://users.sussex.ac.uk/~lionelb/MVGC/) (MVGC) the one that most of the experiments use

  - [Extended Granger Causality](http://www.lucafaes.net/eGC.html) (eGC) 

  - [Granger Causlity Test](http://www.lcs.poli.usp.br/~baccala/BIHExtension2014/) (GCT) 

3. Run scripts ExperimentA1.m, ExperimentA2.m,... if you wish to recreate the results, or create your own variations.

To test different code for network inference, change the input networkInferenceFn to another function that accepts the time series data as input and outputs an adjacency matrix and any number of diagnostics. The input numDiagnostics states how many diagnostics you expect networkInferenceFn to output. The defaults here are at the top of BaseExperiment.m. 

Note: the time series data dimensions should be nodes, then time, then random trials (having a third dimension, or multiple random trials, is optional).

See Tables I, III, and VI in the paper for summaries of the experiments and how they relate to the figures. 
