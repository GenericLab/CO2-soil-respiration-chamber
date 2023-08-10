#ifndef SCD41_ThingSpeak_h
#define SCD41_ThingSpeak_h

#include <WiFi.h>
#include <ThingSpeak.h>
#include "SCD41_Multiplexed.h"
#include "Secrets.h"

class SCD41_ThingSpeak{
public:
SCD41_ThingSpeak();
void Begin(unsigned long SendInterval);
void SetField(uint8_t Port,uint16_t Data);
void ChannelSend();
bool CheckTimer();
private:
  unsigned long SendInterval=20000;
  unsigned long DataTimer;
  WiFiClient  client;
};

#endif

