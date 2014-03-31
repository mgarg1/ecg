t = 0:0.001:0.5;
%plot(adc(bodymodel(t, 1.5)));
%plot(adc(1.5 + 1*sin(2*pi*10*t)));
%plot(attenuator(1.6 + 1*sin(2*pi*10*t)));
%plot(dcamp(1.65 + 0.001*sin(2*pi*10*t)));
%plot(adc(dcamp(1.65 + 0.005*sin(2*pi*10*t))));

plot(adc(dcamp(attenuator(dac(512 + 10*sin(2*pi*6*t))))));