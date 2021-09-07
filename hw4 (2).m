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

figure;
plot(svec, f)

struevec = -5:0.5:5;
[bias_WTA, bias_COM, bias_ML, var_WTA, var_COM, var_ML] = deal(NaN(size(struevec)));

for k = 1:length(struevec)
    s = struevec(k)
    
    %% Part b
    %s = 0; % FIXED stimulus!!
    f_s = g * exp(-(s-sprefvec).^2/2/sig_tc^2) + b; % 1 x 51
    
    ntrials = 10000;
    
    r = NaN(ntrials, length(sprefvec)); % Trials by neurons (1000 x 51)
    for i = 1:ntrials
        r(i,:) = poissrnd(f_s);
    end
    
    % % Without a for-loop:
    % F_s = repmat(f_s,[ntrials,1]);
    % r = poissrnd(F_s);
    
    %% Part c
    
    [shat_WTA, shat_COM, shat_ML] = deal(NaN(1,ntrials));
    for i = 1:ntrials
        r = poissrnd(f_s);
        
        % Winner-take-all decoder - first try
        % [~,ind] = max(r);
        % shat_WTA(i) = sprefvec(ind);
        
        % Winner-take-all decoder - better try
        allmax = find(r==max(r));
        if length(allmax)==1
            ind = allmax;
        else
            ind = randsample(allmax,1);
        end
        shat_WTA(i) = sprefvec(ind);
        
        if sum(r) == 0
            shat_COM(i) = 0;
        else
            shat_COM(i) = sum(r .* sprefvec)/sum(r);
        end
        
        % Maximum-likelihood decoder
        myNLL = @(s) neglogL(s,r);
        
        nruns = 2; % run 10 different initializations for s (multistart)
        output = NaN(1,nruns);
        pars = NaN(nruns,1);
        for j = 1:10
            init = rand; % Randomize init
            [pars(j),output(j)] = fminsearch(myNLL,init); % Optimize and save
        end
        [~,ind] = min(output);
        shat_ML(i) = pars(ind);
      
    end
    
    %% Part d
    bias_WTA(k) = mean(shat_WTA) - s;
    bias_COM(k) = mean(shat_COM) - s;
    bias_ML(k) = mean(shat_ML) - s;
    
    var_WTA(k) = var(shat_WTA);
    var_COM(k) = var(shat_COM);
    var_ML(k) = var(shat_ML);
end

%% Plots

figure;
subplot(1,2,1);
plot(struevec, [bias_WTA; bias_COM; bias_ML]); 
legend('WTA','COM','ML')
xlabel('Stimulus'); set(gca,'xtick', -5:1:5)
ylabel('Bias')

subplot(1,2,2);
plot(struevec, [var_WTA; var_COM; var_ML]);
legend('WTA','COM','ML')
xlabel('Stimulus'); set(gca,'xtick', -5:1:5)
ylabel('Variance')