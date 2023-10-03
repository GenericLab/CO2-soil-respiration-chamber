#ifndef BMP280_AltitudeCalibrator_h
#define BMP280_AltitudeCalibrator_h
#include <Adafruit_BMP280.h>
#include "DataStructures.h"

namespace BMP280_Namespace{
  #define BMP280_ADDRESS 0x76
  #define SEA_LEVEL_PRESSURE 1010.0f    // sea level pressure 1013.25
}

class BMP280_AltitudeCalibrator{
public:
BMP280_AltitudeCalibrator();
void Begin();
void readAltitude();
float getAltitude();
void ToSerial();
bool IsAvailable();
BMP280_data get_alldata();

private:
Adafruit_BMP280 bmpSensor;
BMP280_data Data;
};

#endif