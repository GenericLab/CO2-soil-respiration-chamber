#include <SensirionI2CScd4x.h>
#include <Arduino.h>


#define TCAADDR 0x70
#define SCD41 0x62
SensirionI2CScd4x scd4x;
uint16_t co2;
float temperature;
float humidity;
uint16_t error;

void tcaselect(uint8_t Port) { //Function for configuration of TCA9548A multiplexer
  if (Port > 7) return;
 
  Wire.beginTransmission(TCAADDR);
  Wire.write(1 << Port);
  Wire.endTransmission();  
}

void setup()
{
    Wire.begin();
    Serial.begin(9600);
    scd4x.begin(Wire); //start the I2C configuration for SCD41
    for (uint8_t Port=0; Port<8; Port++) {
      tcaselect(Port);
      Wire.beginTransmission(SCD41);
        if (!Wire.endTransmission()){
          scd4x.stopPeriodicMeasurement();  //stop any measurement in progress
          scd4x.startPeriodicMeasurement(); //restart measurement
        }
    }
    
}

void loop() 
{
  char errorMessage[256];
  delay(5000);
    for (uint8_t Port=0; Port<8; Port++) {
      tcaselect(Port);
      Wire.beginTransmission(SCD41);
        if (!Wire.endTransmission()){
          Serial.print("Reading SCD41 in port ");
          Serial.println(Port);
          error = scd4x.readMeasurement(co2, temperature, humidity);
          if (error) {
          Serial.print("Error trying to execute readMeasurement(): ");
          errorToString(error, errorMessage, 256);
          Serial.println(errorMessage);
      } else if (co2 == 0) {
          Serial.println("Invalid sample detected, skipping.");
      } else {
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
}
