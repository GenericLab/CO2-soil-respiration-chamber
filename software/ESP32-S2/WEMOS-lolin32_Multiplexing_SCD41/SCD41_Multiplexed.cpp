#include "SCD41_Multiplexed.h"
using namespace SCD41_Multiplexed_namespace;

SCD41_Multiplexed::SCD41_Multiplexed(){
}

void SCD41_Multiplexed::Begin(){ //Function for starting periodic meassurements on all 4 SCD41 sensors
  this->CalibrationTimer=0;
  this->CalibrationIsOn= false;
  Wire.begin();
  this->scd4x.begin(Wire); //start the I2C configuration for SCD41
  for (uint8_t Port=0; Port<4; Port++) {
    TCAselect(Port);
    this->Init(Port);
    this->Data.Altitude[Port]=this->scd4x.getSensorAltitude(this->Data.Altitude[Port]);
  }
  this->DataTimer=millis();
}

void SCD41_Multiplexed::TCAselect(uint8_t Port) { //Function for configuration of TCA9548A multiplexer
  if (Port+1 > 4) return;                         //The +1 is used because port 0 is skipped
  Wire.beginTransmission(TCAADDR);
  Wire.write(1 << Port+1);
  Wire.endTransmission();  
}

bool SCD41_Multiplexed::CheckTimer(){             //Funtion for checking the reading timer
  bool Timer = false;
  if (millis() - this->DataTimer >= this->ReadInterval){
    Timer=true;
    this->DataTimer = millis();
  }
  return Timer;
}

void SCD41_Multiplexed::ReadSensor(uint8_t Port){         //function for reading individual SCD41 sensors
  char errorMessage[256];
  Wire.beginTransmission(SCD41);
  if (!Wire.endTransmission()){
    this->error = this->scd4x.readMeasurement(this->Data.co2[Port], this->Data.temperature[Port], this->Data.humidity[Port]);
  }
}

void SCD41_Multiplexed::ToSerial(uint8_t Port){         //Function for printing SCD41 data to the serial port (currently not used)
    char errorMessage[256];
  if(!this->Data.Availability[Port]){
    Serial.print("SCD41 not available in port ");
    Serial.println(Port);
    return;
  }
  Serial.print("SCD41 Port ");
  Serial.println(Port);
  if (this->error) {
      Serial.print("Error trying to execute readMeasurement(): ");
      errorToString(this->error, errorMessage, 256);
      Serial.println(errorMessage);
  }   else if (this->Data.co2[Port] == 0) {
        Serial.println("Invalid sample detected, skipping.");
  }   else {
      Serial.print("CO2: ");
      Serial.print(this->Data.co2[Port]);
      Serial.print(" Temperature: ");
      Serial.print(this->Data.temperature[Port]);
      Serial.print(" Humidity: ");
      Serial.print(this->Data.humidity[Port]);
      Serial.println();
  }
}

void SCD41_Multiplexed::Init(uint8_t Port){             //Function for starting individual SCD41 sensor
  Wire.beginTransmission(SCD41);
  if (!Wire.endTransmission()){
    this->scd4x.stopPeriodicMeasurement();  //stop any measurement in progress
    this->scd4x.startPeriodicMeasurement(); //restart measurement
    this->Data.Availability[Port]=true;
  }
}

void SCD41_Multiplexed::ForcedCalibration(){    //Function for calibrating CO2 meassurement on all 4 sensors
    // Force Calibration **************************************

   /**
     * performForcedRecalibration() - To successfully conduct an accurate forced
    recalibration, the following steps need to be carried out:
    1. Operate the SCD4x in a periodic measurement mode for > 3 minutes in an
    environment with homogenous and constant CO₂ concentration.
    2. Stop periodic measurement. Wait 500 ms.
    3. Subsequently issue the perform_forced_recalibration command and
    optionally read out the baseline correction. A return value of 0xffff
    indicates that the forced recalibration failed.
     *
     * @param targetCo2Concentration Target CO₂ concentration in ppm.
     *
     * @param frcCorrection FRC correction value in CO₂ ppm or 0xFFFF if the
    command failed. Convert value to CO₂ ppm with: value - 0x8000
     *
     * @return 0 on success, an error code otherwise
     */
    Serial.println("CO2 calibration is starting");
    delay(500); 
    char errorMessage[256];
    this->CalibrationTimer=millis();
    while ((millis() - this->CalibrationTimer < 180000) && this->CalibrationIsOn == true){}
    this->CalibrationIsOn = false;
    
    uint16_t frc;
    uint16_t calPPM=400;

    for (uint8_t Port=0; Port<4; Port++) {
      this->TCAselect(Port);
      Wire.beginTransmission(SCD41);
      if (!Wire.endTransmission()){
        this->error = scd4x.stopPeriodicMeasurement();
        if (error) {
          Serial.print("Error trying to execute stopPeriodicMeasurement() in port ");
          Serial.println(Port);
          errorToString(this->error, errorMessage, 256);
          Serial.println(errorMessage);
        }
      }
    }
    delay(500);
    for (uint8_t Port=0; Port<4; Port++) {
      TCAselect(Port);
      Wire.beginTransmission(SCD41);
      if (!Wire.endTransmission()){
        error = scd4x.performForcedRecalibration(calPPM, frc);
        if (error) {
          Serial.print("Error trying: ");
          errorToString(this->error, errorMessage, 256);
          Serial.println(errorMessage);
        } else {
          Serial.print("Changed calibration by: ");
          Serial.println(frc-0x8000);
        }
      }
      this->Data.Altitude[Port]=this->scd4x.getSensorAltitude(this->Data.Altitude[Port]);
    }
    for (uint8_t Port=0; Port<4; Port++) {
      TCAselect(Port);
      Wire.beginTransmission(SCD41);
      if (!Wire.endTransmission()){
        this->error = scd4x.startPeriodicMeasurement();
        if (this->error) {
          Serial.print("Error trying to execute startPeriodicMeasurement(): ");
          errorToString(this->error, errorMessage, 256);
          Serial.println(errorMessage);
        }
      }
    }
    Serial.println("============= Starting Measurements ============");
    this->DataTimer = millis();
}

void SCD41_Multiplexed::SetAltitude(uint16_t Altitude){      //Function for setting altitude on the SCD41 sensors
    char errorMessage[256];
  for (uint8_t Port=0; Port<4; Port++) {
      TCAselect(Port);
      Wire.beginTransmission(SCD41);
      if (!Wire.endTransmission()){
        error = this->scd4x.stopPeriodicMeasurement();
        error = this->scd4x.setSensorAltitude(Altitude);
        if (error) {
          Serial.print("Error trying to execute setSensorAltitude: ");
          errorToString(this->error, errorMessage, 256);
          Serial.println(errorMessage);
        }
        Serial.print("In port ");
        Serial.print(Port);
        Serial.print(", altitude is set to ");
        Serial.println(Altitude);
        this->error = scd4x.startPeriodicMeasurement();
      }
      this->Data.Altitude[Port]=this->scd4x.getSensorAltitude(this->Data.Altitude[Port]);
    }
    this->DataTimer = millis();
}
void SCD41_Multiplexed::CalibrationStart(){     //Function for starting calibration with default data
  this->SetAltitude(LujanDeCuyoAltitude);
  this->ForcedCalibration();
}

void SCD41_Multiplexed::CalibrationStart(uint16_t Altitude){     //Function for starting calibration with BMP280 or other pressure data
  this->SetAltitude(Altitude);
  this->ForcedCalibration();
}

void SCD41_Multiplexed::ButtonPressed(){        //Function for toogling the calibration button status, must be connected to a interruption in the .ino file
  this->CalibrationIsOn=!this->CalibrationIsOn;
}

bool SCD41_Multiplexed::CheckCalibration(){     //Function for checking if the calibration mode is active
  return this->CalibrationIsOn;
}
uint16_t SCD41_Multiplexed::get_co2(uint8_t Port){  //Function for getting the CO2 meassurement
  return this->Data.co2[Port];
}
float SCD41_Multiplexed::get_temperature(uint8_t Port){   //Function for getting the temperature meassurement
  return this->Data.temperature[Port];
}
float SCD41_Multiplexed::get_humidity(uint8_t Port){      //Function for getting the humidity meassurement
  return this->Data.humidity[Port];
}
SCD41_data SCD41_Multiplexed::get_alldata(){              //Function for getting CO2, Altitude, Temperature, Humidity and Pressure data of all 4 SCD41 sensors
  return Data;
}