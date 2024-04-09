#busca el directorio donde estan los archivos
setwd("C:/Users/mauri/Documents/Respiración")
getwd()

#define el nombre de los archivos .csv que vamos a utilizar
archivo1 <-"sensores 1 & 2"
archivo2 <-"sensores 3 & 4"

#abre el .csv que le pido
data1 = read.csv(paste0(archivo1,".csv"))
data2 = read.csv(paste0(archivo2,".csv"))

#-------Es necesario modificar el formato de algunos valores que se descargando desde Thingspeak para poder graficar---
#data1#
##elimina los últimos 6 caracteres (indicativos del utc-3)
data1$created_at <- substr(data1$created_at, 1, nchar(data1$created_at) - 6)
##elimina la "T" del formato UTC
data1$created_at <- paste(substr(data1$created_at, 1, 10), substr(data1$created_at, 12, nchar(data1$created_at)), sep = " ")
#convierte la primer columna a valores de hora
data1$created_at <- as.POSIXct(data1$created_at)
# Extraer hora, minutos y segundos
data1$created_at <- format(data1$created_at, format = "%H:%M:%S")
data1

#data2#
##elimina los últimos 6 caracteres (indicativos del utc-3)
data2$created_at <- substr(data2$created_at, 1, nchar(data2$created_at) - 6)
##elimina la "T" del formato UTC
data2$created_at <- paste(substr(data2$created_at, 1, 10), substr(data2$created_at, 12, nchar(data2$created_at)), sep = " ")
#convierte la primer columna a valores de hora
data2$created_at <- as.POSIXct(data2$created_at)
# Extraer hora, minutos y segundos
data2$created_at <- format(data2$created_at, format = "%H:%M:%S")
data2

# Ahora data2$hora_min_seg contendrá el formato de fecha y hora adecuado

data2
#--------------formato de valores modificado y listo------------------------------------------------------------------


#---codio para modificar los datos de la tabla --------------------#
##elimina las ultimas 3 filas de la tabla
data1 <- head(data1, -3)
data1
#elimina las primeras 5 filas de la tabla
data2 <- data2[37:nrow(data2), ]
data2

#------------------------------------------------------------------#


#codigo para graficar
library(ggplot2)

#field1 si quiero graficar CO2, field5 si quiero graficar presión
ggplot(data1, aes(x = created_at, y = field1)) +
  geom_point() +
  geom_line(colour="red") +
  labs(x = "Tiempo", y = "CO2 (ppm)", title = (paste0(archivo1, " - mediciones de CO2")))

ggplot(data2, aes(x = created_at, y = field1)) +
  geom_point() +
  geom_line(colour="blue") +
  labs(x = "Tiempo", y = "CO2 (ppm)", title = (paste0(archivo2, " - mediciones de CO2")))

ggplot() +
  geom_line(data = data1, aes(x = created_at, y = field1, color = "Medición 1"), size = 1) +
  geom_line(data = data2, aes(x = created_at, y = field1, color = "Medición 2"), size = 1) +
  labs(x = "Tiempo", y = "CO2 (ppm)", title = "Comparación de Mediciones") +
  scale_color_manual(values = c("Medición 1" = "blue", "Medición 2" = "red")) +
  guides(color = guide_legend(title = "Mediciones")) +
  theme_minimal()

