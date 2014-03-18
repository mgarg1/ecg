/*
Copyright (c) 2014 Sagar G V (sagar.writeme@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

#include "DueTimer.h"


int led = 13; // orange LED
int analogInPin = 8; // analog Pin A8
int analogOutPin = DAC0; // analog Pin DAC

int val, i;

int amp = 0;
int phase = 0;
extern int sine_arr[10][20];

void dumpval(unsigned int val) {
    unsigned char lsb = val & 0x3F; // lower 6 bits
    unsigned char msb = (val >> 6) & 0x3F; // upper 6 bits
    msb |= 0x40; // msb encoding
    Serial1.write(lsb);
    Serial1.write(msb);
}

void debugdump(unsigned int val) {
    unsigned char lsb = val & 0x3F; // lower 6 bits
    lsb |= 0x80; // lsb encoding
    unsigned char msb = (val >> 6) & 0x3F; // upper 6 bits
    msb |= 0xC0; // msb encoding
    Serial1.write(lsb);
    Serial1.write(msb);
}

void timerHandler() {
  val = analogRead(analogInPin);
  dumpval(val);
  // saw tooth wave
  int key = Serial1.read();
  if(key == '1') {
    if(amp < 9)
      amp++;
  }
  if(key == '2') {
    if(amp > 0)
      amp--;
  }
  if(key == '3') {
    i++; // increase phase
  }
  if(key == '4') {
    if(i==0)
      i = 19;
    else
      i--;
  }
  i++;
  i = i % 20;
  
  analogWrite(analogOutPin, sine_arr[amp][i]);
}

void setup() {
  Serial1.begin(115200);
  pinMode(led, OUTPUT); // initialize the digital pin as an output.
  Timer.getAvailable().attachInterrupt(timerHandler).start(1000); // call timerHandler once in 1000 us
  analogWriteResolution(12);
  analogWrite(analogOutPin, 2048);
  analogWrite(DAC1, 2048);
  
  debugdump(4095); // reset plot on the visualizer
}

void loop() {
}
