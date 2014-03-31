function [ Vout ] = dac( num )
% simulates a 10 bit DAC
% inputs integers between 0 through (2^bits - 1)
% outputs the voltage

bits = 10;
Vref = 3.3;

num = round(num); % in case non-integer was passed
if num <= 0
    num = 0;
elseif num >= 2^bits
    num = 2^bits - 1;
end

Vout = Vref * num / 2^bits;

end

