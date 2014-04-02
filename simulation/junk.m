close all; clear all;

Ts = 1e-3; % sample rate
N = 1000; % Num of samples

n = 0:(N-1);

x = sin(2*pi*50*n*Ts + pi/2.2);

xf = fft(x);
axf = abs(xf);

pos = find(axf == max(axf));
pos = pos(1);

f = pos - 1;
phase = atan( abs(imag(xf(pos)) / real(xf(pos))) );
if real(xf(pos)) < 0
    phase = phase + pi;
end

xrep = cos(2*pi*(pos-1)*n / N - phase);
plot(x); hold on; plot(xrep, 'r');
