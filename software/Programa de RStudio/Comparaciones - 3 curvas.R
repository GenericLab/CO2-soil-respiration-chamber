install.packages("dplyr")

library(ggplot2)
library(dplyr)


#busca el directorio donde estan los archivos
setwd("C:/Users/mauri/Documents/Respiración/Datos")
getwd()

#define el nombre de los archivos .csv que vamos a utilizar
archivo1 <-"camara1"
archivo2 <-"camara2"


#abre el .csv que le pido
data1 = read.csv(paste0(archivo1,".csv"))
data2 = read.csv(paste0(archivo2,".csv"))
data3 = read.csv(paste0(archivo3,".csv"))


#---codigo para modificar los datos de la tabla --------------------#
##elimina las ultimas x filas de la tabla
data1 <- head(data1, )
data1
#elimina las primeras x filas de la tabla
data1 <- data1[52:nrow(data1), ]
data1
data1 <- data1 %>%
  slice(1:(2616 - 1))

#elimina las primeras x filas de la tabla
data2 <- data2[55:nrow(data2), ]
data2



#elimina las últimas x filas de la tabla
data2 <- data2 %>%
  slice(1:(2612 - 1))
#-------------------------------------------------------------------#

data1$created_at <- substr(data1$created_at, 1, nchar(data1$created_at) - 6)
data1$created_at <- paste(substr(data1$created_at, 1, 10), substr(data1$created_at, 12, nchar(data1$created_at)), sep = " ")
data1$created_at <- as.POSIXct(data1$created_at)
data1$tiempo_transcurrido <- difftime(data1$created_at, min(data1$created_at), units = "min")
data1

data2$created_at <- substr(data2$created_at, 1, nchar(data2$created_at) - 6)
data2$created_at <- paste(substr(data2$created_at, 1, 10), substr(data2$created_at, 12, nchar(data2$created_at)), sep = " ")
data2$created_at <- as.POSIXct(data2$created_at)
data2$tiempo_transcurrido <- difftime(data2$created_at, min(data2$created_at), units = "min")
data2


library(ggplot2)

ggplot(data1, aes(x = tiempo_transcurrido, y = field3)) +
  geom_point() +
  geom_line(colour="red") +
  labs(x = "Tiempo", y = "CO2 (ppm)", 
  title = "Cámara de Respiración [CO2]")+
  ggtitle("Cámara de Respiración [CO2]",
        subtitle = "Muestra OT1b Cámara 1")

ggplot(data2, aes(x = tiempo_transcurrido, y = field3)) +
  geom_point() +
  geom_line(colour="red") +
  labs(x = "Tiempo", y = "CO2 (ppm)", 
       title = "Cámara de Respiración [CO2]")+
  ggtitle("Cámara de Respiración [CO2]",
          subtitle = "Muestra OT2b Cámara 2")


#---suavizado-------------#
# Define el ancho de la ventana del promedio móvil (por ejemplo, 5 puntos)
ventana <- 50

# Calcula el promedio móvil en los datos de campo (field1)
data1$campo_suavizado <- zoo::rollapply(data1$field3, width = ventana, FUN = mean, align = "center", fill = NA)

# Crea un gráfico con la curva suavizada
library(ggplot2)
ggplot(data1, aes(x = tiempo_transcurrido, y = campo_suavizado)) +
  geom_line() +
  labs(x = "Tiempo (minutos)", y = "CO2 (ppm) suavizado", title = "Curva suavizada de CO2") +
  theme_minimal()

# Calcula el promedio móvil en los datos de campo (field1)
data1$campo_suavizado2 <- zoo::rollapply(data1$field4, width = ventana, FUN = mean, align = "center", fill = NA)

# Crea un gráfico con la curva suavizada

ggplot(data1, aes(x = tiempo_transcurrido, y = campo_suavizado2)) +
  geom_line() +
  labs(x = "Tiempo (minutos)", y = "CO2 (ppm) suavizado", title = "Curva suavizada de CO2") +
  theme_minimal()

# Calcula el promedio móvil en los datos de campo (field1)
data2$campo_suavizado <- zoo::rollapply(data2$field3, width = ventana, FUN = mean, align = "center", fill = NA)

# Crea un gráfico con la curva suavizada
ggplot(data2, aes(x = tiempo_transcurrido, y = campo_suavizado)) +
  geom_line() +
  labs(x = "Tiempo (minutos)", y = "CO2 (ppm) suavizado", title = "Curva suavizada de CO2") +
  theme_minimal()

# Calcula el promedio móvil en los datos de campo (field1)
data2$campo_suavizado2 <- zoo::rollapply(data2$field4, width = ventana, FUN = mean, align = "center", fill = NA)

# Crea un gráfico con la curva suavizada

ggplot(data2, aes(x = tiempo_transcurrido, y = campo_suavizado2)) +
  geom_line() +
  labs(x = "Tiempo (minutos)", y = "CO2 (ppm) suavizado", title = "Curva suavizada de CO2") +
  theme_minimal()

# Gráfico combinado de ambas mediciones
ggplot() +
  geom_line(data = data1, aes(x = tiempo_transcurrido, y = campo_suavizado, color = "Medición 28/11 (M1.r1)")) +
  geom_line(data = data1, aes(x = tiempo_transcurrido, y = campo_suavizado2, color ="Medición 28/11 (M1.r2)")) +
  geom_line(data = data2, aes(x = tiempo_transcurrido, y = campo_suavizado, color =  "Medición 28/11 (M2.r1)")) +
  geom_line(data = data2, aes(x = tiempo_transcurrido, y = campo_suavizado2, color = "Medición 28/11 (M2.r2)")) +
  labs(x = "Tiempo (minutos)", y = "CO2 (ppm)", title = "Comparación de Mediciones") +
  scale_color_manual(values = c("Medición 28/11 (M1.r1)" = "red", 
                                "Medición 28/11 (M1.r2)" = "black",
                                "Medición 28/11 (M2.r1)" = "blue",
                                "Medición 28/11 (M2.r2)" ="green"
  ))+
  guides(color = guide_legend(title = "Mediciones")) +
  theme_minimal()
