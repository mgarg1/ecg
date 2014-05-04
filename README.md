Software Defined ECG
====================

This is a reasearch project that investigates the advantages of software defined ECG where in some parts of the analog circuitry are replaced by software. This project is still in the early stages of investigation and is not yet in a position to capture ECG signals.

What are the benefits of sofware defined ecg ?
----------------------------------------------

- Works for harmonics of 50/60 Hz (and maybe ~10 kHz interference from CFL too) without additional hardware.
- Can be rapidly prototyped (low NRE cost) making it especially useful for biomed, wearable computing researchers who dont want to make a custom chip
- Transistor scaling helps reduce cost in digital hardware as compared to analog hardware
- No need for precisely matched components (needed for high CMRR amplifiers)
- As new algorithms come out, software upgradation is easier compared to hardware change.
- Use of sub-threshold circuits might result lower power than possible with analog PLL.
- It could automatically detect the frequency of interference (50/60 Hz), thereby making it work across countries.

Dependencies
------------

- Python 2.7
- Arduino >= 1.5.6-r2 (for Arduino Due)
- stream-plot (source included, but streamplot's dependencies need to be met) - https://github.com/s-gv/stream-plot
- MATLAB / Octave if you want to run simulations
