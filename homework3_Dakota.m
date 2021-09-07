clear; close all; clc;
set(0,'DefaultLineLineWidth',2)	%sets the default line width to 2 
set(0,'DefaultAxesFontSize',14)	%sets the default font size for plots to 14

%% Creating the tuning curve 
g = 0.5;
b = 0.1;
sigma = 5;
s_pref = linspace(-20, 20, 51);
s = linspace(-30, 30);
f = NaN(length(s),length(s_pref)); 
for i = 1:length(s_pref)
    s_pref = s_pref(i);
    f(i, :) = g*exp(-(s-s_pref).^2/2*sigma^2)+b;
end
plot(s,s_pref)
