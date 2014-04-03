clear all; close all;

N = 2000;
Ts = 1e-3;

n = 0:(N-1);

x = 5*sin(2*pi*20*Ts*n) + 10*sin(2*pi*49.95*n*Ts);

r1 = cos(2*pi*50*n*Ts);
r2 = sin(2*pi*50*n*Ts);

xr1 = x .* r1;
xr2 = x .* r2;

figure; plot(xr1);hold on; plot(xr2, 'r');

[b, a] = butter(4, 5*(Ts*2)); % order at 5 Hz

xr1f = filter(b, a, xr1);
xr2f = filter(b, a, xr2);

figure; plot(xr1f);hold on; plot(xr2f, 'r');plot(xr2f.^2 + xr1f.^2, 'k');plot(atan(xr2f./xr1f), 'g');
taninv = atan(xr2f./xr1f);
taninv = taninv(800:end);

