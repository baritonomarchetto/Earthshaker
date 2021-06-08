// EARTHSHAKER PC-to-JAMMA interface
// Keyboard emulation and frequency check
//
// by Barito, 2021. 

#include <Keyboard.h>

#define INPUTS 14

const int HSyncPin = 4;
const int disablePin = 5;

const int delayTime = 20;
boolean startBlock = 0;
boolean enableState;
boolean prevEnState;

unsigned long periodoSum = 0;
unsigned long periodoIst = 0;
unsigned long periodoMedio=0;
int samplesm;
const int samples = 10;

struct digitalInput {const byte pin; boolean state; unsigned long dbTime; const byte key; const byte key_shift;} 
digitalInput[INPUTS] = {
{8, HIGH, 0, 49, 49},   //1         - P1_START (SHIFT BUTTON)
{9, HIGH, 0, 53, 53},   //5 (5)     - P1_COIN
{7, HIGH, 0, 97, 177},  //a (ESC)   - P1_UP
{6, HIGH, 0, 115, 189}, //s (Tilde) - P1_DOWN
{3, HIGH, 0, 100, 112}, //d (p)     - P1_LEFT 
{2, HIGH, 0, 113, 176}, //q (ENTER) - P1_RIGHT
{10, HIGH, 0, 119, 179},//w (TAB)   - P1_B1 
{16, HIGH, 0, 101, 54}, //e (6)     - P1_B2 
{14, HIGH, 0, 122, 120},//z (x)     - P1_B3 
{15, HIGH, 0, 102, 223},//f (+)     - P1_B4
{A0, HIGH, 0, 99, 99},  //c (c)     - P2_UP
{A1, HIGH, 0, 118, 118},//v (v)     - P2_DOWN
{A2, HIGH, 0, 98, 98},  //b (b)     - P2_LEFT
{A3, HIGH, 0, 110, 110} //n (n)     - P2_RIGHT
};

void setup(){
pinMode(HSyncPin, INPUT_PULLUP);
pinMode(disablePin, OUTPUT);
for (int j = 0; j < INPUTS; j++){
  pinMode(digitalInput[j].pin, INPUT_PULLUP);
  digitalInput[j].state = digitalRead(digitalInput[j].pin);
  digitalInput[j].dbTime = millis();
}
digitalWrite(disablePin, HIGH);
Keyboard.begin();
} // chiudo setup

void loop(){
generalInputs();
shiftInputs();
freqBlock();
}

void generalInputs(){
//general input handling
for (int j = 1; j < INPUTS; j++){
 if (millis()-digitalInput[j].dbTime > delayTime && digitalRead(digitalInput[j].pin) !=  digitalInput[j].state){
    digitalInput[j].state = !digitalInput[j].state;
    digitalInput[j].dbTime = millis();
    if(digitalInput[0].state == HIGH){ //shift button
      if (digitalInput[j].state == LOW){
        Keyboard.press(digitalInput[j].key);}
      else {Keyboard.release(digitalInput[j].key);}
    }
    else{
      if (digitalInput[j].state == LOW){
        startBlock = 1;
        Keyboard.press(digitalInput[j].key_shift);}
      else {Keyboard.release(digitalInput[j].key_shift);}
    }
  }
}
}

void shiftInputs(){ 
//reversed input handling (P1 START) - shift button
if (millis()-digitalInput[0].dbTime > delayTime && digitalRead(digitalInput[0].pin) !=  digitalInput[0].state){
    digitalInput[0].state = !digitalInput[0].state;
    digitalInput[0].dbTime = millis();
    if (digitalInput[0].state == HIGH && startBlock == 0){
      Keyboard.press(digitalInput[0].key);
      delay(30);
      Keyboard.release(digitalInput[0].key);
    }
    else{startBlock = 0;}
}
}

//31KHz  -> 32 us
//25KHz -> 40 us
//15KHz -> 66 us
void freqBlock(){
periodoSum = 0;  
samplesm = samples;
for(int i=0; i<samples; i++){
  periodoIst = pulseIn(HSyncPin,HIGH);
  if(periodoIst < 100 && periodoIst > 10){
    periodoSum += periodoIst;
  } 
  else {
    samplesm--;
  }
  periodoMedio = (periodoSum/samplesm)+5;
}
//Serial.println(periodoMedio);
if(periodoMedio > 55){enableState = 1;}
else {enableState = 0;}
if (enableState != prevEnState){
  prevEnState = enableState;
  digitalWrite(disablePin, !enableState);
}
}
