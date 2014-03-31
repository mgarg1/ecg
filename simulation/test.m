t = 0:0.001:0.8;
%plot(adc(bodymodel(t, 1.5)));
plot(adc(1.5 + 0.5*sin(2*pi*10*t)));