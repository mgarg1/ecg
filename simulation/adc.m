function [ adcout ] = adc( Vin )
% Simulates an ADC

Vref = 3.3; % reference voltage
bits = 10; % num of bits
noise = 10e-3; % rms noise in volts

volt_per_bit = Vref / 2^bits;

adcout = floor((Vin + noise * randn(size(Vin))) ./ volt_per_bit); % quantization

adcout(adcout >= 2^bits) = 2^bits - 1; % clipping at VDD
adcout(adcout <= 0) = 0; % clipping at ground

end

