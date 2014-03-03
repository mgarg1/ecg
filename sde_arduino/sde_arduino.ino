/*
Copyright (c) 2014 Sagar G V (sagar.writeme@gmail.com)

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

int led = 13; // orange LED
int rec;

void setup() {
  Serial1.begin(115200); // pin 18, 19 Serial 1 port.
  pinMode(led, OUTPUT); // initialize the digital pin as an output.
}

void loop() {
  while(Serial1.available() > 0) {
    rec = Serial1.read();
    if(rec == 'A') {
      Serial1.println("You pressed A.");
    }
    else if (rec == 'B') {
      Serial1.println("You Pressed B.");
    }
    else {
      Serial1.println("Unrecognized command.");
    }
  }
  Serial1.println("Toggling the LED ...");
  digitalWrite(led, HIGH);   // turn the LED on (HIGH is the voltage level)
  delay(500);               // wait
  digitalWrite(led, LOW);    // turn the LED off by making the voltage LOW
  delay(500);               // wait
}
