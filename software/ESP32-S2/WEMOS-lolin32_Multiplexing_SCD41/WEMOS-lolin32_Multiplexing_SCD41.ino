#include <SensirionI2CScd4x.h>
#include <Arduino.h>


#define TCAADDR 0x70
SensirionI2CScd4x scd4x;
uint16_t co2;
float temperature;
float humidity;
uint16_t error;

void tcaselect(uint8_t i) { //Function for configuration of TCA9548A multiplexer
  if (i > 7) return;
 
  Wire.beginTransmission(TCAADDR);
  Wire.write(1 << i);
  Wire.endTransmission();  
}

void setup()
{
    Wire.begin();
    Serial.begin(9600);
    scd4x.begin(Wire); //start the I2C configuration for SCD41
    for (uint8_t t=0; t<8; t++) {
      tcaselect(t);
      Wire.beginTransmission(SCD41);
        if (!Wire.endTransmission()){
          scd4x.stopPeriodicMeasurement();  //stop any measurement in progress
          scd4x.startPeriodicMeasurement(); //restart measurement
        }
    }
    
}

void loop() 
{
  delay(5000);
    for (uint8_t t=0; t<8; t++) {
      tcaselect(t);
      Wire.beginTransmission(SCD41);
        if (!Wire.endTransmission()){
          Serial.print("Reading SCD41 in port ");
          Serial.println(t);
          error = scd4x.readMeasurement(co2, temperature, humidity);
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
}

