%% Winner Take it all
[y,I] = max(A);
V_w = var(y);
s_true = -5:0.5:5;
bias_w = NaN(1,length(s_true));
for i = 1:length(s_true)
    bias_w(i) = (sum(y)-s_true(i))/length(y);
end
figure;
plot (s_true, bias_w)
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
        for i = 1:length(init)
        s_rat(j) = fminsearch(myNLL, init(i));
        
V_m = var(s_rat);
bias_max = sum(s_rat)/length(s_rat);





%%
function output = neglogL(s,r)
g = 0.5;
b = 0.1;
sigma = 5;
s_prefvec = linspace(-20, 20, 51);
f = (g*exp(-(s-s_prefvec).^2/2/sigma^2))+b;
output = -sum(r .* log(f)) + sum(f);
end

