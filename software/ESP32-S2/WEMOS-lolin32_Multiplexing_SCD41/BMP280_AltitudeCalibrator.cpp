#include "BMP280_AltitudeCalibrator.h"

using namespace BMP280_Namespace;

BMP280_AltitudeCalibrator::BMP280_AltitudeCalibrator(){
}

void BMP280_AltitudeCalibrator::Begin(){
  unsigned status;
  status=this->bmpSensor.begin(BMP280_ADDRESS);
  if(!status){
    this->Data.Available=false;
  }
  else{
    this->bmpSensor.setSampling(Adafruit_BMP280::MODE_NORMAL,         /* Operating Mode. */
                    Adafruit_BMP280::SAMPLING_X2,                   /* Temp. oversampling */
                    Adafruit_BMP280::SAMPLING_X16,                  /* Pressure oversampling */
                    Adafruit_BMP280::FILTER_X16,                    /* Filtering. */
                    Adafruit_BMP280::STANDBY_MS_500);               /* Standby time. */
  
    this->Data.Available=true;
  }
  this->Data.Altitude=-9999999999;
}

void BMP280_AltitudeCalibrator::readAltitude(){
  if(this->Data.Available){
    this->Data.Altitude=this->bmpSensor.readAltitude(SEA_LEVEL_PRESSURE);
  }
}

float BMP280_AltitudeCalibrator::getAltitude(){
  return this->Data.Altitude;
}

void BMP280_AltitudeCalibrator::ToSerial(){
  if(this->Data.Available){
    Serial.print("Altitude: ");
    Serial.println(this->Data.Altitude);
  }
  else{
    Serial.println("BMP280 not available");
  }
}

bool BMP280_AltitudeCalibrator::IsAvailable(){
  return this->Data.Available;
}

BMP280_data BMP280_AltitudeCalibrator::get_alldata(){
  return this->Data;
}

