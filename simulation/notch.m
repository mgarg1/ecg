close all; clear all;

Fs = 1e3; % sample rate
fo = 50; % remove 50 Hz
BW = 2; %  3 dB bandwidth = 0.5 Hz 

Wo = fo/(Fs/2);
BWo = BW/(Fs/2);

[b, a] = iirnotch(Wo, BWo);
%fvtool(b,a);
%freqz(b,a);

N = 5000;
Ts = 1/Fs;

n = 0:(N-1);

sig = 0.001*sin(2*pi*6*Ts*n);
sig(N/2:end) = 0;
sig2 = 0.001*sin(2*pi*12*Ts*n);
sig2(1:N/2-1) = 0;
sig = sig + sig2;

%x = 0.001*sin(2*pi*6*Ts*n) + 0.1*sin(2*pi*50*Ts*n);
x = sig + 0.1*sin(2*pi*50*Ts*n);
plot(x);
y = filter(a-b, a, x);
figure;
plot(y,'r');
figure;
plot(x-y);