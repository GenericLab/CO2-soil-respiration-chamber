#ifndef SCD41_Multiplexed_h
#define SCD41_Multiplexed_h

#include <Arduino.h>
#include <SensirionI2CScd4x.h>

namespace SCD41_Multiplexed_namespace{
  #define TCAADDR 0x70
  #define SCD41 0x62
}



class SCD41_Multiplexed{
public:
  SCD41_Multiplexed();
  void TCAselect(uint8_t Port);
  bool CheckTimer();
  bool CheckCalibration();
  void ReadSensor(uint8_t Port);
  void ToSerial(uint8_t Port);
  void Init();
  void ForcedCalibration();
  void SetAltitude();
  void CalibrationStart();
  void ButtonPressed();
  void Begin();
  uint16_t get_co2(uint8_t Port);
  float get_temperature(uint8_t Port);
  float get_humidity(uint8_t Port);
private:
  SensirionI2CScd4x scd4x;
  unsigned long DataTimer;
  unsigned long ReadInterval=20000;
  unsigned long CalibrationTimer;
  bool CalibrationIsOn;
  int CalibrationButton;
  bool DataAvailable;
  uint16_t error;
  uint16_t co2[8]={-1,-1,-1,-1,-1,-1,-1,-1};
  float temperature[8]={-1,-1,-1,-1,-1,-1,-1,-1};
  float humidity[8]={-1,-1,-1,-1,-1,-1,-1,-1};
  uint16_t Altitude=958; //Lujan de Cuyo altitude over the sea level
};
#endif








