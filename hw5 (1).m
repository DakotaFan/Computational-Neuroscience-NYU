clear; close all;

load dataHW.mat

init = [init_mu init_sig init_lambda; % e.g. [0 1 0.1]

pars = fminsearch(myNLL, init)

mu_est = pars(1);
sig_est = pars(2);
lambda_est = pars(3);
