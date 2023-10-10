#ifndef DataSctructures_h
#define DataSctructures_h

struct BMP280_data {              //Structure for BMP280_AltitudeCalibrator's function get_alldata
    float Altitude;
    bool Available;
};

struct SCD41_data {               //Structure for SCD41_Multiplexed's function get_alldata
    uint16_t co2[4]={-1,-1,-1,-1,};
    uint16_t Altitude[4]={-1,-1,-1,-1};
    float temperature[4]={-1,-1,-1,-1,};
    float humidity[4]={-1,-1,-1,-1,};
    bool Availability[4]={false,false,false,false,};
};

#endif