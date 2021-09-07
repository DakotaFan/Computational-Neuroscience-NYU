clear; close all; clc;
set(0, 'DefaultAxesFontSize', 16)
%%
%Create Our Gabor Filter(a set of weights)

%Gaussian envelope
sigma =8;
k = ceil(3* sigma);

[X,Y] = meshgrid(-k:k, -k:k); %prepare the coordinate system
 
G = exp(-(X.^2+Y.^2)/2/sigma^2); %Guassian shape
G = G/sum(G(:));
%Sine wave
sp  = 0.5;


%Rotation of Gabor
theta = deg2rad(60);
Yprime = Y*cos(theta) - X*sin(theta);
S = cos(sp*Yprime);
W = G .* S;  %Gabor filter

figure;imagesc(-k:k, -k:k, W); colormap gray; axis equal; axis tight; axis xy

%%
%Construct Gabor stimulus (images)

svec = 0:10:180; % each of these corresponds to a different V1 neuron,a 19 orientations vector
r = NaN(1,length(svec));
for i = 1:length(svec)
    s = deg2rad(svec(i)); %convert the degree to radian
    Yprime = Y*cos(s) - X*sin(s);  %change the orientation depending on value of sevc
    S_rot = cos(sp*Yprime); % new sin function for Gabor stimulus
    I = G .* S_rot; %create the gabor image
    
    r(i) = sum(sum(W .* I));
end
figure; plot(svec, r, 'ko-')
set(0,'DefaultLineLineWidth',2);	
set(0,'DefaultAxesFontSize',14);
title('Tuning Curve of the Neuron')
xlabel('Orientation of the Stimuli (In Degree) ');
ylabel('Firing Rate of the Neuron');
xlim([0 180])
box off;

%%
%create stimulus with fixed orientation but different spatial frequency 

sfvec = 0.01:0.01:2; % each of these corresponds to a different spatial frequency
r = NaN(1,length(sfvec));
for i = 1:length(sfvec)
    Yprime = Y*cos(theta) - X*sin(theta);  %change the orientation depending on value of sevc
    S_rot = cos(sfvec(i)*Yprime); % new sin function for Gabor stimulus
    I_sp = G .* S_rot; %create the gabor image for different spatial frequency
    
    r(i) = sum(sum(W .* I_sp));
end
figure; plot(sfvec, r, 'g-')
set(0,'DefaultLineLineWidth',2);	
set(0,'DefaultAxesFontSize',14);
title('Tuning Curve of the Neuron')
xlabel('Spatial Frequency of the Stimuli');
ylabel('Firing Rate of the Neuron');
box off;    

%%
%Create stimulus with changing orientation and different spatial frequency
sfvec = 0.01:0.01:2; % each of these corresponds to a different spatial frequency
f = NaN(1,length(sfvec));
svec = 0:10:180; % each of these corresponds to a different V1 neuron,a 19 orientations vector
f_svec = transpose(NaN(1,length(svec)));
r = f_svec * f;
for i = 1:length(sfvec) 
    for p = 1:length(svec)
        svec = 0:10:180;
        s(p) = deg2rad(svec(p)); %convert the degree to radian
        Yprime = Y*cos(s(p)) - X*sin(s(p));  
        S_rot = cos(sfvec(i)*Yprime); % new sin function for Gabor stimulus
        I_sp = G .* S_rot; %create the gabor image for different spatial frequency
    r(p,i) = sum(sum(I_sp .* W));
    end
end
figure; h = heatmap(svec, sfvec, transpose(r),'colormap', parula);
h.YDisplayData = flipud(h.YDisplayData);
title('Tuning Curve of the V1 Neuron Responding to Orientation and Spatial Frequency')
xlabel('Orientation of the Stimuli (in degree) ')
ylabel('Spatial Frequency')