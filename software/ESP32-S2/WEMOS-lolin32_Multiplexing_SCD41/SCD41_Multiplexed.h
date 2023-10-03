#ifndef SCD41_Multiplexed_h
#define SCD41_Multiplexed_h

#include <Arduino.h>
#include <SensirionI2CScd4x.h>
#include "DataStructures.h"

namespace SCD41_Multiplexed_namespace{
  #define TCAADDR 0x70
  #define SCD41 0x62
  #define LujanDeCuyoAltitude 958
}

class SCD41_Multiplexed{
public:
  SCD41_Multiplexed();
  void TCAselect(uint8_t Port);
  bool CheckTimer();
  bool CheckCalibration();
  void ReadSensor(uint8_t Port);
  void ToSerial(uint8_t Port);
  void Init(uint8_t Port);
  void ForcedCalibration();
  void SetAltitude(uint16_t Altitude);
  void CalibrationStart();
  void CalibrationStart(uint16_t Altitude);
  void ButtonPressed();
  void Begin();
  uint16_t get_co2(uint8_t Port);
  float get_temperature(uint8_t Port);
  float get_humidity(uint8_t Port);
  SCD41_data get_alldata();
  
private:
  SensirionI2CScd4x scd4x;
  unsigned long DataTimer;
  unsigned long ReadInterval=6000;
  unsigned long CalibrationTimer;
  bool CalibrationIsOn;
  int CalibrationButton;
  uint16_t error;
  uint16_t Altitude=958; //Lujan de Cuyo altitude over the sea level
  SCD41_data Data;
};
#endif








