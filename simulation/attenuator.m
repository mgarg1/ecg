function [ Vout ] = attenuator( Vin )
% Attenuates Vin and gives Vout

VDD = 3.3;
R1 = 1e3;
R2 = 10e3;

Vout = VDD / 2 + (Vin - VDD / 2) * R1 / (R1 + R2);

end

