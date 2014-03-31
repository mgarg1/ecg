close all; clear all;
t = 0:0.1e-3:1;

x = 0 + 400*sin(2*pi*50*t);
y = zeros(size(x));
z = zeros(size(x));

ph = 0;
fc = 300; % range 300-360 for 45-55 Hz
pd_filt = 0;

for it=1:max(size(t))
   ph = mod(ph + fc, 2^16);
   if ph < 2^15
       y(it) = -1;
   else
       y(it) = 1;
   end
   pd_op = y(it) * x(it);
   a = 0.999;
   pd_filt = a*pd_filt + (1-a)*pd_op;
   
   if it > max(size(t))/2
       fc = 400;
   else
       fc = 200;
   end
   
   
end

plot(x,'r'); 
hold on; 
%plot(mean(x) + y * 0.25 * (max(x) - min(x)));
figure;
plot(y);