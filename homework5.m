clear; close all;
set(0,'DefaultLineLineWidth',2)	%sets the default line width to 2 
set(0,'DefaultAxesFontSize',14)	
%% right tilted proportion
load('dataHW5.mat')
A = unique(data(:,1));
P = NaN(1,8);
p = NaN(1,8);
for i = 1:length(A)
    q = A(i);
    ind =find(data(:,1) == q);%find the stimulus for 8 unique stimulus and save the index as ind
    P(i) = sum(data(ind,2)==1)/numel(data(ind,2));%the proportion of right-tilted response
    p(i) = sum(data(ind,3)==1)/numel(data(ind,3));% the proportion of correct responses
end

figure;
plot(A, P, '-o');
xlabel('Stimulus Orientation in degrees');
ylabel('Proportion of clockwise responses');
title('The proportion of clockwise responses versus varing stimulus')
box off	
figure;
plot(A, p, 'k-o');
xlabel('Stimulus Orientation in degrees')
ylabel('Proportion of correct responses')
title('The proportion of correct responses versus varing stimulus')
box off	

%% Maximum Likelihood decoder


    
    myNLL = @(pars) neglogL4(pars,data);%given the data, we want to find the opitimal pars
    nruns = 100; %run 100 initialization 
    output = NaN(1,100);
    pars = NaN(100, 3);
for j = 1:100
    init = [randn+1 rand rand];%each time generate random mu(positive or negative), sigma(positive), and lambda(between 0 to 1)
    [pars(j,:), output(j)]= fminsearch(myNLL, init);%save the minimum value to the output
    %save the set of value to pars(which is a 100 x 3 matrix)
end
   [~, ind] = min(output);
   mu_est = pars(ind,1);
   sig_est = pars(ind,2);
   lambda_est = pars(ind,3);

  

%%

stimulus = linspace(-1.9,1.9,100);%make a fine grid s line
p_right = NaN(1, length(stimulus));
for i = 1:length(stimulus)
    p_right(i) = (lambda_est/2)+ (1-lambda_est).*normcdf(stimulus(i),mu_est,sig_est); %utilize the pars value to create the model fit
end
figure;
plot(A, P, 'ko');
title('Model fit for the Maximum Likelihood Decoder')
xlabel('Stimulus Orientation in degrees');
ylabel('Proportion of clockwise responses');
hold on
plot(stimulus, p_right,'-');
legend('Data','Model');
box off
hold off
