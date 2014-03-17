import math
import math

Namp = 10 # number of amplitudes
Fgen = 50
Fsample = 1e3

Ns = int(Fsample/Fgen)

offset = 2048
max_amplitude = 2047

amps = [i*1.0/(Namp) for i in range(1,Namp+1)]

s = "int sine_arr[%s][%s] = {\n" % (Namp, Ns)

for amp in amps:
    s += "    {"
    for i in range(Ns):
        val = offset + int(round(max_amplitude * amp * math.sin(2*math.pi*i/Ns)))
        s += str(val)
        s += ','
    s = s[:-1]
    s += "},\n"

s = s[:-2]
s += "\n};"

print s
