'''
Copyright (c) 2014 Sagar G V (sagar.writeme@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
'''

import serial
import streamplot
import time

# data (12 bits) - byte oriented - first LSB, then MSB
# 2 LSB bits - 00 - LSB 6 bits
#              01 - MSB 6 bits
#              10 - debug out - 6 bits

ser = serial.Serial('/dev/ttyUSB0', 115200, timeout=0)
ser.flushInput()
ser.flush()

ecgPlot = streamplot.StreamPlot(saveFileNameStart = "ecg_plot",lines = [('l','r','ecg')], exitforce=True)

Tsample = 1e-3 # in second
printdebug = True


def uartread():
    serbuf = ""
    data = 0
    debugdata = 0
    t = 0

    while True:
        serbuf += ser.read(100000)
        for c in serbuf:
            val = ord(c)
            value = val & 0x3F
            valtype = val / 64
            if valtype == 0: # LSB
                data = value
            elif valtype == 1: # MSB
                data = data + value*64
                t += Tsample
                yield (t, data)
            elif valtype == 2: # debug LSB
                debugdata = value
            elif valtype == 3: # debug MSB
                debugdata += value*64
                if printdebug:
                    print "Debug data from device: ", debugdata

        serbuf = ""

for i in uartread():
    t, val = i
    ecgPlot.addDataPoint(t, [val])
