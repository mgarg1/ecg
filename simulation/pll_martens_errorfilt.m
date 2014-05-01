% This script implements adaptive filtering to remove 50 Hz inteference
% as described in Martens et. al, "Improved Adaptive Line Canceller for
% Electrocardiography", IEEE Transactions on Biomedical Engg. The variable
% names correspond to the symbols used in the paper. Error filtering and
% adaptation supression are not implemented.

clear all; close all;

%%%%%%%%%%%%%%%%%%%%%%%%%%
Fs = 400; % *dont* change without changing the error filter
N = 11000; % Num of samples. Keep above 11000.
%%%%%%%%%%%%%%%%%%%%%%%%%%
Ka = 1/(0.13 * Fs);
Kphi = 6e-2;
Kdw = 9e-4;
omegan_p = 2*pi*50/Fs; % nominal frequency. *dont* change without changing the error filter
eps = 1e-15; % epsilon
%%%%%%%%%%%%%%%%%%%%%%%%%%
Ts = 1/Fs;
t = (1:N)'*Ts; % time

b = [3.3519 -6.7038 3.3519]; % error filter numerator
a = [1 -0.7478 0.2722]; % error filter denominator

s = 10 + 1.1*sin(2*pi*6*t);
s(1000:2000) = 0;
% the interference signal is initially 0. Then a 49 Hz sine starts, its
% amplitude steps up, down. Afterwords, the frequency changes abruptly to
% 51 Hz with an amplitude step. Subsequently, the frequency changes back to
% 49 Hz with an amplitude step. Finally, the interference drops to 0.
x = 2*sin(2*pi*49*t); % corrupt signal
x(4000:5000) = 0;
x(6000:8000) = 2*x(6000:8000);
x(8000:10000) = 2*sin(2*pi*51*Ts*(8000:10000));
x(10000:end) = 0;

d = x + s; % corrupt signal

e = zeros(size(d)); % error signal (cleaned signal)
ew = zeros(size(d)); % filtered error signal
x_est = zeros(size(d)); % inteference estimate

ymod_phi = zeros(size(d));
ymodw_phi = zeros(size(d)); % filtered signature
ymod_a = zeros(size(d));
ymodw_a = zeros(size(d)); % filtered signature

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
    ew(k) = b(1) * e(k); % high pass filter the error (desired) signal
    for it=2:max(size(a))
        if (k-it+1) > 0
            ew(k) = ew(k) + b(it)*e(k - it + 1) - a(it)*ew(k - it + 1);
        end
    end
    
    ymod_phi(k) = alpha(k) * osc_q(k);
    ymodw_phi(k) = b(1) * ymod_phi(k); % high pass filter the signature
    for it=2:max(size(a))
        if (k-it+1) > 0
            ymodw_phi(k) = ymodw_phi(k) + b(it)*ymod_phi(k - it + 1) - a(it)*ymodw_phi(k - it + 1);
        end
    end
    eta_phi(k) = 2*ew(k)*ymodw_phi(k);
    
    ymod_a(k) = osc_i(k);
    ymodw_a(k) = b(1) * ymod_a(k); % high pass filter the signature
    for it=2:max(size(a))
        if (k-it+1) > 0
            ymodw_a(k) = ymodw_a(k) + b(it)*ymod_a(k - it + 1) - a(it)*ymodw_a(k - it + 1);
        end
    end
    eta_a(k) = 2*ew(k)*ymodw_a(k);
    
    % update estimates
    if (thetaa_est(k) + Ka * eta_a(k)) > 0
        thetaa_est(k+1) = thetaa_est(k) + Ka * eta_a(k);
    end
    if abs(thetadw_est(k) + Kdw * eta_phi(k)) < 4*2*pi/Fs
        thetadw_est(k+1) = thetadw_est(k) + Kdw * eta_phi(k);
    end
    thetaphi_est(k+1) = thetaphi_est(k) + Kphi * eta_phi(k) + thetadw_est(k);
    if abs(thetaa_est(k+1)) > eps
        alpha(k+1) = 1/thetaa_est(k+1);
    end

end

figure;plot(s,'k');title('original signal');
figure;plot(d','r');title('corrupt signal');
figure;plot(e,'b');title('filtered signal');

