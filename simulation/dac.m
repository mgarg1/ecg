function [ Vout ] = dac( num )
% simulates a 10 bit DAC
% inputs integers between 0 through (2^bits - 1)
% outputs the voltage

bits = 10;
Vref = 3.3;

num = round(num); % in case non-integer was passed

num(num <= 0) = 0; % clipping at GND
num(num >= 2^bits) = 2^bits - 1; % clipping at VDD

Vout = Vref * num / 2^bits;

end

