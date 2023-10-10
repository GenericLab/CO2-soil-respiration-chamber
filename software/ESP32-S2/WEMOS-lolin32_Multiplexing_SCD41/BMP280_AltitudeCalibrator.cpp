#include "BMP280_AltitudeCalibrator.h"

using namespace BMP280_Namespace;

BMP280_AltitudeCalibrator::BMP280_AltitudeCalibrator(){
}

void BMP280_AltitudeCalibrator::Begin(){              //Function for starting meassurements
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

void BMP280_AltitudeCalibrator::readAltitude(){                 //Function for reading altitude sensor
  if(this->Data.Available){
    this->Data.Altitude=this->bmpSensor.readAltitude(SEA_LEVEL_PRESSURE);
  }
}

float BMP280_AltitudeCalibrator::getAltitude(){                 //Function for returning the altitude
  return this->Data.Altitude;
}

void BMP280_AltitudeCalibrator::ToSerial(){                     //Function for printing the altitude (Currently not used)
  if(this->Data.Available){
    Serial.print("Altitude: ");
    Serial.println(this->Data.Altitude);
  }
  else{
    Serial.println("BMP280 not available");
  }
}

bool BMP280_AltitudeCalibrator::IsAvailable(){                  //Returns whether the sensor is available or not 
  return this->Data.Available;
}

BMP280_data BMP280_AltitudeCalibrator::get_alldata(){           //Returns pressure and availability of sensor
  return this->Data;
}

