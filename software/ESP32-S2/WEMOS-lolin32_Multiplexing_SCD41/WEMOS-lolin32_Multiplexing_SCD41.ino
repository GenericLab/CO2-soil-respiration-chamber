//Using WEMOS LOLIN32 Lite board

#include <Arduino.h>
#include <SensirionI2CScd4x.h>
#include "SCD41_Multiplexed.h"
#include "SCD41_ThingSpeak.h"


int SCD41CalibrationButton = 12;
unsigned long BounceTimer;
SCD41_Multiplexed SCD41_M;
SCD41_ThingSpeak ThingSpeakLogger;

void SCD41ButtonPressed (){           //Function for changing the calibration status with a push of a bottom (Antibounce included)
  if(millis() - BounceTimer >= 500){
    SCD41_M.ButtonPressed();
    BounceTimer=0;
  }
}

void setup(){
  BounceTimer=0;
  Serial.begin(115200);
  SCD41_M.Begin();
  ThingSpeakLogger.Begin(20000);
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
      SCD41_M.ReadSensor(Port);
      SCD41_M.ToSerial(Port);
      ThingSpeakLogger.SetField(Port,SCD41_M.get_co2(Port));
    }
    while(!ThingSpeakLogger.CheckTimer()){}
    ThingSpeakLogger.ChannelSend();
  }
}


