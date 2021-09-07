clear; close all;
set(0,'DefaultLineLineWidth',2);
set(0,'DefaultAxesFontSize',14);

%% Part a

g = 0.5;
b = 0.1;
sig_tc = 5;
sprefvec = linspace(-20,20,51);

svec = linspace(-40,40,1000);

f = NaN(length(sprefvec), length(svec)); % Neurons by stimuli

for i = 1:length(sprefvec)
    f(i,:) = g * exp(-(svec-sprefvec(i)).^2/2/sig_tc^2) + b;
end

%figure;
%plot(svec, f)

struevec = -5:0.5:5;
p_right = NaN(1,21);

for k = 1:length(struevec)
    s = struevec(k);
    
    %% Part b
    %s = 0; % FIXED stimulus!!
    f_s = g * exp(-(s-sprefvec).^2/2/sig_tc^2) + b; % 1 x 51
    
    ntrials = 1000;
    
    r = NaN(ntrials, length(sprefvec)); % Trials by neurons (1000 x 51)
    for i = 1:ntrials
        r(i,:) = poissrnd(f_s);
    end
    
    % % Without a for-loop:
    % F_s = repmat(f_s,[ntrials,1]);
    % r = poissrnd(F_s);
    
    %% Part c
    
    shat_ML = NaN(1,ntrials);
    response = NaN(1, ntrials);
    for i = 1:ntrials
        r = poissrnd(f_s);
        

        % Maximum-likelihood decoder
        myNLL = @(s) neglogL(s,r);
        
        nruns = 2; % run 10 different initializations for s (multistart)
        output = NaN(1,nruns);
        pars = NaN(nruns,1);
        
        for j = 1:2
            init = rand; % Randomize init
            [pars(j),output(j)] = fminsearch(myNLL,init); % Optimize and save
        end
        [~,ind] = min(output);
        shat_ML(i) = pars(ind);
        if shat_ML(i) >= 0 
            response(i) = 1; %output the right-tilted response
        else 
            response(i) = 0;%output the left-tilted response 
        end
        
    end
    p_right(k) = (sum(response))/1000; %for each stimuli(k), calculate the proportion of the right-tilted response
end   
figure;
plot(struevec, p_right,'k-');
xticks([-5 -4 -3 -2 -1 0 1 2 3 4 5]);
xlabel('True stimulus');
ylabel('The probability of making a right-tilted response');
title('The psychometric curve for making a right-tilted response');
box off;
