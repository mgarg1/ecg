function [ Vout ] = bodymodel( t, Vref )
% This function simulates the body. 
% Arguments: (time in seconds, Value of Vref at the given time)
% Output: The voltage seen on one electrode with respect to circuit common

Ze1 = 10e6; % Impedance of the first electrode
Ze2 = 1e6; % Impedance of the reference electrode
Zs = 10e6; % Isolation impedance between 

lineAmp = 1; % 50 Hz inteference voltage on the body w.r.t earth ground
ecgAmp = 100e-6; % Amplitude of the ecg signal

Vout = ecgAmp * sin(2*pi*6*t) + lineAmp * Ze2 / (Zs + Ze2) * sin(2*pi*50*t) + Vref * Zs / (Zs + Ze2);


end

