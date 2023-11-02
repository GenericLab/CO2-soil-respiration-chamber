#include "SCD41_ThingSpeak.h"

using namespace Network_Secrets;

SCD41_ThingSpeak::SCD41_ThingSpeak(){
}

void SCD41_ThingSpeak::Begin(unsigned long SendInterval){ //Function for starting up the WiFi and connection to ThingSpeak and configuring the data sending interval
  WiFi.mode(WIFI_STA);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println(".");
  ThingSpeak.begin(client);
  this->DataTimer=0;
  this->SendInterval=SendInterval;
}

void SCD41_ThingSpeak::SetField(uint8_t Port, uint16_t Data){   //Function for setting up a data field
  ThingSpeak.setField(Port+1, Data);
}

void SCD41_ThingSpeak::ChannelSend(int channel){                           //Function for sending all the data to the ThingSpeak channel
  int x;
  switch(channel){
    case 1:{
      x = ThingSpeak.writeFields(ChannelNumber1, WriteAPIKey1);
    break;}
    case 2:{
      x = ThingSpeak.writeFields(ChannelNumber2, WriteAPIKey2);
    break;}
    default:{
      x=200;}
  }
  if (x == 200) {
    Serial.println("Channel updated");
  }
  else {
    Serial.println("Trouble updating channel, HTTP error code " + String(x));
  }
}

bool SCD41_ThingSpeak::CheckTimer(){                            //Function for checking the send timer
  bool Timer = false;
  if (millis() - this->DataTimer >= this->SendInterval){
    Timer=true;
  }
  return Timer;
}

void SCD41_ThingSpeak::RestartTimer(){                          //Function for restarting the data timer
  this->DataTimer = millis();
}

