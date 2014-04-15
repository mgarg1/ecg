clear all; close all;

Ts = 1e-3;
N = 20000;

t = (1:N)' .* Ts;

x = cos(2*pi*49*t); % interference

[b, a] = butter(2, 10 * (2*Ts));

phi_init = 2*pi*50*Ts;
phi = 0;

y = zeros(N,1); % output of loop low-pass filter
pd = zeros(N,1); % o/p of multiplier
tmp = zeros(N,1);
xr = zeros(N,1);

loop_gain = 0.08;

for it=1:N
    xr(it) = cos(phi_init*(it + phi));
    pd(it) = xr(it) * x(it) * loop_gain;
    
    for ind=1:max(size(b))
        if (it - ind + 1) >= 1
            y(it) = y(it) + b(ind) * pd(it - ind + 1);
        end
    end
    for ind=2:max(size(a))
        if (it - ind + 1) >= 1
            y(it) = y(it) - a(ind) * y(it - ind + 1);
        end
    end
    if it > 500 % give some time for the filter to settle
        phi = phi - y(it);
    end
end

plot(y);