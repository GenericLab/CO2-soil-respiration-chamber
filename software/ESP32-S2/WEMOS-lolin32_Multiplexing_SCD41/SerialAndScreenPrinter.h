#ifndef SerialAndScreenPrinter_h
#define SerialAndScreenPrinter_h
#include <Adafruit_SSD1306.h>
#include "DataStructures.h"

namespace SSD1306_Namespace{
  #define SCREEN_WIDTH 128 // OLED display width, in pixels
  #define SCREEN_HEIGHT 64 // OLED display height, in pixels
  #define SSD1306_ADDRESS 0x3C
}

class SerialAndScreenPrinter{
public:
SerialAndScreenPrinter();
void Begin();
void ToSerial(BMP280_data PressureData, SCD41_data CO2SensorData);
void ToScreen(BMP280_data PressureData, SCD41_data CO2SensorData);
bool ScreenIsAvailable();
void CalibrationStart();
void CalibrationEnd();

private:
Adafruit_SSD1306 Screen;
bool Available;
};

#endif