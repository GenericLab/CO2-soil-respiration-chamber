#ifndef SCD41_ThingSpeak_h
#define SCD41_ThingSpeak_h

#include <WiFi.h>//If you use another board or have any problem with libraries include the library to ESP8266wifi.h instead of WiFi.h
#include <ThingSpeak.h>
#include "Secrets.h"

class SCD41_ThingSpeak{
public:
SCD41_ThingSpeak();
void Begin(unsigned long SendInterval);
void SetField(uint8_t Port,uint16_t Data);
void ChannelSend(int channel);
bool CheckTimer();
void RestartTimer();
private:
  unsigned long SendInterval=15000;
  unsigned long DataTimer;
  WiFiClient  client;
};

#endif

