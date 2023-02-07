/*
 * dusjagr edited some stuffs...
 * Adding display
 * Adding timer
 * Adding BMP280 pressure sensor
 * Adding Neo-Pixel on pin 18
 * Adding Dallas Temperature sensor for external use of soil temperature probe
 * different version of OneWireNG had to be used to compile correctly on ESP32 S2
 * Not finished: proper calibration routine
 * Added FeatherS3
 * Added option for OTA upload
 */


//#define FEATHERS2
#define FEATHERS3
//#define WEMOS_LOLIN32

#define SCD41_IS_ATTACHED
//#define BMP_IS_ATTACHED
#define DS18x20_IS_ATTACHED
//#define USE_THINGSPEAK
//#define USE_OTA

#include <Arduino.h>
#include <SensirionI2CScd4x.h>
#include <Wire.h>
#include <Adafruit_NeoPixel.h>
#include "OLED_stuff.h"
#include "driver/adc.h"

#ifdef USE_THINGSPEAK
  #include "/home/dusjagr/secrets.h"
#endif

#ifdef USE_OTA
  #include <WiFi.h>
  #include <ESPmDNS.h>
  #include <WiFiUdp.h>
  #include <ArduinoOTA.h>
#endif

const int analogInPin = 5;  // Analog input pin that the potentiometer is attached to
uint32_t ADCValue = 0;        // value read from the pot
uint32_t voltage = 0;
uint32_t batAveraging = 500; //what is the maximum??
int batCounter = 0;          // to count to the maximum averaging
float battery = 0;           // averaged value of voltage

char OTA_name[] = "ROSA-Anwand65";

#ifdef FEATHERS2
const int LEDonBoard = 13;       // the number of the LED pin
//const int LEDexternal = 33;      // the number of the LED pin
const int LEDexternal = 21;      // 2nd LDO on GPIO21
const int buttonPin = 38;        // the number of the pushbutton pin
const int cal_pin = 0;           // entrada pulsador calibración
const int neoPixelPin = 7;          // NeoPixel for UROS board
#define SDA_PIN 13
#define SCL_PIN 14
#endif

#ifdef FEATHERS3
const int LEDonBoard = 13;       // the number of the LED pin
//const int LEDexternal = 33;      // the number of the LED pin
const int LEDexternal = 10;      // 2nd LDO on GPIO21
const int buttonPin = 11;        // the number of the pushbutton pin
const int cal_pin = 0;           // entrada pulsador calibración
const int neoPixelPin = 40;          // NeoPixel for UROS board
#define SDA_PIN 9
#define SCL_PIN 8
#endif

#ifdef WEMOS_LOLIN32 // LITE
const int LEDonBoard = 21;       // the number of the LED pin
const int LEDexternal = 2;      // the number of the LED pin
const int buttonPin = 14;        // the number of the pushbutton pin
const int cal_pin = 12;           // entrada pulsador calibración
const int neoPixelPin = 2;          // NeoPixel for UROS board
#define SDA_PIN 5
#define SCL_PIN 18
#endif

int ledState = LOW;              // ledState used to set the LED
int buttonState = HIGH;          // the current reading from the input pin
int lastButtonState = HIGH;      // the previous reading from the input pin
int screenState = 0;             // different views on the OLED screen

unsigned long lastDebounceTime = 0;  // the last time the output pin was toggled
unsigned long debounceDelay = 50;    // the debounce time; increase if the output flickers

const int neoPixelcount = 1;         // How many NeoPixels are attached?
int neoBrightness = 255;

  float BMP280temp = -1;
  float BMP280preshPa = -1;
  float soilTemperatureC = -1;
  uint32_t BMP280pres = -1;
  float BMP280alti = -1;

// Declare our NeoPixel object:
Adafruit_NeoPixel neopixel(neoPixelcount, neoPixelPin, NEO_GRB + NEO_KHZ800);

// OLED stuffs **********************
// ==================================

#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>

#define OLED_RESET 17
#define SCREEN_ADDRESS 0x3C //
#define SCREEN_WIDTH 128 // OLED display width, in pixels
#define SCREEN_HEIGHT 64 // OLED display height, in pixels
uint32_t displayLimit = 1500;
uint32_t displayLowerLimit = 0;
uint32_t displayFactor = (displayLimit-displayLowerLimit) / 48;
uint32_t meas_counter = 0;
int32_t thresholdPPM = 450;

// Declare our display object:
Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, OLED_RESET);


// SCD41 calibration settings *******
// ==================================

uint16_t alt = 408; //Zurich, Switzerland
//uint16_t alt = 274; //Maribor, Slovenia
//uint16_t alt = 295; //Ljubljana, Slovenia
//uint16_t alt = 731; //Trubschachen, Emmental
uint32_t pressureCalibration;
float tempOffset = 2.8;
bool ascSetting = false; // Turn automatic self calibration off

// DS18x20 stuffs *******************
// ==================================

#ifdef DS18x20_IS_ATTACHED
  #include <OneWireNg_Config.h>
  #include <OneWireNg_BitBang.h>
  #include <OneWireNg_CurrentPlatform.h>
  #include <OneWireNg.h>
  #include <DallasTemperature.h>

  // GPIO where the DS18B20 is connected to
  const int oneWireBus = 10;  
  unsigned long DS18x20DataTimer = 0;   
  OneWire oneWire(oneWireBus);
  DallasTemperature DS18x20sensors(&oneWire);
  // arrays to hold device address
  DeviceAddress soilThermometer;

  //float soilTemperatureC;

  // function to print a device address
void printAddress(DeviceAddress deviceAddress)
{
  for (uint8_t i = 0; i < 8; i++)
  {
    if (deviceAddress[i] < 16) Serial.print("0");
    Serial.print(deviceAddress[i], HEX);
  }
}
#endif

// BMP280 stuffs ********************
// ==================================

#ifdef BMP_IS_ATTACHED
  #include <Adafruit_BMP280.h>
  Adafruit_BMP280 bmp; // I2C

  #define SEA_LEVEL_PRESSURE    1025.0f   // sea level pressure 1013.25
  #define BMP_ADDRESS 0x76
  //float BMP280temp;
  //uint32_t BMP280pres;
  //float BMP280preshPa;
  //float BMP280alti;
  unsigned long BMP280DataTimer = 0;
#endif

// Sensirion SCD4x stuffs ***********
// ==================================

SensirionI2CScd4x scd4x;

unsigned long SCD41DataTimer = 0;
unsigned long TimeSec = 0;
unsigned long timeElapse = 0;//used to wait the sensor to stabilize before calibration
uint16_t error;
char errorMessage[256];
uint16_t co2;
float temperature;
float humidity;

void printUint16Hex(uint16_t value) {
    Serial.print(value < 4096 ? "0" : "");
    Serial.print(value < 256 ? "0" : "");
    Serial.print(value < 16 ? "0" : "");
    Serial.print(value, HEX);
}

void printSerialNumber(uint16_t serial0, uint16_t serial1, uint16_t serial2) {
    Serial.print("Serial: 0x");
    printUint16Hex(serial0);
    printUint16Hex(serial1);
    printUint16Hex(serial2);
    Serial.println();
}


// THINGSSPEAK ********************
// ==================================

#ifdef USE_THINGSPEAK
  #include <WiFi.h>
  #include "ThingSpeak.h" // always include thingspeak header file after other header files and custom macros
  
  char ssid[] = SECRET_SSID;   // your network SSID (name) 
  char pass[] = SECRET_PASS;   // your network password
  int keyIndex = 0;            // your network key Index number (needed only for WEP)
  WiFiClient  client;
  unsigned long thingspeakDataTimer = 0;
  unsigned long myChannelNumber = SECRET_CH_ID;
  const char * myWriteAPIKey = SECRET_WRITE_APIKEY;

void connectWifi(){
    // Connect or reconnect to WiFi
    if(WiFi.status() != WL_CONNECTED){
      OLEDtestWiFi();
      neopixel.setPixelColor(0, neopixel.Color(0, 0, 255));
      neopixel.show();
      Serial.print("Attempting to connect to SSID: ");
      Serial.println(SECRET_SSID);
      while(WiFi.status() != WL_CONNECTED){
        WiFi.begin(ssid, pass);  // Connect to WPA/WPA2 network. Change this line if using open or WEP network
        Serial.print(".");
        delay(2000);
        neopixel.setPixelColor(0, neopixel.Color(255, 0, 0));
        neopixel.show();
        delay(2000);
        neopixel.clear();
        neopixel.show();     
      } 
      Serial.println("\nConnected.");
      neopixel.setPixelColor(0, neopixel.Color(0, 255, 0));
      neopixel.show();
      OLEDtestSuccess();
      delay(2000);
      OLEDdrawBackground();
    }
}
  
#endif

void setup() {
    
    Serial.begin(115200);
    //while ( !Serial ) delay(100);   // wait for native usb
    delay(500);

    #ifdef FEATHERS2
    adc1_config_width(ADC_WIDTH_BIT_13);
    adc1_config_channel_atten(ADC1_CHANNEL_4,ADC_ATTEN_DB_11);
    #endif
    

    Serial.println("    ");
    Serial.println("=========== Booting ROŠA System ===========");
    pinMode(LEDonBoard, OUTPUT);
    digitalWrite(LEDonBoard, HIGH);
    pinMode(LEDexternal, OUTPUT);
    digitalWrite(LEDexternal, HIGH);
    pinMode(OLED_RESET, OUTPUT);
    digitalWrite(OLED_RESET, HIGH);
    delay(100);
    digitalWrite(OLED_RESET, LOW);
    delay(100);
    digitalWrite(OLED_RESET, HIGH);
    
    pinMode(buttonPin, INPUT_PULLUP);
    pinMode(cal_pin, INPUT_PULLUP); // entrada pulsado para calibrar, seteada como pulluppara poder conectar pulsador sin poenr resistencia adicional
    
    Serial.println("    ");
    Serial.println("=========== start Wire i2c ==================");
    #ifdef WEMOS_LOLIN32
    Wire.begin(SDA_PIN, SCL_PIN);
    delay(100);
    Wire.setClock(100000);
    delay(100);
    #endif
    #ifdef FEATHERS2
    Wire.begin();
    #endif
    #ifdef FEATHERS3
    Wire.begin();
    #endif
    Serial.println("    ");
    Serial.println("=========== Initializing OLED Screen ===========");
    initDisplay();
    Serial.println("    ");
    delay(100);

    showLogo_hackteria();
    delay(1000);

    showLogo_regosh();
    delay(1000);
    showLogo_humus_text();
    delay(1000);

    display.clearDisplay();

    Serial.println("    ");
    Serial.println("=========== Turn on NEO Pixel ==================");
    neopixel.begin();           // INITIALIZE NeoPixel strip object (REQUIRED)
    delay(100);
    neopixel.clear();
    neopixel.show();
    neopixel.setBrightness(neoBrightness); // Set BRIGHTNESS to about 1/5 (max = 255)

    rainbow(5);             // Flowing rainbow cycle along the whole strip
    //rainbowCycle(15);
    //rainbowCycle(15);

    neopixel.setPixelColor(0, neopixel.Color(255, 0, 255));
    neopixel.show();    
    Serial.println("    ");
    Serial.println("=========== Turn on Wifi ==================");

#ifdef USE_THINGSPEAK
    WiFi.mode(WIFI_STA);   
    ThingSpeak.begin(client);  // Initialize ThingSpeak
    Serial.println("Starting WiFi");
    neopixel.clear();
    neopixel.show();
    connectWifi();
#endif

#ifdef USE_OTA
    Serial.println("Booting");
    //WiFi.mode(WIFI_STA);
    //WiFi.begin(ssid, pass);
    while (WiFi.waitForConnectResult() != WL_CONNECTED) {
    Serial.println("Connection Failed! Rebooting...");
    delay(5000);
    ESP.restart();
  }

  // Port defaults to 3232
  // ArduinoOTA.setPort(3232);

  // Hostname defaults to esp3232-[MAC]
  //ArduinoOTA.setHostname("UROS-HekLab");
  ArduinoOTA.setHostname(OTA_name);

  // No authentication by default
  // ArduinoOTA.setPassword("admin");

  // Password can be set with it's md5 value as well
  // MD5(admin) = 21232f297a57a5a743894a0e4a801fc3
  // ArduinoOTA.setPasswordHash("21232f297a57a5a743894a0e4a801fc3");

  ArduinoOTA
    .onStart([]() {
      String type;
      if (ArduinoOTA.getCommand() == U_FLASH)
        type = "sketch";
      else // U_SPIFFS
        type = "filesystem";

      // NOTE: if updating SPIFFS this would be the place to unmount SPIFFS using SPIFFS.end()
      Serial.println("Start updating " + type);
    })
    .onEnd([]() {
      Serial.println("\nEnd");
    })
    .onProgress([](unsigned int progress, unsigned int total) {
      Serial.printf("Progress: %u%%\r", (progress / (total / 100)));
    })
    .onError([](ota_error_t error) {
      Serial.printf("Error[%u]: ", error);
      if (error == OTA_AUTH_ERROR) Serial.println("Auth Failed");
      else if (error == OTA_BEGIN_ERROR) Serial.println("Begin Failed");
      else if (error == OTA_CONNECT_ERROR) Serial.println("Connect Failed");
      else if (error == OTA_RECEIVE_ERROR) Serial.println("Receive Failed");
      else if (error == OTA_END_ERROR) Serial.println("End Failed");
    });

  ArduinoOTA.begin();

  Serial.println("Ready");
  Serial.print("IP address: ");
  Serial.println(WiFi.localIP());    
    #endif

    Serial.println("    ");

    Serial.println("============ Testing DS18x20 Sensor ============");

// needs to be finished
//*****************************************
#ifndef DS18x20_IS_ATTACHED
    Serial.println("DS18x20 not in use");
    OLEDtestDS18b20();
    delay(500);
    OLEDnotinuse();
    delay(2000);
#endif

#ifdef DS18x20_IS_ATTACHED
    Serial.println("DS18x20: begin");
    OLEDtestDS18b20();
    DS18x20sensors.begin();

    Serial.print("DS18x20: Found ");
    Serial.print(DS18x20sensors.getDeviceCount(), DEC);
    Serial.println(" devices.");

    if (!DS18x20sensors.getAddress(soilThermometer, 0)) {
      Serial.println("Unable to find address for Device 0");
      delay(500);
      showError(); //ERROR
    } else {
      delay(500);
      OLEDtestSuccess();
    }

    Serial.print("DS18x20: Device 0 Address: ");
    printAddress(soilThermometer);
    Serial.println();

    // set the resolution to 9 bit (Each Dallas/Maxim device is capable of several different resolutions)
    DS18x20sensors.setResolution(soilThermometer, 12);
 
    Serial.print("DS18x20: Device 0 Resolution: ");
    Serial.print(DS18x20sensors.getResolution(soilThermometer), DEC); 
    Serial.println();
    
    DS18x20sensors.requestTemperatures(); 
    soilTemperatureC = DS18x20sensors.getTempCByIndex(0);
    Serial.println("DS18x20: read once:");
    Serial.print("Soil Temperature: ");
    Serial.print(soilTemperatureC);
    Serial.println(" ºC");
    delay(1000);

    Serial.println("==================  end test  ==================");
    Serial.println();
#endif

    Serial.println("======== Testing BMP280 Pressure Sensor ========");
    
#ifndef BMP_IS_ATTACHED
    Serial.println("BMP280 not in use");
    OLEDtestBMP280();
    delay(500);
    OLEDnotinuse();
    delay(2000);
#endif

#ifdef BMP_IS_ATTACHED
    unsigned status;
    Serial.println("BMP280: begin");
    status = bmp.begin(BMP_ADDRESS, BMP280_CHIPID);
    //status = bmp.begin(0x77, BMP280_CHIPID);
    
    OLEDtestBMP280();
    delay(500);
    if (!status) {
      Serial.println(F("Could not find a valid BMP280 sensor, check wiring or "
                      "try a different address!"));
      Serial.print("SensorID was: 0x"); Serial.println(bmp.sensorID(),16);
      Serial.print("        ID of 0xFF probably means a bad address, a BMP 180 or BMP 085\n");
      Serial.print("   ID of 0x56-0x58 represents a BMP 280,\n");
      Serial.print("        ID of 0x60 represents a BME 280.\n");
      Serial.print("        ID of 0x61 represents a BME 680.\n");
      Serial.print("        ID of 0x76 represents a BME 680.\n");
      showError(); //ERROR
      neopixel.setPixelColor(0, neopixel.Color(100, 0, 0));
      neopixel.show();
      delay(3000);
    } else {
        Serial.println("BMP280 connected successfully");
        OLEDtestSuccess();
        neopixel.setPixelColor(0, neopixel.Color(0, 100, 0));
        neopixel.show();
        delay(500);
        
    }
    neopixel.clear();
    neopixel.show();
       
    /* Default settings from datasheet. */
    bmp.setSampling(Adafruit_BMP280::MODE_NORMAL,       /* Operating Mode. */
                    Adafruit_BMP280::SAMPLING_X2,       /* Temp. oversampling */
                    Adafruit_BMP280::SAMPLING_X16,      /* Pressure oversampling */
                    Adafruit_BMP280::FILTER_X16,        /* Filtering. */
                    Adafruit_BMP280::STANDBY_MS_500);   /* Standby time. */
    delay(100);
    
    Serial.println("BMP280: read once");

    Serial.print("Temperature: ");
    Serial.print(bmp.readTemperature());
    Serial.print(" ºC");

    Serial.print("\t Pressure = ");
    Serial.print(bmp.readPressure());
    Serial.print(" Pa");

    Serial.print("\t Approx altitude = ");
    Serial.print(bmp.readAltitude(SEA_LEVEL_PRESSURE)); /* Adjusted to local forecast! */
    Serial.print(" m");
    Serial.println();
    
    OLEDshowBMP280(bmp.readPressure()/100, bmp.readTemperature(), bmp.readAltitude(SEA_LEVEL_PRESSURE));
    delay(1000);

    Serial.println("==================  end test  ==================");
    Serial.println();
    
#endif
    
    Serial.println("=========== Testing SCD41 CO2 Sensor ===========");
    Serial.println("SCD41: begin");
    OLEDtestSCD41();
    delay(500);
    scd4x.begin(Wire);

    // stop potentially previously started measurement
    error = scd4x.stopPeriodicMeasurement();
    if (error) {
        Serial.print("Error trying to execute stopPeriodicMeasurement(): ");
        errorToString(error, errorMessage, 256);
        Serial.println(errorMessage);
        showError(); //ERROR
        neopixel.setPixelColor(0, neopixel.Color(100, 0, 0));
        neopixel.show();
        delay(3000);
        delay(3000);
    } else {
        OLEDtestSuccess();
        neopixel.setPixelColor(0, neopixel.Color(0, 0, 200));
        neopixel.show();
        delay(500);
        
    }
    neopixel.clear();
    neopixel.show();
    

    uint16_t serial0;
    uint16_t serial1;
    uint16_t serial2;
    error = scd4x.getSerialNumber(serial0, serial1, serial2);
    if (error) {
        Serial.print("Error trying to execute getSerialNumber(): ");
        errorToString(error, errorMessage, 256);
        Serial.println(errorMessage);
    } else {
        Serial.println("SCD41 connected succesfully");                                                                                                           
        printSerialNumber(serial0, serial1, serial2);
    }

// Some settings **************************************
    
    scd4x.setSensorAltitude(alt);
    //scd4x.setAmbientPressure(pressureCalibration);
    scd4x.setTemperatureOffset(tempOffset);
    scd4x.setAutomaticSelfCalibration(ascSetting);
    
    uint16_t ascEnabled;
    error = scd4x.getAutomaticSelfCalibration(ascEnabled);
    if (error) {
        Serial.print("Error trying: ");
        errorToString(error, errorMessage, 256);
        Serial.println(errorMessage);
    } else {
        Serial.print("AutoSelfCalibrations is: ");
        if (ascEnabled) Serial.println("ON");
        if (!ascEnabled) Serial.println("OFF");
    }
    
    uint16_t setAlt;
    error = scd4x.getSensorAltitude(setAlt);
    if (error) {
        Serial.print("Error trying: ");
        errorToString(error, errorMessage, 256);
        Serial.println(errorMessage);
    } else {
        Serial.print("Altitude is set to: ");
        Serial.println(setAlt);
    }

    float settempOffset;
    error = scd4x.getTemperatureOffset(settempOffset);
    if (error) {
        Serial.print("Error trying: ");
        errorToString(error, errorMessage, 256);
        Serial.println(errorMessage);
    } else {
        Serial.print("Temperature Offset set to: ");
        Serial.println(settempOffset);
    }
    

// Start Measurement **************************************

    error = scd4x.startPeriodicMeasurement();
    if (error) {
        Serial.print("Error trying to execute startPeriodicMeasurement(): ");
        errorToString(error, errorMessage, 256);
        Serial.println(errorMessage);
    }
    Serial.println("==================  end test  ==================");

    Serial.println();
    Serial.println("Waiting for first measurement... (5 sec)");
    Serial.println(".");
    OLEDshowSCD41(ascEnabled, setAlt, settempOffset);
    delay(1000);
    Serial.println("..");
    delay(1000);
    OLEDstartMeasurements();
    Serial.println("...");
    delay(1000);
    showLogo_sensirion();
    Serial.println("....");
    delay(1000);
    
    Serial.println(".....");
    delay(1000);
        
    Serial.println("============= Starting Measurements ============");
    if (screenState == 1) OLEDdrawBackgroundTemp();
    if (screenState == 0) OLEDdrawBackground();
    #ifdef USE_THINGSPEAK
      thingspeakDataTimer = millis();
    #endif
    #ifdef DS18x20_IS_ATTACHED
      DS18x20DataTimer = millis();
    #endif
    #ifdef BMP_IS_ATTACHED
      BMP280DataTimer = millis();
    #endif
    #ifdef SCD41_IS_ATTACHED
      SCD41DataTimer = millis();
    #endif
}

void loop() {
    #ifdef USE_OTA
    ArduinoOTA.handle();
    #endif
    digitalWrite(LEDonBoard, HIGH);
    digitalWrite(LEDexternal, HIGH);
    
    int reading = digitalRead(buttonPin);
    if (reading != lastButtonState) {
      // reset the debouncing timer
      lastDebounceTime = millis();
    }
     
    if ((millis() - lastDebounceTime) > debounceDelay) {
      if (reading != buttonState) {
        buttonState = reading;
  
        if (buttonState == HIGH) {
          screenState = !screenState;
          
        if (screenState == 0) {
          displayLimit = 1500;
          displayLowerLimit = 0;
          OLEDdrawBackground();
        
        }
    
        if (screenState == 1) {
          displayLimit = 5000;
          displayLowerLimit = 1500;
          OLEDdrawBackgroundTemp();
      }
          
          meas_counter = 0;
        }
      }
    }
    
    // read the cal_pin button and calibrate if pressed:
    if (digitalRead(cal_pin) == LOW) {    // si detecta el botón de calibrar apretado, calibra
      calDisplay();
      calibrar(410);
    }


    batCounter = batCounter + 1;
    ADCValue =  adc1_get_raw(ADC1_CHANNEL_5);
    
    #ifdef FEATHERS2
    voltage = voltage + map(ADCValue, 0, 8191, 0, 5330); 
    #endif
    #ifdef FEATHERS3
    voltage = voltage + map(ADCValue, 0, 1765, 0, 3300); 
    #endif
    #ifdef WEMOS_LOLIN32
    voltage = voltage + map(ADCValue, 0, 1765, 0, 3300); 
    #endif

    //voltage = ADCValue;

    if (batCounter >= batAveraging) {
        battery = voltage / batAveraging;
        voltage = 0;
        batCounter = 0;
    }


#ifdef DS18x20_IS_ATTACHED
    if (millis() - DS18x20DataTimer >= 1000){
      DS18x20sensors.requestTemperatures(); 
      soilTemperatureC = DS18x20sensors.getTempCByIndex(0);
      if(soilTemperatureC == DEVICE_DISCONNECTED_C) {
        
        //Serial.println("Error: Could not read soilTemperature data");
        //return;
        }
      DS18x20DataTimer = millis();
      //TimeSec = DS18x20DataTimer / 1000;
      if (screenState == 1) meas_counter++;
      //printResults();
    }    
#endif

#ifdef BMP_IS_ATTACHED
    if (millis() - BMP280DataTimer >= 300){
      digitalWrite(LEDonBoard, LOW);
      digitalWrite(LEDexternal, LOW);
      neopixel.setPixelColor(0, neopixel.Color(105, 50, 0));
      neopixel.show();
      BMP280temp = bmp.readTemperature();
      BMP280pres = bmp.readPressure();
      BMP280alti = bmp.readAltitude(SEA_LEVEL_PRESSURE); /* Adjusted to local forecast! */
      BMP280preshPa = BMP280pres;
      BMP280preshPa = BMP280preshPa / 100;  
      BMP280DataTimer = millis();
      TimeSec = BMP280DataTimer / 1000;
      //if (screenState == 1) meas_counter++;
      //printResults();
    }
#endif

// read the SCD41 CO2 Sensor

    if (millis() - SCD41DataTimer >= 6000){
      
      neopixel.setPixelColor(0, neopixel.Color(255, 0, 255));
      neopixel.show();
      
    // Read Measurement from SCD41 CO2 sensor
      
      error = scd4x.readMeasurement(co2, temperature, humidity);
      if (error) {
          Serial.print("Error trying to execute readMeasurement(): ");
          errorToString(error, errorMessage, 256);
          Serial.println(errorMessage);
          SCD41DataTimer = millis();
      } else if (co2 == 0) {
          Serial.println("Invalid sample detected, skipping.");
      } else {
          SCD41DataTimer = millis();
          TimeSec = SCD41DataTimer / 1000;
      }
      delay(200); 
      if (co2<=800){ 
        neopixel.clear();
        neopixel.setPixelColor(0, neopixel.Color(0, 255, 0));
        neopixel.show();
      }
      if (co2>=800 && co2<=1200){ 
        neopixel.clear();
        neopixel.setPixelColor(0, neopixel.Color(255, 125, 0));
        neopixel.show();
      }   
      if (co2>=1200 && co2<=2000){ 
        neopixel.clear();
        neopixel.setPixelColor(0, neopixel.Color(255, 55, 0));
        neopixel.show();
      }     
      if (co2>=2000){ 
        neopixel.clear();
        neopixel.setPixelColor(0, neopixel.Color(255, 0, 0));
        neopixel.show();
      }   
      printResults(); 
      if (screenState == 0) meas_counter++;
        
    }
    
  lastButtonState = reading;
      
    #ifdef USE_THINGSPEAK
      if (millis() - thingspeakDataTimer >= 30000){
        Serial.println("Checking WiFi");
        neopixel.clear();
        neopixel.show();
        connectWifi();
        Serial.println("Sending measurements");
         #ifdef BMP_IS_ATTACHED
          //if (BMP280preshPa != 42949672.00) ThingSpeak.setField(1, BMP280temp);
          if (BMP280preshPa != 42949672.00) ThingSpeak.setField(2, BMP280preshPa);
          if (BMP280preshPa != 42949672.00) ThingSpeak.setField(7, BMP280alti);       
         #endif
         #ifdef SCD41_IS_ATTACHED
          ThingSpeak.setField(3, co2);
          ThingSpeak.setField(4, humidity);
          ThingSpeak.setField(1, temperature);
          ThingSpeak.setField(6, battery);
         #endif
         #ifdef DS18x20_IS_ATTACHED
          ThingSpeak.setField(5, soilTemperatureC);
         #endif
          int x = ThingSpeak.writeFields(myChannelNumber, myWriteAPIKey);
          if(x == 200){
            Serial.println("Channel update successful.");
            neopixel.setPixelColor(0, neopixel.Color(0, 0, 255));
            neopixel.show();
            delay(200); 
            rainbowCycle(5);
            }
          else{
            Serial.println("Problem updating channel. HTTP error code " + String(x));
            }
          thingspeakDataTimer = millis();
      }
    #endif
    
    delay(1); 
    if (batCounter == batAveraging - 1) {
      // maybe put this somewhere else...
    if (screenState == 0) {
        displayLimit = 1500;
        displayLowerLimit = 0;
        //OLEDshowCO2(co2, temperature, humidity);
        OLEDshowCO2(co2, temperature, battery/1000);
        //delay(10);
      }
    
    if (screenState == 1) {
        displayLimit = 5500;
        displayLowerLimit = 2500;
        //OLEDgraphTEMP(BMP280temp, BMP280pres, BMP280alti);
        //OLEDgraphTEMP(soilTemperatureC, BMP280pres, BMP280alti);
        OLEDgraphTEMP(soilTemperatureC, co2, humidity);
      }
      //printResults();
    }
}


void printResults()
{
        Serial.print("TimeSec: ");
        Serial.print(TimeSec);
        Serial.print("\t");
        Serial.print("CO2: ");
        Serial.print(co2);
        Serial.print("\t");
        Serial.print("Temp: ");
        Serial.print(temperature);
        Serial.print("\t");
        Serial.print("Hum%: ");
        Serial.print(humidity);
        Serial.print("\t");
        Serial.print("Bat: ");
        Serial.print(battery/1000);
        //Serial.print("\t");
        //Serial.print("ADC: ");
        //Serial.print(battery/1000);
        //Serial.print(ADCValue);

        
        
#ifdef BMP_IS_ATTACHED
        Serial.print("\t");
        Serial.print("BMB-Pres: ");
        if (BMP280preshPa == 42949672.00) Serial.print("n.c.");
        else Serial.print(BMP280preshPa);
        Serial.print("\t");
        Serial.print("Alti: ");
        if (BMP280preshPa == 42949672.00) Serial.print("n.c.");
        else Serial.print(BMP280alti);
        Serial.print("\t");
        Serial.print("BMP-Temp: ");
        if (BMP280preshPa == 42949672.00) Serial.print("n.c.");
        else Serial.print(BMP280temp);
#endif
#ifdef DS18x20_IS_ATTACHED
        Serial.print("\t");
        Serial.print("SoilTemp: ");
        if(soilTemperatureC == DEVICE_DISCONNECTED_C) {
          Serial.print("n.c.");
        }
        else {
        Serial.print(soilTemperatureC);
        }
#endif
        Serial.println();       
}


void calibrar(uint16_t calPPM)
{
  // Force Calibration **************************************

   /**
     * performForcedRecalibration() - To successfully conduct an accurate forced
    recalibration, the following steps need to be carried out:
    1. Operate the SCD4x in a periodic measurement mode for > 3 minutes in an
    environment with homogenous and constant CO₂ concentration.
    2. Stop periodic measurement. Wait 500 ms.
    3. Subsequently issue the perform_forced_recalibration command and
    optionally read out the baseline correction. A return value of 0xffff
    indicates that the forced recalibration failed.
     *
     * @param targetCo2Concentration Target CO₂ concentration in ppm.
     *
     * @param frcCorrection FRC correction value in CO₂ ppm or 0xFFFF if the
    command failed. Convert value to CO₂ ppm with: value - 0x8000
     *
     * @return 0 on success, an error code otherwise
     */

    delay(60000);
    calDisplay();
    
    uint16_t frc;
    
    error = scd4x.stopPeriodicMeasurement();
    if (error) {
        Serial.print("Error trying to execute stopPeriodicMeasurement(): ");
        errorToString(error, errorMessage, 256);
        Serial.println(errorMessage);
    }
    delay(500);
    error = scd4x.performForcedRecalibration(calPPM, frc);
    if (error) {
        Serial.print("Error trying: ");
        errorToString(error, errorMessage, 256);
        Serial.println(errorMessage);
    } else {
        Serial.print("Changed calibration by: ");
        Serial.println(frc-0x8000);
    }
    delay(500);
    error = scd4x.startPeriodicMeasurement();
    if (error) {
        Serial.print("Error trying to execute startPeriodicMeasurement(): ");
        errorToString(error, errorMessage, 256);
        Serial.println(errorMessage);
    }
    Serial.println("============= Starting Measurements ============");
    OLEDdrawBackground();
    
    delay(5000);
}


// """""

void rainbow(uint8_t wait) {
  uint16_t i, j;

  for(j=0; j<256; j++) {
    for(i=0; i<neopixel.numPixels(); i++) {
      neopixel.setPixelColor(i, Wheel((i+j) & 255));
    }
    neopixel.show();
    delay(wait);
  }
}

// Slightly different, this makes the rainbow equally distributed throughout
void rainbowCycle(uint8_t wait) {
  uint16_t i, j;

  for(j=0; j<256*5; j++) { // 5 cycles of all colors on wheel
    for(i=0; i< neopixel.numPixels(); i++) {
      neopixel.setPixelColor(i, Wheel(((i * 256 / neopixel.numPixels()) + j) & 255));
    }
    neopixel.show();
    delay(wait);
  }
}

// Input a value 0 to 255 to get a color value.
// The colours are a transition r - g - b - back to r.
uint32_t Wheel(byte WheelPos) {
  WheelPos = 255 - WheelPos;
  if(WheelPos < 85) {
    return neopixel.Color(255 - WheelPos * 3, 0, WheelPos * 3);
  }
  if(WheelPos < 170) {
    WheelPos -= 85;
    return neopixel.Color(0, WheelPos * 3, 255 - WheelPos * 3);
  }
  WheelPos -= 170;
  return neopixel.Color(WheelPos * 3, 255 - WheelPos * 3, 0);
}


// OLED stuffs **********************

void initDisplay()
{  /* SSD1306_SWITCHCAPVCC = generate display voltage from 3.3V internally
    if(!display.begin(SSD1306_SWITCHCAPVCC, 0x3C)) {
    Serial.println(F("SSD1306 allocation failed"));
    for(;;); // Don't proceed, loop forever
     } 
     */
    display.begin(SSD1306_SWITCHCAPVCC, SCREEN_ADDRESS, false, false);
    //display.begin(SSD1306_SWITCHCAPVCC, 0x3C);
    display.clearDisplay();
    display.display();
}

void showLogo_oursci(){
  display.clearDisplay(); // Make sure the display is cleared
  display.drawBitmap(0, 0, oursci_logo, 128, 64, WHITE);  
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(24,0);
  display.println("OUR-SCI");
  // Update the display
  display.display();
  delay(30);
}

void showLogo_hackteria(){
  display.clearDisplay(); // Make sure the display is cleared
  display.drawBitmap(0, 0, hackteria_logo, 128, 64, WHITE);  
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(11,0);
  display.println("HACKTERIA");
  // Update the display
  display.display();
  delay(30);
}

void OLEDtestBMP280(){
  display.clearDisplay(); // Make sure the display is cleared
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(4, 0);
  display.println("BPM");
  display.setCursor(4, 9);
  display.println("280");
  display.setTextColor(WHITE);
  display.setCursor(24,0);
  display.println(" >>  Test BPM280");
  display.display();
  delay(30);
}

void OLEDnotinuse(){
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(24,9);
  display.println(" >>  NOT IN USE");
  display.display();
  delay(30);
}

void OLEDtestSCD41(){
  display.clearDisplay(); // Make sure the display is cleared
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(4, 0);
  display.println("SCD");
  display.setCursor(4, 9);
  display.println("41");
  display.setTextColor(WHITE);
  display.setCursor(24,0);
  display.println(" >>  Test SCD41");
  display.display();
  delay(30);
}

void OLEDtestDS18b20(){
  display.clearDisplay(); // Make sure the display is cleared
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(4, 0);
  display.println("DS");
  display.setCursor(4, 9);
  display.println("18b20");
  display.setTextColor(WHITE);
  display.setCursor(24,0);
  display.println(" >>  Test DS18b20");
  display.display();
  delay(30);
}

void OLEDtestWiFi(){
  display.clearDisplay(); // Make sure the display is cleared
  display.fillRect(0, 0, 128, 16, BLACK);
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(4, 0);
  display.println("WiFi");
  display.setCursor(24,0);
  display.println(" >> Connecting to");
  display.setCursor(4, 9);
  display.println("SSID");
  display.setCursor(24,9);
  display.print(" >> ");
  #ifdef USE_THINGSPEAK
  display.println(SECRET_SSID);
  #endif
  display.display();
  delay(30);
}

void OLEDtestSuccess(){
  //display.clearDisplay(); // Make sure the display is cleared
  display.fillRect(28, 0, 128, 16, BLACK);
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(32,0);
  display.println("SUCCESS");
  display.display();
  delay(30);
}

void showError(){
 
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(30,32);
  display.println("ERROR");
  // Update the display
  display.display();
  delay(30);
}

void OLEDstartMeasurements(){
  display.clearDisplay(); // Make sure the display is cleared
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(10,0);
  display.println("Start Measurements");
  display.display();
  delay(30);
}

void showLogo_humus(){
  display.clearDisplay(); // Make sure the display is cleared
  display.drawBitmap(0, 0, humus_logo, 128, 64, WHITE);  
  // Update the display
  display.display();
  delay(30);
}

void showLogo_regosh(){
  display.clearDisplay(); // Make sure the display is cleared
  display.drawBitmap(0, 0, logo_regosh, 128, 64, WHITE);  
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(24,0);
  //display.println("re-GOSH");
  // Update the display
  display.display();
  delay(30);
}

void showLogo_sensirion(){
  display.clearDisplay(); // Make sure the display is cleared
  display.drawBitmap(0, 0, logo_sensirion, 128, 64, WHITE);  
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(0,24);
  display.println("SCD41");
  display.setCursor(94,24);
  display.println("Thank");
  display.setCursor(104,34);
  display.println("you");
  // Update the display
  display.display();
  delay(30);
}

void showLogo_humus_text(){
  display.clearDisplay(); // Make sure the display is cleared
  display.drawBitmap(0, 0, humus_logo, 128, 64, WHITE);  
  display.setTextSize(1);
  display.setTextColor(WHITE);
  display.setCursor(38,17);
  display.println("CO2 Respiration");
  display.setTextSize(2);
  display.setTextColor(WHITE);
  display.setCursor(20,0);
  display.println("ROSA CO2");
  // Update the display
  display.display();
  delay(30);
}

void showLogo_humus_plant(){
  //display.clearDisplay(); // Make sure the display is cleared
  display.drawBitmap(0, 0, humus_logo_plant, 128, 64, WHITE);  
  // Update the display
  //display.display();
  delay(30);
}

void OLEDdrawBackground()
{
    display.clearDisplay();
    for (int i = 28; i <= 128; i = i + 3) {
        display.drawPixel(i, 64 - (400 / displayFactor), WHITE);
    }
    for (int i = 28; i <= 128; i = i + 5) {
        display.drawPixel(i, 64 - ((displayLimit-500-displayLowerLimit) / displayFactor), WHITE);
    }
    /*
    for (int i = 28; i <= 128; i = i + 7) {
        display.drawPixel(i, 64 - (3000 / displayFactor), WHITE);
    }
    */
    display.drawRect(28, 16, 100, 48, 1); //Border of the bar chart

    display.setTextSize(1);
    display.setTextColor(WHITE);
    display.setCursor(100, 21);
    display.print((displayLimit-300)/1);
    display.println("");
    display.setCursor(100, 46);
    display.print(" 400");
    display.println("");
    display.setTextSize(1);
    display.fillRect(29, 46, 70, 17, BLACK);
    display.setCursor(30, 47);
    //display.println("HUMUS.Sapiens");
    display.setCursor(36, 55);
    display.println("CO2 respiration");
    display.drawBitmap(0, 0, humus_logo_plant, 128, 64, WHITE);
    display.display();
}

void OLEDdrawBackgroundTemp()
{
    display.clearDisplay();
    for (int i = 28; i <= 128; i = i + 3) {
        display.drawPixel(i, 64 - (200 / displayFactor), WHITE);
    }
    for (int i = 28; i <= 128; i = i + 5) {
        display.drawPixel(i, 64 - ((displayLimit-500-displayLowerLimit) / displayFactor), WHITE);
    }
    /*
    for (int i = 28; i <= 128; i = i + 7) {
        display.drawPixel(i, 64 - (3000 / displayFactor), WHITE);
    }
    */
    display.drawRect(28, 16, 100, 48, 1); //Border of the bar chart

    display.setTextSize(1);
    display.setTextColor(WHITE);
    display.setCursor(100, 21);
    display.print((displayLimit-500)/100);
    display.println(" C");
    display.setCursor(100, 46);
    display.print((displayLowerLimit)/100);
    display.println(" C");
    display.setTextSize(1);
    display.fillRect(29, 46, 70, 17, BLACK);
    display.setCursor(30, 47);
    //display.println("HUMUS.Sapiens");
    display.setCursor(36, 55);
    display.println("Temperature");
    display.drawBitmap(0, 0, humus_logo_plant, 128, 64, WHITE);
    display.display();
}

void OLEDshowCO2(uint16_t ppm, float temp, float hum)
{   int tempRound = temp/1;
    int humRound = hum;
    float batFloat = hum;
    display.setTextSize(1);
    display.fillRect(0, 0, 128, 16, BLACK);
    display.setTextColor(WHITE);
    display.setCursor(40, 0);
    display.println("CO2");
    display.setCursor(40, 7);
    display.println("ppm");
    display.setTextSize(2);
    display.setCursor(56, 0);
    display.print(":");
    display.print(ppm);
    display.setTextSize(1);
    display.setCursor(4, 0);
    display.print(tempRound);
    display.println("C");
    display.setCursor(4, 9);
    display.print(batFloat);
    display.println("V");
/*
    if (meas_counter > 0) {
        display.drawLine(meas_counter - 1 + 28, 64 - last_ppm_high_res() / displayFactor, meas_counter + 28, 64 - current->ppm / displayFactor, WHITE);
    }
*/
    if (meas_counter >= 0) {
        display.drawLine(meas_counter + 28, 64 - 0 / displayFactor, meas_counter + 28, 64 - ((ppm*1)-displayLowerLimit) / displayFactor, WHITE);
    }

    if (meas_counter > 100) {
        meas_counter = 0;
        OLEDdrawBackground();
    }
/*
    if (ppm > thresholdPPM) {
        if (last_ppm_high_res() < thresholdPPM) {
            display.setTextSize(1);
            display.setCursor(h_head + 3, thresholdPPM / displayFactor + 10);
            display.print((millis() - started) / 1000);
            display.println("s");
        }
    }
*/

    display.display();
    delay(30);
}

// OLEDgraphTEMP(soilTemperatureC, co2, humidity);

void OLEDgraphTEMP(float temp, float pres, float alt)
{   int presRound = pres;
    int altRound = alt;
    display.setTextSize(1);
    display.fillRect(0, 0, 128, 16, BLACK);
    display.setTextColor(WHITE);
    display.setCursor(48, 0);
    display.println("T");
    display.setCursor(48, 7);
    display.println("C");
    display.setTextSize(2);
    display.setCursor(56, 0);
    display.print(":");
    display.print(temp);
    display.setTextSize(1);
    display.setCursor(4, 0);
    display.print(presRound);
    display.println("ppm");
    display.setCursor(4, 9);
    display.print(altRound);
    display.println("%");
/*
    if (meas_counter > 0) {
        display.drawLine(meas_counter - 1 + 28, 64 - last_ppm_high_res() / displayFactor, meas_counter + 28, 64 - current->ppm / displayFactor, WHITE);
    }
*/
    if (meas_counter >= 0) {
        display.drawLine(meas_counter + 28, 64 - 0 / displayFactor, meas_counter + 28, 64 - ((temp*100)-displayLowerLimit) / displayFactor, WHITE);
    }

    if (meas_counter > 100) {
        meas_counter = 0;
        OLEDdrawBackgroundTemp();
    }
/*
    if (ppm > thresholdPPM) {
        if (last_ppm_high_res() < thresholdPPM) {
            display.setTextSize(1);
            display.setCursor(h_head + 3, thresholdPPM / displayFactor + 10);
            display.print((millis() - started) / 1000);
            display.println("s");
        }
    }
*/

    display.display();
    delay(30);
}

void OLEDgraphTEMP_bak(float temp, float pres, float alt)
{   int presRound = pres;
    int altRound = alt;
    display.setTextSize(1);
    display.fillRect(0, 0, 128, 16, BLACK);
    display.setTextColor(WHITE);
    display.setCursor(48, 0);
    display.println("T");
    display.setCursor(48, 7);
    display.println("C");
    display.setTextSize(2);
    display.setCursor(56, 0);
    display.print(":");
    display.print(temp);
    display.setTextSize(1);
    display.setCursor(4, 0);
    display.print(presRound);
    display.println("hPa");
    display.setCursor(4, 9);
    display.print(altRound);
    display.println("m");
/*
    if (meas_counter > 0) {
        display.drawLine(meas_counter - 1 + 28, 64 - last_ppm_high_res() / displayFactor, meas_counter + 28, 64 - current->ppm / displayFactor, WHITE);
    }
*/
    if (meas_counter >= 0) {
        display.drawLine(meas_counter + 28, 64 - 0 / displayFactor, meas_counter + 28, 64 - ((temp*100)-displayLowerLimit) / displayFactor, WHITE);
    }

    if (meas_counter > 100) {
        meas_counter = 0;
        OLEDdrawBackgroundTemp();
    }
/*
    if (ppm > thresholdPPM) {
        if (last_ppm_high_res() < thresholdPPM) {
            display.setTextSize(1);
            display.setCursor(h_head + 3, thresholdPPM / displayFactor + 10);
            display.print((millis() - started) / 1000);
            display.println("s");
        }
    }
*/

    display.display();
    delay(30);
}

void OLEDshowSCD41(uint16_t ascEnabled, uint16_t alt, float temp)
{   
    display.drawRect(28, 16, 100, 48, 1); //Border of the bar chart
    //display.drawBitmap(0, 0, humus_logo_plant, 128, 64, WHITE);
    display.setTextSize(1);
    display.setTextColor(WHITE);
    display.setCursor(4, 0);
    display.println("SCD");
    display.setCursor(4, 9);
    display.println("41");
    
    display.setCursor(32, 0+22);
    display.println("ASC");
    display.setCursor(70, 0+22);
    display.print(":");
    if (ascEnabled) display.print("ON");
    if (!ascEnabled) display.print("OFF");

    display.setCursor(32, 0+35);
    display.println("S.Temp");
    display.setCursor(70, 0+35);
    display.print(":");
    display.print(temp);
    display.println(" *C");

    display.setCursor(32, 0+48);
    display.println("S.Alt");    
    display.setCursor(70, 0+48);
    display.print(":");
    display.print(alt);
    display.println(" m");

    display.display();
    delay(30);
}

void OLEDshowBMP280(uint32_t pa, uint16_t temp, float alt)
{   int tempRound = temp;
    int altRound = alt;
    display.fillRect(28, 16, 100, 48, BLACK);
    display.drawRect(28, 16, 100, 48, 1); //Border of the bar chart
    display.drawBitmap(0, 0, humus_logo_plant, 128, 64, WHITE);
    
    display.setTextSize(1);
    display.setTextColor(WHITE);
    display.setCursor(4, 0);
    display.println("BMP");
    display.setCursor(4, 9);
    display.println("280");
    
    display.setCursor(32, 0+22);
    display.println("Pres");
    display.setCursor(56, 0+22);
    display.print(":");
    display.print(pa);
    display.println(" Pa");

    display.setCursor(32, 0+35);
    display.println("Temp");
    display.setCursor(56, 0+35);
    display.print(":");
    display.print(tempRound);
    display.println(" *C");

    display.setCursor(32, 0+48);
    display.println("Alt");    
    display.setCursor(56, 0+48);
    display.print(":");
    display.print(altRound);
    display.println(" m");

    display.display();
    delay(30);
}

// Calibration display screen 10sec
void calDisplay(){
  int calCount = 0;
  unsigned long calSec = 0;
  unsigned long calTimer = 0;
  unsigned long calTime = 10000;
  showLogo_hackteria();
  calTimer = millis();
  
  while (calCount == 0){
    calSec = millis() - calTimer;
    if (calSec > calTime) {
    calCount++;
  }
  else{ 
  display.fillRect(0, 0, 128, 16, BLACK);
  display.setTextSize(1);
  display.setCursor(0,0);
  display.println("calibrating");  
        display.setTextSize(1);
        display.setCursor(0,9);
        display.print(calSec/1000);
        display.println(" sec / 10");
  display.display();
  digitalWrite (LEDonBoard, HIGH);
  delay(100);
  
  display.fillRect(0, 0, 128, 16, BLACK);
  display.setTextSize(1);
  display.setCursor(0,0);
  display.println("calibrating.");
        display.setTextSize(1);
        display.setCursor(0,9);
        display.print(calSec/1000);
        display.println(" sec / 10");
  display.display();
  digitalWrite (LEDonBoard, LOW);
  delay(100);
  
  display.fillRect(0, 0, 128, 16, BLACK);
  display.setTextSize(1);
  display.setCursor(0,0);
  display.println("calibrating..");
        display.setTextSize(1);
        display.setCursor(0,9);
        display.print(calSec/1000);
        display.println(" sec / 10");
  display.display();
  digitalWrite (LEDonBoard, HIGH);
  delay(100);
  
  display.fillRect(0, 0, 128, 16, BLACK);
  display.setTextSize(1);
  display.setCursor(0,0);
  display.println("calibrating...");
        display.setTextSize(1);
        display.setCursor(0,9);
        display.print(calSec/1000);
        display.println(" sec / 10");
  display.display();
  digitalWrite (LEDonBoard, LOW);
  delay(100);
    }
  }
  calCount = 0;
}
