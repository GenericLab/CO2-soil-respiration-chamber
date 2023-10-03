#include "SerialAndScreenPrinter.h"

using namespace SSD1306_Namespace;

SerialAndScreenPrinter::SerialAndScreenPrinter() : Screen(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1){          //initialize the screen in constructor
}

void SerialAndScreenPrinter::Begin(){
  if(!this->Screen.begin(SSD1306_SWITCHCAPVCC, SSD1306_ADDRESS)) {
    this->Available=false;
  }
  else{
    this->Available=true;
    this->Screen.setTextSize(1);
    this->Screen.setTextColor(WHITE);
    this->Screen.clearDisplay();
    Screen.println("Sensors starting up, please wait");
    Screen.display();              //Necesary to update the display
  }
  Serial.println("Sensors starting up, please wait");
  delay(2000);
}

bool SerialAndScreenPrinter::ScreenIsAvailable(){
  return this->Available;
}

void SerialAndScreenPrinter::ToScreen(BMP280_data PressureData, SCD41_data CO2SensorData){
  this->Screen.clearDisplay();
  Screen.setCursor(0, 0);
  this->Screen.println("Port CO2 Alt Tmp Hum"); 
  for(int Port=-1;Port<4;Port++){
    if(Port==-1 && PressureData.Available){
      Screen.print("BMP");
      if(uint16_t(PressureData.Altitude)>=1000){
        Screen.print("   - ");
      }
      else {
        Screen.print("   -  ");
      }
      Screen.print(uint16_t(PressureData.Altitude));
      Screen.println("  -   -");
    }
    else if(Port==-1 && !PressureData.Available){
      Screen.println("BMP   -   -   -   -");
    }
    else if(!CO2SensorData.Availability[Port]){
      Screen.print(" ");
      Screen.print(Port+1);
      Screen.println("    -   -   -   -");
    }
    else {
      Screen.print(" ");
      Screen.print(Port+1);       //The +1 is for skipping port 0
      if(CO2SensorData.co2[Port]>=1000){
        Screen.print("  ");
      }
      else {
        Screen.print("   ");
      }
      Screen.print(uint16_t(CO2SensorData.co2[Port]));
      Screen.print(" ");
      Screen.print(uint16_t(CO2SensorData.Altitude[Port]));
      Screen.print("  ");
      Screen.print(uint16_t(CO2SensorData.temperature[Port]));
      Screen.print("  ");
      Screen.println(int(CO2SensorData.humidity[Port]));
    }
  } 
  Screen.display();
}

void SerialAndScreenPrinter::ToSerial(BMP280_data PressureData, SCD41_data CO2SensorData){
  Serial.println("Port CO2 Alt Tmp Hum");
  for(int Port=-1;Port<4;Port++){
    if(Port==-1 && PressureData.Available){
      Serial.print("BMP");
      if(uint16_t(PressureData.Altitude)>=1000){
        Serial.print("   - ");
      }
      else {
        Serial.print("   -  ");
      }
      Serial.print(uint16_t(PressureData.Altitude));
      Serial.println("  -   -");
    }
    else if(Port==-1 && !PressureData.Available){
      Serial.print("BMP   -   -   -   -");
      Serial.print("");
      Serial.println("");
    }
    else if(!CO2SensorData.Availability[Port]){
      Serial.print(" ");
      Serial.print(Port+1);
      Serial.println("    -   -   -   -");
    }
    else {
      Serial.print(" ");
      Serial.print(Port+1);           //The +1 is for skipping port 0
      if(CO2SensorData.co2[Port]>=1000){
        Serial.print("  ");
      }
      else {
        Serial.print("   ");
      }
      Serial.print(uint16_t(CO2SensorData.co2[Port]));
      Serial.print(" ");
      Serial.print(uint16_t(CO2SensorData.Altitude[Port]));
      Serial.print("  ");
      Serial.print(uint16_t(CO2SensorData.temperature[Port]));
      Serial.print("  ");
      Serial.println(uint16_t(CO2SensorData.humidity[Port]));
    }
  }
}

void SerialAndScreenPrinter::CalibrationStart(){
  this->Screen.clearDisplay();
  Screen.setCursor(0, 0);
  Screen.println("Calibrating CO2      sensors");
  Screen.display();
}

void SerialAndScreenPrinter::CalibrationEnd(){
  this->Screen.clearDisplay();
  Screen.setCursor(0, 0);
  Screen.println("Starting Measurements");
  Screen.display();
}