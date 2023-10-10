This program allows to use up to four SCD41 with a Wemos lolin32 lite board for up to four soil respiration chambers to be running simultaneously, it includes the usage of a OLED screen as User Interface, a BMP280 sensor for altitude calibration, and data sending to a thingspeak channel.

The wiring is as shown next

![Wemos_Schematics](https://github.com/GenericLab/CO2-soil-respiration-chamber/blob/main/hardware/WEMOS-lolin32_Multiplexing_SCD41%20schematics/Lolin%20Multiplexing%20SCD41%20Wiring.png)

The Soil respiration chamber contains a SCD41 sensor as shown next:

The Cabinet contains the rest of the electronics as shown next

The Wemos detects the sensors at setup, so you need to power the box after connecting the BMP280 (if available) and the SCD41 sensor

The calibration procedure starts with the push of the botton, for it to be successfull you'll need to open the respiration chamber and expose the sensor and the chamber to fresh air, then push the buton so the sensor start to measure fresh air, it gets calibrated using the air pressure given by the sensor, or the Lujan de Cuyo Altitude variable in SCD41_multiplexed.h file (you can change the used altitude in the main file if you need to). The full process last 3 minutes. After it's finished the sensor CO2 measurement is calibrated to 400 PPM, it is important to note that this is not an absolute measurement, but a relative one.

To start using the soil chamber you'll need to calibrate the sensor first. Then you shall weight 30 grams of the sample and add 9 mililiters of water. Then you'll close the container and let it measuring the CO2 concentration, it is highly recomended to not turn off the readings, because the SCD41 can lose calibration when turned off.
