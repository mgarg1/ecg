function [ Vout ] = dcamp( Vin )
% This function serves as a DC difference amplifier

G = 200;
VDD = 3.3;
Vref = VDD/2;

Vout = Vref + (Vin - Vref)*G;

Vout(Vout > VDD) = VDD; % clip at VDD
Vout(Vout <= 0) = 0; % clip at GND

end

