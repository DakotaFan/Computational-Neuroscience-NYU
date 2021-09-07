clear; close all; clc;
set(0,'DefaultLineLineWidth',2)	%sets the default line width to 2 
set(0,'DefaultAxesFontSize',14)	%sets the default font size for plots to 14

%% Creating the tuning curve 
g = 0.5;
b = 0.1;
sigma = 5;
s_prefvec = linspace(-20, 20, 51);
s = -30: 30;

f = NaN(length(s_prefvec),length(s));

for i = 1:length(s_prefvec)
    s_pref = s_prefvec(i);
    f(i,:)= (g*exp(-(s-s_pref).^2/2/sigma^2))+b;

end
figure;
plot(s,f);
xlabel('Stimuli')
ylabel('Neuron Response')
title('Tuning Curves of fifty one Independent Poissan Neurons') 
%% Stimulus = 0
s = 0;
f = NaN(1,length(s_prefvec));
for i = 1:length(s_prefvec)
    s_pref = s_prefvec(i);
    f(i)= (g*exp(-(s-s_pref).^2/2/sigma^2))+b;
end

rat = sum(f)/length(s_prefvec);% calculate the rate parameter
A = poissrnd(rat,[51,1000]);%generating 1000 population pattern of activity of 51 neurons
[m,n] = size(A);
%% Winner Take it all
[y,I] = max(A);
V_w = var(y);
bias_winner = sum(y)/length(y);
%% Center-of-the-mass
C = sum(A,1);
B = NaN(1, n);
for i = 1:m
    for j = 1:n
        B(j) = (sum(A(i,j).*s_prefvec(i)))/C(j);%
    end
end
V_c = var(B);
bias_center = sum(B)/length(B);

%% Maximum Likelihood Decoder

s_rat = NaN(1, j);
for j = 1:n
        r = transpose(A(1:m,j));
        myNLL = @(s) neglogL(s,r);
        init = 0;
        s_rat(j) = fminsearch(myNLL, init);
end
V_m = var(s_rat);
bias_max = sum(s_rat)/length(s_rat);


%% Winner Take it all
[y,I] = max(A);
V_w = var(y);
s_true = -5:0.5:5;
bias_w = NaN(1,length(s_true));
v_winner = NaN(1, length(s_true));
for i = 1:length(s_true)
    bias_w(i) = (sum(y)-s_true(i))/length(y);
    v_winner(i) = var(y);
end

%% Center-of-the-mass
C = sum(A,1);
B = NaN(1, n);
for i = 1:m
    for j = 1:n
        B(j) = (sum(A(i,j).*s_prefvec(i)))/C(j);%
    end
end
v_center = NaN(1,length(s_true));
bias_c = NaN(1,length(s_true));
for i = 1:length(s_true)
    bias_c(i) = (sum(B)-s_true(i))/length(B);
    v_center(i) = var(B);
end


%% Maximum Likelihood Decoder

s_rat = NaN(1, j);
for j = 1:n
        r = transpose(A(1:m,j));
        myNLL = @(s) neglogL(s,r);
        init = 0;
        s_rat(j) = fminsearch(myNLL, init);
end
v_max = NaN(1, length(s_true));
bias_m = NaN(1,length(s_true));
for i = 1:length(s_true)
    bias_m(i) = (sum(s_rat)-s_true(i))/length(s_rat);
    v_max(i) = var(s_rat);
end
figure;
plot(s_true,bias_w);
hold on
plot(s_true,bias_c);
hold on
plot(s_true,bias_m);
hold off

figure;
plot(s_true,v_winner);
hold on
plot(s_true,v_center);
hold on
plot(s_true,v_max);
hold off
%%
function output = neglogL(s,r)
g = 0.5;
b = 0.1;
sigma = 5;
s_prefvec = linspace(-20, 20, 51);
f = (g*exp(-(s-s_prefvec).^2/2/sigma^2))+b;
output = -sum(r .* log(f)) + sum(f);
end

