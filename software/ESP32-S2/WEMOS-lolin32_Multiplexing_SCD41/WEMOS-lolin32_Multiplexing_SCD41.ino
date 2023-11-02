//Using WEMOS LOLIN32 Lite board
//Using Object Oriented Programing for easy understanding and modularity
//Port 19 (SDA) and 23 (SCL) are I2C ports
//Full schematics uploaded in the next link
//https://github.com/GenericLab/CO2-soil-respiration-chamber/blob/main/hardware/WEMOS-lolin32_Multiplexing_SCD41%20schematics/Lolin%20Multiplexing.png
//White cable for ground rail
//Black cable for 3.3V rail
//Orange cable for SCL rail, Red cable for multiplexed SCL
//Blue cable for SDA rail, Yellow cable for multiplexed SDA
//Green cable for Button terminal

#include <Arduino.h>
#include "SCD41_Multiplexed.h"
#include "SCD41_ThingSpeak.h"
#include "BMP280_AltitudeCalibrator.h"
#include "SerialAndScreenPrinter.h"

int SCD41CalibrationButton = 12;
unsigned long PressTimer;
bool CalibrationFlag;
SCD41_Multiplexed SCD41_M;
SCD41_ThingSpeak ThingSpeakLogger;
BMP280_AltitudeCalibrator BMPAltitude; 
SerialAndScreenPrinter Printer;

void SCD41ButtonPressed(){           //Function for changing the calibration status with a push of a bottom (Antibounce included, you'll need to press for 1 second)
  if(digitalRead(SCD41CalibrationButton) == false){
    PressTimer=millis();
    CalibrationFlag=true;
  }
  else{
    {
      CalibrationFlag=false;
    }
  }
  
}

void setup(){
  //Starts all modules and attach an interruption to the button
  PressTimer=0;
  Serial.begin(115200);
  Printer.Begin();
  SCD41_M.Begin();
  ThingSpeakLogger.Begin(30000);
  BMPAltitude.Begin();
  pinMode(SCD41CalibrationButton, INPUT_PULLUP);
  attachInterrupt(digitalPinToInterrupt(SCD41CalibrationButton), SCD41ButtonPressed, CHANGE);  
  CalibrationFlag=false;
}

void loop() {
  //Code section for checking if the button has been pressed for 5 seconds to ensure that the calibration is user triggered and not accidentally triggered
  if(CalibrationFlag){
    if(millis() - PressTimer >= 5000){
      SCD41_M.ButtonPressed();
    }
  }
  //Code section for checking is the user requested calibration and starting calibrations
  if(SCD41_M.CheckCalibration()){
    Printer.CalibrationStart();
    if(BMPAltitude.IsAvailable()){
      BMPAltitude.readAltitude();
      SCD41_M.CalibrationStart(uint16_t(BMPAltitude.getAltitude()));  //start calibration with BMP pressure data
    }
    else{
      SCD41_M.CalibrationStart();                                     //start calibration with default pressure data
    }
    Printer.CalibrationEnd();
  }

  if (SCD41_M.CheckTimer()){  
    //Code Section for Reading SCD41 and BMP280 Sensors
    BMPAltitude.readAltitude();
    for (uint8_t Port=0; Port<4; Port++) {
      SCD41_M.TCAselect(Port);
      SCD41_M.ReadSensor(Port);
    }
    //Code Section for Printing SCD41 and BMP280 data into Serial and SSD1306 Screen
    if(Printer.ScreenIsAvailable()){
      Printer.ToScreen(BMPAltitude.get_alldata(),SCD41_M.get_alldata());
    }
    Printer.ToSerial(BMPAltitude.get_alldata(),SCD41_M.get_alldata());
  }


  //Code Section for Sending SCD41 and BMP280 data to Thingspeak channel
  if(ThingSpeakLogger.CheckTimer()){
    /*for (uint8_t Port=0; Port<4; Port++) {
      ThingSpeakLogger.SetField(Port,SCD41_M.get_co2(Port));
    }*/ // This is for sending 4 CO2 data
    //This is for sending CO2, Temperature and Humidity
    for(int i=0;i<2;i++){
      ThingSpeakLogger.SetField(0,SCD41_M.get_co2(2*i));
      ThingSpeakLogger.SetField(1,SCD41_M.get_temperature(2*i));
      ThingSpeakLogger.SetField(2,SCD41_M.get_humidity(2*i));
      ThingSpeakLogger.SetField(3,SCD41_M.get_co2(2*i+1));
      ThingSpeakLogger.SetField(4,SCD41_M.get_temperature(2*i+1));
      ThingSpeakLogger.SetField(5,SCD41_M.get_humidity(2*i+1));
      ThingSpeakLogger.SetField(6,BMPAltitude.getAltitude());
      if(i==0){
        ThingSpeakLogger.ChannelSend(1);
      }
      else if(i==1){
        ThingSpeakLogger.ChannelSend(2);
      }
    }
    ThingSpeakLogger.RestartTimer();
  }
}


