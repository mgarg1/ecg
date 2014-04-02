close all; clear all;

Ts = 100e-6; % sample rate
N = 10000;

n = 0:(N-1);
x = cos(2*pi*50.02*n*Ts);

coeffs = 47:0.1:53;
Ncoeffs = max(size(coeffs));

cos_coeffs = zeros(Ncoeffs, 1);
sin_coeffs = zeros(Ncoeffs, 1);

for it=n
    for coeffit = 1:Ncoeffs
        cos_coeffs(coeffit) = cos_coeffs(coeffit) + (x(it + 1) * cos(2*pi*coeffs(coeffit)*it*Ts));
        sin_coeffs(coeffit) = sin_coeffs(coeffit) + (x(it + 1) * sin(2*pi*coeffs(coeffit)*it*Ts));
    end
end

if max(abs(cos_coeffs)) > max(abs(sin_coeffs))
    pref_coeffs = abs(cos_coeffs);
else
    pref_coeffs = abs(sin_coeffs);
end
pos = find(pref_coeffs == max(pref_coeffs));

freq = coeffs(pos);

re = cos_coeffs(pos);
im = sin_coeffs(pos);
phase = atan(im/re);
if re < 0
    phase = phase + pi;
end

xrep = cos(2*pi*freq*n / N - phase);
plot(x); hold on; plot(xrep, 'r'); figure; plot(x - xrep);
