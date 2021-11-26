/* Copyright 2021 Manuel Pitz <manuel.pitz@eonerc.rwth-aachen.de>
** Copyright 2021 Niklas Eiling <niklas.eiling@eonerc.rwth-aachen.de>
** Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
** to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
** and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
** 
** The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
**
** THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
** FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER 
** LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS 
** IN THE SOFTWARE.
**
 */


#include <Wire.h>


int SDO = 10;
int CLK = 11;
int CONV = 12; 
uint16_t val = 0;
float vol;

void setup() {

  pinMode(SDO, INPUT);
  pinMode(CLK, OUTPUT);
  pinMode(CONV, OUTPUT);
  Serial.begin(9600);
  Wire.begin(); // join i2c bus (address optional for master)
  Wire.setClock(100000);

  digitalWrite(CONV, 0);
  digitalWrite(CLK, 1);

  /*//go to sleep
  digitalWrite(CONV, 0);
  delayMicroseconds(200);
  digitalWrite(CONV, 1);
  delayMicroseconds(200);
  digitalWrite(CONV, 0);
  delayMicroseconds(200);
  digitalWrite(CONV, 1);
  delayMicroseconds(200);
  digitalWrite(CONV, 0);
  delayMicroseconds(200);
  digitalWrite(CONV, 1);
  delayMicroseconds(200);
  digitalWrite(CONV, 0);
  delayMicroseconds(200);
  digitalWrite(CONV, 1);
  delayMicroseconds(200);
  //got to sleep end
  delayMicroseconds(500);

  //wake up
  digitalWrite(CLK, 0);
  delayMicroseconds(200);
  digitalWrite(CLK, 1);
  delayMicroseconds(100);

  //trigger conv
  digitalWrite(CONV, 1);
  delayMicroseconds(10);
  digitalWrite(CONV, 0);
  delayMicroseconds(10);

  
  for(int i=0;i<14;i++){
    
    digitalWrite(CLK, 0);
    delayMicroseconds(1); 
    digitalWrite(CLK, 10);
    //out |= (digitalRead(SDO))<<(13-i);
    delayMicroseconds(10); 
  }*/

}

void loop() {


  Serial.println("hello");
  Wire.beginTransmission(0x20);
  Wire.write(0x03);
  Wire.write(0);
  Wire.write(0x01);
  Wire.write(0xFF);
  int err = Wire.endTransmission();

  if (err != 0) {
    Serial.print("i2c error: ");
    Serial.println(err);
  }

  //trigger conv
  digitalWrite(CONV, 1);
  delayMicroseconds(100);
  digitalWrite(CONV, 0);
  delayMicroseconds(100);


  val = 0;
  for(int i=0;i<15;i++){
    
    digitalWrite(CLK, 0);
    delayMicroseconds(100); 
    digitalWrite(CLK, 1);
    delayMicroseconds(100);
    val |= (digitalRead(SDO))<<(13-i);
    delayMicroseconds(100);  
  }
  vol = float(val) / 4000;
  //uint16_t test = 16384;
  Serial.print(val);
  Serial.print(" --> ");
  Serial.print(vol,5);
  Serial.println("V");

  delay(1000);  
}
