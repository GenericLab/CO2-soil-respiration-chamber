#include <SensirionI2CScd4x.h>
#include <Arduino.h>


#define TCAADDR 0x70
#define SCD41 0x62
SensirionI2CScd4x scd4x;
unsigned long SCD41DataTimer;
unsigned long SCD41CalibrationTimer;
int SCD41CalibrationButton = 12;
uint16_t co2;
float temperature;
float humidity;
uint16_t error;
bool SCD41DataAvailable;
bool SCD41CalibrationIsOn;

void tcaselect(uint8_t Port) { //Function for configuration of TCA9548A multiplexer
  if (Port > 7) return;
  Wire.beginTransmission(TCAADDR);
  Wire.write(1 << Port);
  Wire.endTransmission();  
}

void setup(){
    SCD41DataTimer = 0;
    SCD41CalibrationTimer=0;
    SCD41CalibrationIsOn= false;
    pinMode(SCD41CalibrationButton, INPUT_PULLUP);
    attachInterrupt(digitalPinToInterrupt(SCD41CalibrationButton), SCD41ButtonPressed, FALLING);
    Wire.begin();
    Serial.begin(115200);
    scd4x.begin(Wire); //start the I2C configuration for SCD41
    for (uint8_t Port=0; Port<8; Port++) {
      tcaselect(Port);
      SCD41Init();
    }
}

void loop() {
  if(SCD41CalibrationIsOn == true){
    SCD41ForcedCalibration();
  }
  if (millis() - SCD41DataTimer >= 6000){
    SCD41DataTimer = millis();
    for (uint8_t Port=0; Port<8; Port++) {
      tcaselect(Port);
      SCD41read();
      SCD41toSerial(Port);
    }
  }
}

void SCD41read(){
  SCD41DataAvailable=false;
  char errorMessage[256];
  Wire.beginTransmission(SCD41);
  if (!Wire.endTransmission()){
    error = scd4x.readMeasurement(co2, temperature, humidity);
    SCD41DataAvailable=true;
  }
}

void SCD41toSerial(uint8_t Port){
  char errorMessage[256];
  if(!SCD41DataAvailable){
      return;
  }
  Serial.print("Reading SCD41 in port ");
  Serial.println(Port);
  if (error) {
      Serial.print("Error trying to execute readMeasurement(): ");
      errorToString(error, errorMessage, 256);
      Serial.println(errorMessage);
  }   else if (co2 == 0) {
        Serial.println("Invalid sample detected, skipping.");
  }   else {
      Serial.print("CO2: ");
      Serial.println(co2);
      Serial.print("Temperature: ");
      Serial.println(temperature);
      Serial.print("Humidity: ");
      Serial.println(humidity);
      Serial.println();
      Serial.println();
  }
}

void SCD41Init(){
  Wire.beginTransmission(SCD41);
  if (!Wire.endTransmission()){
    scd4x.stopPeriodicMeasurement();  //stop any measurement in progress
    scd4x.startPeriodicMeasurement(); //restart measurement
  }
}

void SCD41ForcedCalibration()
{
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
    Serial.println("Calibration is starting");
    delay(500); 
    char errorMessage[256];
    SCD41CalibrationTimer=millis();
    while ((millis() - SCD41CalibrationTimer < 180000) && SCD41CalibrationIsOn == true){}
    SCD41CalibrationIsOn = false;
    //calDisplay();
    
    uint16_t frc;
    uint16_t calPPM=400;

    for (uint8_t Port=0; Port<8; Port++) {
      tcaselect(Port);
      Wire.beginTransmission(SCD41);
      if (!Wire.endTransmission()){
        error = scd4x.stopPeriodicMeasurement();
        if (error) {
          Serial.print("Error trying to execute stopPeriodicMeasurement() in port ");
          Serial.println(Port);
          errorToString(error, errorMessage, 256);
          Serial.println(errorMessage);
        }
      }
    }
    delay(500);
    for (uint8_t Port=0; Port<8; Port++) {
      tcaselect(Port);
      Wire.beginTransmission(SCD41);
      if (!Wire.endTransmission()){
        error = scd4x.performForcedRecalibration(calPPM, frc);
        if (error) {
          Serial.print("Error trying: ");
          errorToString(error, errorMessage, 256);
          Serial.println(errorMessage);
        } else {
          Serial.print("Changed calibration by: ");
          Serial.println(frc-0x8000);
        }
      }
    }
    for (uint8_t Port=0; Port<8; Port++) {
      tcaselect(Port);
      Wire.beginTransmission(SCD41);
      if (!Wire.endTransmission()){
        error = scd4x.startPeriodicMeasurement();
        if (error) {
          Serial.print("Error trying to execute startPeriodicMeasurement(): ");
          errorToString(error, errorMessage, 256);
          Serial.println(errorMessage);
        }
      }
    }
    Serial.println("============= Starting Measurements ============");
    SCD41DataTimer = millis();
    //OLEDdrawBackground();
}

void SCD41ButtonPressed (){
  SCD41CalibrationIsOn=!SCD41CalibrationIsOn;
  }
