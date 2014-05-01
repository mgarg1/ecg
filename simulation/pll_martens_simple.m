% This script implements adaptive filtering to remove 50 Hz inteference
% as described in Martens et. al, "Improved Adaptive Line canceller for
% Electrocardiography", IEEE Transactions on Biomedical Engg. The variable
% names correspond to the symbols used in the paper. Error filtering and
% adaptation supression are not implemented.

clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 400; % Sample rate
N = 3000; % Num of samples
%%%%%%%%%%%%%%%%%%%%%%%%%%
Ka = 1/(0.13 * Fs);
Kphi = 6e-2;
Kdw = 9e-4;
omegan_p = 2*pi*50/Fs; % nominal frequency
%%%%%%%%%%%%%%%%%%%%%%%%%%

Ts = 1/Fs;
t = (1:N)'*Ts; % time

d = 2*sin(2*pi*49*t); % corrupt signal
e = zeros(size(d)); % error signal (cleaned signal)
x_est = zeros(size(d)); % inteference estimate

ymod_phi = zeros(size(d));
ymod_a = zeros(size(d));

osc_i = zeros(size(d));
osc_q = zeros(size(d));

thetaa_est = zeros(size(d));
thetaphi_est = zeros(size(d));
thetadw_est = zeros(size(d));

eta_a = zeros(size(d));
eta_phi = zeros(size(d));
alpha = zeros(size(d));

% set initial values
alpha(1) = 1;

for k=1:N-1
    % do work
    osc_i(k) = sin(omegan_p * k + thetaphi_est(k));
    osc_q(k) = cos(omegan_p * k + thetaphi_est(k));
    
    x_est(k) = thetaa_est(k) * osc_i(k);
    
    e(k) = d(k) - x_est(k);
    
    ymod_phi(k) = alpha(k) * osc_q(k);
    eta_phi(k) = 2*e(k)*ymod_phi(k);
    
    ymod_a(k) = osc_i(k);
    eta_a(k) = 2*e(k)*ymod_a(k);
    
    % update estimates
    thetaa_est(k+1) = thetaa_est(k) + Ka * eta_a(k);
    if (thetadw_est(k) + Kdw * eta_phi(k)) < 4*2*pi/Fs
        thetadw_est(k+1) = thetadw_est(k) + Kdw * eta_phi(k);
    end
    thetaphi_est(k+1) = thetaphi_est(k) + Kphi * eta_phi(k) + thetadw_est(k);
    alpha(k+1) = 1/thetaa_est(k+1);

end

plot(d','r');title('corrupt signal');
figure;
plot(e);title('filtered signal');

