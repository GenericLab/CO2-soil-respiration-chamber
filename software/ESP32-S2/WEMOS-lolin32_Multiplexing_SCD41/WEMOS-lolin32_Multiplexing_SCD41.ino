#include <Arduino.h>
#include <SensirionI2CScd4x.h>
#include "SCD41_Multiplexed.h"

int SCD41CalibrationButton = 12;

SCD41_Multiplexed SCD41_M;

void SCD41ButtonPressed (){
  SCD41_M.ButtonPressed();
}

void setup(){
  Serial.begin(115200);
  SCD41_M.Begin();
  pinMode(SCD41CalibrationButton, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(SCD41CalibrationButton), SCD41ButtonPressed, FALLING);
}

void loop() {
  if(SCD41_M.CheckCalibration()){
    SCD41_M.CalibrationStart();
  }
  if (SCD41_M.CheckTimer()){
    for (uint8_t Port=0; Port<8; Port++) {
      SCD41_M.TCAselect(Port);
      SCD41_M.ReadSensor();
      SCD41_M.ToSerial(Port);
    }
  }
}


