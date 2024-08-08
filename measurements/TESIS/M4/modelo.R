#Modelo lineal

# Ajustar un modelo lineal simple

modelo_lineal <- lm(campo_suavizado ~ tiempo_transcurrido, data = data1)

# Resumen del modelo


summary(modelo_lineal)

# Graficar la curva ajustada
ggplot(data1, aes(x = tiempo_transcurrido, y = campo_suavizado)) +
  geom_point() +
  geom_smooth(method = "lm", color = "red") +
  labs(x = "Tiempo Transcurrido", y = "Campo Suavizado 1", title = "Modelo Lineal Simple")

#Modelo No lineal
rm(list = ls())

data1$tiempo_transcurrido_numeric <- as.numeric(data1$tiempo_transcurrido)

modelo_no_lineal <- nls(campo_suavizado ~ a * exp(b * tiempo_transcurrido_numeric), data = data1, start = list(a = 1, b = 0.8))

# Resumen del modelo
summary(modelo_no_lineal)

# Graficar la curva ajustada
data1 <- data1 %>%
  mutate(predicted = predict(modelo_no_lineal, newdata = data1))

ggplot(data1, aes(x = tiempo_transcurrido, y = campo_suavizado)) +
  geom_point() +
  geom_line(aes(y = predicted), color = "green") +
  labs(x = "Tiempo Transcurrido", y = "Campo Suavizado 1", title = "Modelo No Lineal")


# Verificar los datos
summary(data1)

# Normalizar tiempo_transcurrido_numeric si es necesario
# data1$tiempo_transcurrido_numeric <- scale(data1$tiempo_transcurrido_numeric)

# Probar diferentes valores iniciales
modelo_no_lineal <- tryCatch({
  nls(campo_suavizado ~ a * exp(b * tiempo_transcurrido_numeric), 
      data = data1, start = list(a = 1, b = 0.1))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_no_lineal)) {
  # Resumen del modelo
  summary(modelo_no_lineal)
  
# Probar diferentes valores iniciales
modelo_no_lineal <- tryCatch({
  nls(campo_suavizado ~ a * exp(b * tiempo_transcurrido_numeric), 
      data = data1, start = list(a = 10, b = 0.01))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_no_lineal)) {
  # Resumen del modelo
  summary(modelo_no_lineal)
  
  # Generar predicciones
  data1 <- data1 %>%
    mutate(predicted = predict(modelo_no_lineal, newdata = data1))
  
  # Graficar los datos originales y la curva ajustada
  ggplot(data1, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "green") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo No Lineal")
} else {
  message("El modelo no pudo converger con los valores iniciales proporcionados.")
}

  
  # Generar predicciones
  data1 <- data1 %>%
    mutate(predicted = predict(modelo_no_lineal, newdata = data1))
  
  # Graficar los datos originales y la curva ajustada
  ggplot(data1, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "green") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo No Lineal")
} else {
  message("El modelo no pudo converger con los valores iniciales proporcionados.")
}

# Probar diferentes valores iniciales
modelo_no_lineal <- tryCatch({
  nls(campo_suavizado ~ a * exp(b * tiempo_transcurrido_numeric), 
      data = data1, start = list(a = 10, b = 0.01))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_no_lineal)) {
  # Resumen del modelo
  summary(modelo_no_lineal)
  
  # Generar predicciones
  data1 <- data1 %>%
    mutate(predicted = predict(modelo_no_lineal, newdata = data1))
  
  # Graficar los datos originales y la curva ajustada
  ggplot(data1, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "green") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo No Lineal")
} else {
  message("El modelo no pudo converger con los valores iniciales proporcionados.")
}

# Probar diferentes valores iniciales
modelo_no_lineal <- tryCatch({
  nls(campo_suavizado ~ a * exp(b * tiempo_transcurrido_numeric), 
      data = data1, start = list(a = 10, b = 0.01))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_no_lineal)) {
  # Resumen del modelo
  summary(modelo_no_lineal)
  
  # Generar predicciones
  data1 <- data1 %>%
    mutate(predicted = predict(modelo_no_lineal, newdata = data1))
  
  # Graficar los datos originales y la curva ajustada
  ggplot(data1, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "green") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo No Lineal")
} else {
  message("El modelo no pudo converger con los valores iniciales proporcionados.")
}
# Normalizar tiempo_transcurrido_numeric
data1$tiempo_transcurrido_numeric <- scale(data1$tiempo_transcurrido_numeric)

# Reajustar el modelo con valores iniciales ajustados
modelo_no_lineal <- tryCatch({
  nls(campo_suavizado ~ a * exp(b * tiempo_transcurrido_numeric), 
      data = data1, start = list(a = 1, b = 0.1))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_no_lineal)) {
  # Resumen del modelo
  summary(modelo_no_lineal)
  
  # Generar predicciones
  data1 <- data1 %>%
    mutate(predicted = predict(modelo_no_lineal, newdata = data1))
  
  # Graficar los datos originales y la curva ajustada
  ggplot(data1, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "green") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo No Lineal")
} else {
  message("El modelo no pudo converger con los valores iniciales proporcionados.")
}


############3

# Normalizar tiempo_transcurrido_numeric
data1$tiempo_transcurrido_numeric <- scale(data1$tiempo_transcurrido_numeric)

# Reajustar el modelo con valores iniciales ajustados
modelo_no_lineal <- tryCatch({
  nls(campo_suavizado ~ a * exp(b * tiempo_transcurrido_numeric), 
      data = data1, start = list(a = 1, b = 0.1))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_no_lineal)) {
  # Resumen del modelo
  summary(modelo_no_lineal)
  
  # Generar predicciones
  data1 <- data1 %>%
    mutate(predicted = predict(modelo_no_lineal, newdata = data1))
  
  # Graficar los datos originales y la curva ajustada
  ggplot(data1, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "green") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo No Lineal")
} else {
  message("El modelo no pudo converger con los valores iniciales proporcionados.")
}

# Ajustar un modelo polinómico de segundo grado
modelo_polinomico <- lm(campo_suavizado ~ poly(tiempo_transcurrido_numeric, 2), data = data1)

# Resumen del modelo
summary(modelo_polinomico)

# Generar predicciones
data1 <- data1 %>%
  mutate(predicted = predict(modelo_polinomico, newdata = data1))

# Graficar los datos originales y la curva ajustada
ggplot(data1, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
  geom_point() +
  geom_line(aes(y = predicted), color = "blue") +
  labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo Polinómico de Segundo Grado")


##########


library(dplyr)
library(ggplot2)

# Convertir tiempo_transcurrido a un tipo numérico si no se ha hecho
data1$tiempo_transcurrido_numeric <- as.numeric(data1$tiempo_transcurrido)

# Ajustar un modelo no lineal de la forma campo_suavizado = a * tiempo_transcurrido_numeric^b
modelo_no_lineal <- tryCatch({
  nls(campo_suavizado ~ a * tiempo_transcurrido_numeric^b, 
      data = data1, start = list(a = 1, b = 2))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_no_lineal)) {
  # Resumen del modelo
  summary(modelo_no_lineal)
  
  # Generar predicciones
  data1 <- data1 %>%
    mutate(predicted = predict(modelo_no_lineal, newdata = data1))
  
  # Graficar los datos originales y la curva ajustada
  ggplot(data1, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "blue") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo No Lineal: a * tiempo_transcurrido_numeric^b")
} else {
  message("El modelo no pudo converger con los valores iniciales proporcionados.")
}

# Verificar valores faltantes o infinitos
summary(data1)
any(is.na(data1$campo_suavizado))
any(is.na(data1$tiempo_transcurrido_numeric))
any(is.infinite(data1$campo_suavizado))
any(is.infinite(data1$tiempo_transcurrido_numeric))

# Eliminar filas con valores faltantes o infinitos
data1 <- data1 %>%
  filter(!is.na(campo_suavizado) & !is.na(tiempo_transcurrido_numeric) & 
           !is.infinite(campo_suavizado) & !is.infinite(tiempo_transcurrido_numeric))
# Probar diferentes valores iniciales
modelo_no_lineal <- tryCatch({
  nls(campo_suavizado ~ a * tiempo_transcurrido_numeric^b, 
      data = data1, start = list(a = 1, b = 1))
}, error = function(e) {
  message("Error: ", e)
  NULL
})
modelo_no_lineal <- tryCatch({
  nls(campo_suavizado ~ a * tiempo_transcurrido_numeric^b, 
      data = data1, start = list(a = 10, b = 0.5))
}, error = function(e) {
  message("Error: ", e)
  NULL
})
# Transformar los datos
data1 <- data1 %>%
  mutate(log_campo_suavizado = log(campo_suavizado + 1),  # Agregar 1 para evitar log(0)
         log_tiempo_transcurrido_numeric = log(tiempo_transcurrido_numeric + 1))

# Ajustar un modelo logarítmico
modelo_logaritmico <- tryCatch({
  nls(log_campo_suavizado ~ log_a + b * log_tiempo_transcurrido_numeric, 
      data = data1, start = list(log_a = log(1), b = 1))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_logaritmico)) {
  # Resumen del modelo
  summary(modelo_logaritmico)
  
  # Generar predicciones
  data1 <- data1 %>%
    mutate(predicted_log = predict(modelo_logaritmico, newdata = data1),
           predicted = exp(predicted_log) - 1)  # Convertir de vuelta a la escala original
  
  # Graficar los datos originales y la curva ajustada
  ggplot(data1, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "blue") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo Logarítmico Ajustado")
} else {
  message("El modelo logarítmico no pudo converger con los valores iniciales proporcionados.")
}
##########################


library(dplyr)
library(ggplot2)

# Convertir tiempo_transcurrido a un tipo numérico si no se ha hecho
data1$tiempo_transcurrido_numeric <- as.numeric(data1$tiempo_transcurrido)

# Verificar y limpiar los datos
data1 <- data1 %>%
  filter(!is.na(campo_suavizado) & !is.na(tiempo_transcurrido_numeric) & 
           !is.infinite(campo_suavizado) & !is.infinite(tiempo_transcurrido_numeric))

# Transformar los datos para ajuste exponencial
data1 <- data1 %>%
  mutate(log_campo_suavizado = log(campo_suavizado + 1))  # Agregar 1 para evitar log(0)

# Ajustar el modelo exponencial
modelo_exponencial <- tryCatch({
  nls(log_campo_suavizado ~ log_a * exp( b * tiempo_transcurrido_numeric), 
      data = data1, start = list(log_a = log(1), b = 0.1))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_exponencial)) {
  # Resumen del modelo
  summary(modelo_exponencial)
  
  # Generar predicciones
  data1 <- data1 %>%
    mutate(predicted_log = predict(modelo_exponencial, newdata = data1),
           predicted = exp(predicted_log) - 1)  # Convertir de vuelta a la escala original
  
  # Graficar los datos originales y la curva ajustada
  ggplot(data1, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "blue") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo Exponencial Ajustado")
} else {
  message("El modelo exponencial no pudo converger con los valores iniciales proporcionados.")
}

modelo_exponencial <- tryCatch({
  nls(campo_suavizado ~ a * exp(b * tiempo_transcurrido_numeric), 
      data = data1, start = list(a = 1, b = 0.1))
}, error = function(e) {
  message("Error: ", e)
  NULL
})
if (!is.null(modelo_exponencial)) {
  # Resumen del modelo
  summary(modelo_exponencial)
  
  # Generar predicciones
  data1 <- data1 %>%
    mutate(predicted = predict(modelo_exponencial, newdata = data1))
  
  # Graficar los datos originales y la curva ajustada
  ggplot(data1, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "blue") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo Exponencial Ajustado")
} else {
  message("El modelo exponencial no pudo converger con los valores iniciales proporcionados.")
}
##########################################33
library(dplyr)
library(ggplot2)

# Lista de datos
data_frames <- list(data1, data2, data3, data4, data5, data6, data7, data8, data9)

# Combinar los datos
combined_data <- bind_rows(data_frames, .id = "source") %>%
  mutate(source = factor(source, levels = 1:9, labels = paste0("Muestra ", 1:9)))

# Asegúrate de que tiempo_transcurrido está en formato numérico
combined_data <- combined_data %>%
  mutate(tiempo_transcurrido_numeric = as.numeric(tiempo_transcurrido))

# Ajustar el modelo exponencial
modelo_exponencial_combinado <- tryCatch({
  nls(campo_suavizado ~ a * exp(b * tiempo_transcurrido_numeric), 
      data = combined_data, start = list(a = 1, b = 0.1))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_exponencial_combinado)) {
  # Resumen del modelo
  summary(modelo_exponencial_combinado)
  
  # Generar predicciones
  combined_data <- combined_data %>%
    mutate(predicted = predict(modelo_exponencial_combinado, newdata = combined_data))
  
  # Graficar los datos originales y la curva ajustada
  ggplot(combined_data, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado, color = source)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "blue") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo Exponencial Ajustado con Datos Combinados") +
    theme_minimal()
} else {
  message("El modelo exponencial no pudo converger con los valores iniciales proporcionados.")
}

# Transformar los datos para ajuste exponencial
combined_data <- combined_data %>%
  filter(campo_suavizado > 0) %>%  # Asegurarse de que todos los valores de campo_suavizado sean positivos
  mutate(log_campo_suavizado = log(campo_suavizado))

# Ajustar el modelo lineal a los datos transformados
modelo_lineal_log <- tryCatch({
  nls(log_campo_suavizado ~ log_a + b * tiempo_transcurrido_numeric, 
      data = combined_data, start = list(log_a = log(1), b = 0.1))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_lineal_log)) {
  # Resumen del modelo
  summary(modelo_lineal_log)
  
  # Generar predicciones
  combined_data <- combined_data %>%
    mutate(predicted_log = predict(modelo_lineal_log, newdata = combined_data),
           predicted = exp(predicted_log))  # Convertir de vuelta a la escala original
  
  # Graficar los datos originales y la curva ajustada
  ggplot(combined_data, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "blue") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo Exponencial Ajustado con Datos Combinados (Transformación Logarítmica)") +
    theme_minimal()
} else {
  message("El modelo logarítmico no pudo converger con los valores iniciales proporcionados.")
}

####################
library(dplyr)
library(ggplot2)

# Asegurarse de que tiempo_transcurrido está en formato numérico
combined_data <- combined_data %>%
  mutate(tiempo_transcurrido_numeric = as.numeric(tiempo_transcurrido))

# Filtrar valores positivos para el ajuste
combined_data <- combined_data %>%
  filter(campo_suavizado > 0) %>%
  mutate(log_campo_suavizado = log(campo_suavizado))

# Ajustar el modelo lineal a los datos transformados
modelo_lineal_log <- tryCatch({
  nls(log_campo_suavizado ~ log_a + b * tiempo_transcurrido_numeric, 
      data = combined_data, start = list(log_a = log(1), b = 0.1))
}, error = function(e) {
  message("Error: ", e)
  NULL
})

if (!is.null(modelo_lineal_log)) {
  # Resumen del modelo
  summary(modelo_lineal_log)
  
  # Generar predicciones
  combined_data <- combined_data %>%
    mutate(predicted_log = predict(modelo_lineal_log, newdata = combined_data),
           predicted = exp(predicted_log))  # Convertir de vuelta a la escala original
  
  # Graficar los datos originales y la curva ajustada
  ggplot(combined_data, aes(x = tiempo_transcurrido_numeric, y = campo_suavizado)) +
    geom_point() +
    geom_line(aes(y = predicted), color = "blue") +
    labs(x = "Tiempo Transcurrido", y = "Campo Suavizado", title = "Modelo Exponencial Ajustado con Datos Combinados (Transformación Logarítmica)") +
    theme_minimal()
} else {
  message("El modelo logarítmico no pudo converger con los valores iniciales proporcionados.")
}

###############################################################################3333

###########

###########MODELO DE RESPIRACIÓN##########


---
title: "CRS-2024"
author: "Nano Castro"
date: "2024-01-27"
output: html_document
---
  
```{r setup, include=FALSE}
knitr::opts_chunk$set(echo = TRUE)
```


```{r datos}
library(tidyverse)
library(lubridate)
setwd("C:/Users/mauri/Documents/Respiración/Datos/M4")

rm(list = ls())
archivo1 <-"M4C1R1"
data1 = read.csv(paste0(archivo1,".csv"))
crs_crudos<-read.csv("data1")
crs_crudos<-crs_crudos[1:9]
colnames(data1)<-c("Time","ID","Temp","Presion","CO2","HR","T2","field6","Altura")
data1$Time<-ymd_hms(data1$Time, tz="America/Buenos_Aires")
# str(crs_crudos)

```

```{r simple_plot}
library(hrbrthemes)
# plot
data1%>% 
  ggplot( aes(x=Time, y=CO2)) +
  geom_line(color="#69b3a2") +
  #annotate(geom="text", x=as.Date("2017-01-01"), y=20089, 
  #         label="Bitcoin price reached 20k $\nat the end of 2017") +
  #annotate(geom="point", x=as.Date("2017-12-17"), y=20089, size=10, shape=21, fill="transparent") +
  geom_hline(yintercept=5000, color="orange", linewidth=.5) +
  scale_x_datetime(breaks="2 hour",date_labels="%H")+
  # geom_smooth()+
  theme_ipsum()

# Tiempo en el que inicia el test (cuando cerramos la tapa)
start_time=as.POSIXct("2024-01-25 13:10:00")
# Tiempo en el que llega al máximo (se elige la primera vez que llega al valor máximo de CO2)
max<-subset(data1, data1$CO2==max(data1$CO2, na.rm=TRUE))
asympt_time<-min(max$Time)
data1_resp<-subset(data1, Time>=start_time & Time<=asympt_time)
# test_time<-hours(6)
# short_time<-start_time + test_time
# crs_crudos_resp<-subset(crs_crudos, Time>=start_time & Time<=short_time)
# crs_crudos_resp_tot<-subset(crs_crudos, Time>=asympt_time)


# crs_crudos_resp%>% 
#   ggplot( aes(x=Time, y=CO2)) +
#     geom_line(color="#69b3a2") +
#     #annotate(geom="text", x=as.Date("2017-01-01"), y=20089, 
#     #         label="Bitcoin price reached 20k $\nat the end of 2017") +
#     #annotate(geom="point", x=as.Date("2017-12-17"), y=20089, size=10, shape=21, fill="transparent") +
# #    geom_hline(yintercept=5000, color="orange", linewidth=.5) +
#     scale_x_datetime(breaks="2 hour",date_labels="%H")+
#     #geom_smooth()+
#     theme_ipsum()

```

[Regresion no lineal](https://tuos-bio-data-skills.github.io/intro-stats-book/non-linear-regression-in-R.html)
[Modelos](https://www.statforbiology.com/nonlinearregression/usefulequations#asymptotic_regression_model)
          
```{r model}

##TIEMPO##

data1$Time <- substr(data1$Time, 1, nchar(data1$Time) - 6)
data1$Time <- paste(substr(data1$Time, 1, 10), substr(data1$Time, 12, nchar(data1$Time)), sep = " ")
data1$Time <- as.POSIXct(data1$Time)
data1$tiempo_transcurrido <- difftime(data1$Time, min(data1$Time), units = "min")
data1

          
library(drc)
library(dplyr)

#data1<-mutate(data1,elapsed=as.numeric(Time - first(Time), units = "mins"))
data1_resp<- data1_resp %>% drop_na(tiempo_transcurrido, campo_suavizado)

data1_resp<-mutate(data1_resp,elapsed=as.numeric(Time - first(Time), units = "mins"))

fm1 <- nls(CO2 ~ SSasymp(elapsed, Asym,resp0,lrc),data=data1)
summary(fm1)
crs_model<-data.frame(predict(fm1,crs_crudos_resp$elapsed))
crs_model<-mutate(crs_model,elapsed=crs_crudos_resp$elapsed)
colnames(crs_model)=c("CO2","elapsed")
crs_crudos_resp<-mutate(crs_crudos_resp,model=crs_model$CO2)
          
ggplot(crs_crudos_resp, aes(x = elapsed, y = CO2)) + 
  geom_point(color="#69b3a2") + geom_line(data = crs_model,color="red") +
  xlab("Elapsed time (min)") + ylab("CO2 (ppm)") + 
  theme_bw(base_size = 10)
          
  crs_diff<-mutate(crs_crudos_resp,differencia=CO2-model)
          
          
  ggplot(crs_diff, aes(x = elapsed, y = differencia)) + 
  geom_line(color="red") +
  xlab("Elapsed time (min)") + ylab("Diferencia CO2 (ppm)") + 
  theme_bw(base_size = 10)
          
          ```
          
          ```{r model_tot}
          
          crs_crudos_resp_tot<-mutate(crs_crudos_resp_tot,elapsed=as.numeric(Time - first(Time), units = "mins"))
          fm1 <- nls(CO2 ~ SSasymp(elapsed, Asym,resp0,lrc),data=crs_crudos_resp_tot)
          summary(fm1)
          crs_model<-data.frame(predict(fm1,crs_crudos_resp_tot$elapsed))
          crs_model<-mutate(crs_model,elapsed=crs_crudos_resp_tot$elapsed)
          colnames(crs_model)=c("CO2","elapsed")
          crs_crudos_resp_tot<-mutate(crs_crudos_resp_tot,model=crs_model$CO2)
          
          ggplot(crs_crudos_resp_tot, aes(x = elapsed, y = CO2)) + 
            geom_point(color="#69b3a2") + geom_line(data = crs_model,color="red") +
            xlab("Elapsed time (min)") + ylab("CO2 (ppm)") + 
            theme_bw(base_size = 10)
          
          
          ```
          
          ```{r model_xts}
          library(xts)
          library(dygraphs)
          rm(crs_crudos_xts)
          crs_crudos_xts<-as.xts(crs_crudos[,c(1,3,5)])
          
          dygraph(crs_crudos_xts) %>%
            dySeries("CO2", label = "CO2 (ppm)") %>%
            dySeries("Temp", label="Temp (°C)",axis = 'y2')%>% 
            dyRangeSelector()
          
          
          ```
          