install.packages("aomisc")

install.packages("dplyr")
install.packages("broom")

library(dplyr)
library(broom)


library(drc)
library(nlme)
library(aomisc)
library(ggplot2)
library(dplyr)
library(tidyr)

setwd("C:/Users/mauri/Documents/Respiración/Datos/M6")


#define el nombre de los archivos .csv que vamos a utilizar
archivo1 <-"M6C1R1"
archivo2 <-"M6C2R2"
archivo3 <-"M6C3R3"
#archivo4 <-"M5C2R11"
#archivo5 <-"M5C2R5"
#archivo6 <-"M5C3R6"
#archivo7 <-"M5C3R12"
#archivo8 <-"M5C2R8"
#archivo9 <-"M5C3R9"

#abre el .csv que le pido
data1 = read.csv(paste0(archivo1,".csv"))
data2 = read.csv(paste0(archivo2,".csv"))
data3 = read.csv(paste0(archivo3,".csv"))
#data4 = read.csv(paste0(archivo4,".csv"))
#data5 = read.csv(paste0(archivo5,".csv"))
#data6 = read.csv(paste0(archivo6,".csv"))
#data7 = read.csv(paste0(archivo7,".csV"))
#data8 = read.csv(paste0(archivo8,".csV"))
#data9 = read.csv(paste0(archivo9,".csV"))

#elimina las primeras x filas de la tabla


data1 <- data1[16:nrow(data1), ]
data1

data2 <- data2[8:nrow(data2), ]
data2

data3 <- data3[11:nrow(data3), ]
data3

#Cambiar nombres#

colnames(data1)<-c("Time","ID","Temp","Presion","CO2","HR","T2","field6","Altura")
colnames(data2)<-c("Time","ID","Temp","Presion","CO2","HR","T2","field6","Altura")
colnames(data3)<-c("Time","ID","Temp","Presion","CO2","HR","T2","field6","Altura")
#colnames(data4)<-c("Time","ID","Temp","Presion","CO2","HR","T2","field6","Altura")
#colnames(data5)<-c("Time","ID","Temp","Presion","CO2","HR","T2","field6","Altura")
#colnames(data6)<-c("Time","ID","Temp","Presion","CO2","HR","T2","field6","Altura")
#colnames(data7)<-c("Time","ID","Temp","Presion","CO2","HR","T2","field6","Altura")
#colnames(data8)<-c("Time","ID","Temp","Presion","CO2","HR","T2","field6","Altura")
#colnames(data9)<-c("Time","ID","Temp","Presion","CO2","HR","T2","field6","Altura")


#Tiempo#

data1$Time <- substr(data1$Time, 1, nchar(data1$Time) - 6)
data1$Time <- paste(substr(data1$Time, 1, 10), substr(data1$Time, 12, nchar(data1$Time)), sep = " ")
data1$Time <- as.POSIXct(data1$Time)
data1$tiempo_transcurrido <- difftime(data1$Time, min(data1$Time), units = "min")
data1

data2$Time <- substr(data2$Time, 1, nchar(data2$Time) - 6)
data2$Time <- paste(substr(data2$Time, 1, 10), substr(data2$Time, 12, nchar(data2$Time)), sep = " ")
data2$Time <- as.POSIXct(data2$Time)
data2$tiempo_transcurrido <- difftime(data2$Time, min(data2$Time), units = "min")
data2

data3$Time <- substr(data3$Time, 1, nchar(data3$Time) - 6)
data3$Time <- paste(substr(data3$Time, 1, 10), substr(data3$Time, 12, nchar(data3$Time)), sep = " ")
data3$Time <- as.POSIXct(data3$Time)
data3$tiempo_transcurrido <- difftime(data3$Time, min(data3$Time), units = "min")
data3

data4$Time <- substr(data4$Time, 1, nchar(data4$Time) - 6)
data4$Time <- paste(substr(data4$Time, 1, 10), substr(data4$Time, 12, nchar(data4$Time)), sep = " ")
data4$Time <- as.POSIXct(data4$Time)
data4$tiempo_transcurrido <- difftime(data4$Time, min(data4$Time), units = "min")
data4

data5$Time <- substr(data5$Time, 1, nchar(data5$Time) - 6)
data5$Time <- paste(substr(data5$Time, 1, 10), substr(data5$Time, 12, nchar(data5$Time)), sep = " ")
data5$Time <- as.POSIXct(data5$Time)
data5$tiempo_transcurrido <- difftime(data5$Time, min(data5$Time), units = "min")
data5

data6$Time <- substr(data6$Time, 1, nchar(data6$Time) - 6)
data6$Time <- paste(substr(data6$Time, 1, 10), substr(data6$Time, 12, nchar(data6$Time)), sep = " ")
data6$Time <- as.POSIXct(data6$Time)
data6$tiempo_transcurrido <- difftime(data6$Time, min(data6$Time), units = "min")
data6

data7$Time <- substr(data7$Time, 1, nchar(data7$Time) - 6)
data7$Time <- paste(substr(data7$Time, 1, 10), substr(data7$Time, 12, nchar(data7$Time)), sep = " ")
data7$Time <- as.POSIXct(data7$Time)
data7$tiempo_transcurrido <- difftime(data7$Time, min(data7$Time), units = "min")
data7

data8$Time <- substr(data8$Time, 1, nchar(data8$Time) - 6)
data8$Time <- paste(substr(data8$Time, 1, 10), substr(data8$Time, 12, nchar(data8$Time)), sep = " ")
data8$Time <- as.POSIXct(data8$Time)
data8$tiempo_transcurrido <- difftime(data8$Time, min(data8$Time), units = "min")
data8

data9$Time <- substr(data9$Time, 1, nchar(data9$Time) - 6)
data9$Time <- paste(substr(data9$Time, 1, 10), substr(data9$Time, 12, nchar(data9$Time)), sep = " ")
data9$Time <- as.POSIXct(data9$Time)
data9$tiempo_transcurrido <- difftime(data9$Time, min(data9$Time), units = "min")
data9
# Convertir tiempo_transcurrido a numérico (en minutos)
data1$tiempo_transcurrido_numeric <- as.numeric(data1$tiempo_transcurrido, units = "mins")
data2$tiempo_transcurrido_numeric <- as.numeric(data2$tiempo_transcurrido, units = "mins")
data3$tiempo_transcurrido_numeric <- as.numeric(data3$tiempo_transcurrido, units = "mins")
data4$tiempo_transcurrido_numeric <- as.numeric(data4$tiempo_transcurrido, units = "mins")
data5$tiempo_transcurrido_numeric <- as.numeric(data5$tiempo_transcurrido, units = "mins")
data6$tiempo_transcurrido_numeric <- as.numeric(data6$tiempo_transcurrido, units = "mins")
data7$tiempo_transcurrido_numeric <- as.numeric(data7$tiempo_transcurrido, units = "mins")
data8$tiempo_transcurrido_numeric <- as.numeric(data8$tiempo_transcurrido, units = "mins")
data9$tiempo_transcurrido_numeric <- as.numeric(data9$tiempo_transcurrido, units = "mins")


#TiempovsCO2"
nuevo_data1 <- data1 %>%
  dplyr::select(tiempo_transcurrido_numeric, CO2) %>%
  filter(!is.na(tiempo_transcurrido_numeric) & !is.na(CO2))

nuevo_data2 <- data2 %>%
  dplyr::select(tiempo_transcurrido_numeric, CO2) %>%
  filter(!is.na(tiempo_transcurrido_numeric) & !is.na(CO2))

nuevo_data3 <- data3 %>%
  dplyr::select(tiempo_transcurrido_numeric, CO2) %>%
  filter(!is.na(tiempo_transcurrido_numeric) & !is.na(CO2))
nuevo_data4 <- data6 %>%
  dplyr::select(tiempo_transcurrido_numeric, CO2) %>%
  filter(!is.na(tiempo_transcurrido_numeric) & !is.na(CO2))
nuevo_data5 <- data8 %>%
  dplyr::select(tiempo_transcurrido_numeric, CO2) %>%
  filter(!is.na(tiempo_transcurrido_numeric) & !is.na(CO2))
nuevo_data6 <- data9 %>%
  dplyr::select(tiempo_transcurrido_numeric, CO2) %>%
  filter(!is.na(tiempo_transcurrido_numeric) & !is.na(CO2))

nuevo_data7 <- data2 %>%
  dplyr::select(tiempo_transcurrido_numeric, CO2) %>%
  filter(!is.na(tiempo_transcurrido_numeric) & !is.na(CO2))

nuevo_data8 <- data4 %>%
  dplyr::select(tiempo_transcurrido_numeric, CO2) %>%
  filter(!is.na(tiempo_transcurrido_numeric) & !is.na(CO2))

nuevo_data9 <- data7 %>%
  dplyr::select(tiempo_transcurrido_numeric, CO2) %>%
  filter(!is.na(tiempo_transcurrido_numeric) & !is.na(CO2))


# Crear una lista con los dataframes
dataframes <- list(nuevo_data1, nuevo_data2, nuevo_data3)

# Renombrar las columnas CO2 en cada dataframe
for (i in 1:length(dataframes)) {
  colnames(dataframes[[i]])[which(names(dataframes[[i]]) == "CO2")] <- paste0("CO2_", i)
}

# Asignar los dataframes renombrados de vuelta a las variables originales
nuevo_data1 <- dataframes[[1]]
nuevo_data2 <- dataframes[[2]]
nuevo_data3 <- dataframes[[3]]
nuevo_data4 <- dataframes[[4]]
nuevo_data5 <- dataframes[[5]]
nuevo_data6 <- dataframes[[6]]
nuevo_data7 <- dataframes[[7]]
nuevo_data8 <- dataframes[[8]]
nuevo_data9 <- dataframes[[9]]



#########################interpolar tiempo############33

# Combinar los tiempos en un solo rango de tiempos
tiempos_combinados <- sort(unique(unlist(lapply(dataframes, function(df) df$tiempo_transcurrido_numeric))))

# Interpolar los valores de CO2 para cada dataframe en los tiempos combinados
CO2_interpolados <- lapply(dataframes, function(df) {
  approx(df$tiempo_transcurrido_numeric, df[[2]], xout = tiempos_combinados)$y
})

# Crear el dataframe combinado
combined_data <- data.frame(tiempo_transcurrido_numeric = tiempos_combinados)

for (i in 1:length(CO2_interpolados)) {
  combined_data[[paste0("CO2_", i)]] <- CO2_interpolados[[i]]
}

# Verificar el resultado
head(combined_data)

library(ggplot2)

# Definir los colores para cada serie de CO2
colors <- c(
  "CO2_1" = "blue", "CO2_2" = "red", "CO2_3" = "green"
)

# Crear el gráfico
ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
  geom_line(aes(y = CO2_1, color = "CO2_1"), size = 1) +
  geom_line(aes(y = CO2_2, color = "CO2_2"), size = 1) +
  geom_line(aes(y = CO2_3, color = "CO2_3"), size = 1) +
  #geom_line(aes(y = CO2_4, color = "CO2_4"), size = 1) +
  #geom_line(aes(y = CO2_5, color = "CO2_5"), size = 1) +
  #geom_line(aes(y = CO2_6, color = "CO2_6"), size = 1) +
  #geom_line(aes(y = CO2_7, color = "CO2_7"), size = 1) +
  #geom_line(aes(y = CO2_8, color = "CO2_8"), size = 1) +
  #geom_line(aes(y = CO2_9, color = "CO2_9"), size = 1) +
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Curvas de CO2 en función del Tiempo",
    color = "Leyenda"
  ) +
  theme_minimal() +
  scale_color_manual(values = colors)



combined_data<- head(combined_data, 5344)


#############Valores inicaiales########3



combined_data$CO2_1 <- combined_data$CO2_1 +14
combined_data$CO2_2 <- combined_data$CO2_2 - 8
combined_data$CO2_3 <- combined_data$CO2_3 - 141
combined_data$CO2_4 <- combined_data$CO2_4 - 1
combined_data$CO2_5 <- combined_data$CO2_5 + 33
combined_data$CO2_6 <- combined_data$CO2_6 - 9
combined_data$CO2_7 <- combined_data$CO2_7 + 6
combined_data$CO2_8 <- combined_data$CO2_8 - 5
combined_data$CO2_9 <- combined_data$CO2_9 - 14




#####################CODIGO BIEN#################


# Instalar y cargar paquetes necesarios
if (!requireNamespace("dplyr", quietly = TRUE)) install.packages("dplyr")
if (!requireNamespace("ggplot2", quietly = TRUE)) install.packages("ggplot2")
if (!requireNamespace("minpack.lm", quietly = TRUE)) install.packages("minpack.lm")

library(dplyr)

library(ggplot2)
library(minpack.lm)

# Ajustar el modelo de respiración de suelo y graficar para cada conjunto de datos CO2_1 a CO2_6

# Crear una lista para almacenar los resultados
resultados <- list()

for (i in 1:3) {
  # Crear el nombre de las columnas dinámicamente
  col_CO2 <- paste0("CO2_", i)
  pred_CO2 <- paste0("predicted_CO2_", i)
  
  # Ajustar el modelo de respiración de suelo
  modelo_respiracion <- tryCatch({
    nlsLM(as.formula(paste(col_CO2, "~400+ a * (tiempo_transcurrido_numeric / (b + tiempo_transcurrido_numeric))")),
          data = combined_data, 
          start = list(a = max(combined_data[[col_CO2]]), b = median(combined_data$tiempo_transcurrido_numeric)))
  }, error = function(e) {
    message("Error al ajustar el modelo de respiración de suelo para ", col_CO2, ": ", e)
    NULL
  })
  
  #######R2######
  
  # Crear una lista para almacenar los resultados
  resultados <- list()
  
  for (i in 1:3) {
    # Crear el nombre de las columnas dinámicamente
    col_CO2 <- paste0("CO2_", i)
    pred_CO2 <- paste0("predicted_CO2_", i)
    
    # Ajustar el modelo de respiración de suelo
    modelo_respiracion <- tryCatch({
      nlsLM(as.formula(paste(col_CO2, "~400 + a * (tiempo_transcurrido_numeric / (b + tiempo_transcurrido_numeric))")),
            data = combined_data, 
            start = list(a = max(combined_data[[col_CO2]]), b = median(combined_data$tiempo_transcurrido_numeric)))
    }, error = function(e) {
      message("Error al ajustar el modelo de respiración de suelo para ", col_CO2, ": ", e)
      NULL
    })
    
    # Si el modelo se ajusta correctamente, calcular el R^2
    if (!is.null(modelo_respiracion)) {
      # Predicciones del modelo
      predicciones <- predict(modelo_respiracion)
      
      # Valores observados
      valores_observados <- combined_data[[col_CO2]]
      
      # Media de los valores observados
      media_observados <- mean(valores_observados)
      
      # Suma de cuadrados totales (SST)
      SST <- sum((valores_observados - media_observados)^2)
      
      # Suma de cuadrados residuales (SSR)
      SSR <- sum((valores_observados - predicciones)^2)
      
      # Cálculo de R^2
      R2 <- 1 - (SSR / SST)
      
      # Almacenar el modelo y el R^2 en la lista de resultados
      resultados[[col_CO2]] <- list(modelo = modelo_respiracion, R2 = R2)
      
      # Imprimir el R^2 para cada modelo
      print(paste("R^2 para", col_CO2, ":", R2))
    } else {
      # Si el modelo no se ajusta, almacenar NULL en la lista de resultados
      resultados[[col_CO2]] <- NULL
    }
  }
  
  # La lista 'resultados' ahora contiene los modelos y sus R^2 correspondientes
  

  resultados
  
  
  
    
  # Extraer los valores de R² y nombres de columnas
  r2_values <- sapply(resultados, function(x) x$R2)
  
  # Crear un data frame con los resultados
  r2_df <- data.frame(
    Columna = names(r2_values),
    R2 = r2_values,
    stringsAsFactors = FALSE
  )
  
  # Mostrar la tabla
  print(r2_df)
  

  # Verificar si el modelo se ajustó correctamente
  if (!is.null(modelo_respiracion)) {
    # Predecir valores con el modelo ajustado
    combined_data[[pred_CO2]] <- predict(modelo_respiracion, newdata = combined_data)
    
    # Almacenar los resultados
    resultados[[i]] <- list(
      modelo = modelo_respiracion,
      predicciones = combined_data %>%
        mutate(tiempo_transcurrido_numeric, all_of(col_CO2), all_of(pred_CO2))
    )
    
    # Crear gráfico con los datos y el modelo ajustado
    p <- ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
      geom_point(aes(y = .data[[col_CO2]]), color = "blue") +
      geom_line(aes(y = .data[[pred_CO2]]), color = "red", linetype = "dashed") +
      labs(
        x = "Tiempo Transcurrido (s)",
        y = "CO2",
        title = paste("Modelo de Respiración de Suelo Ajustado para", col_CO2),
        color = "Leyenda"
      ) +
      theme_minimal() +
      scale_color_manual(values = c("Datos Reales" = "blue", "Predicción" = "red"))
    
    # Imprimir el gráfico
    print(p)
  } else {
    message("El modelo no se ajustó correctamente para ", col_CO2, ".")
  }
}


===============
  
  # Cargar las librerías necesarias
  
library(minpack.lm)


library(dplyr)
library(ggplot2)

# Supongo que tienes el dataframe combined_data definido
resultados <- list()

for (i in 1:3) {
  # Crear el nombre de las columnas dinámicamente
  col_CO2 <- paste0("CO2_", i)
  pred_CO2 <- paste0("predicted_CO2_", i)
  
  # Ajustar el modelo de respiración de suelo
  modelo_respiracion <- tryCatch({
    nlsLM(as.formula(paste(col_CO2, "~ 400 + a * (tiempo_transcurrido_numeric / (b + tiempo_transcurrido_numeric))")),
          data = combined_data, 
          start = list(a = max(combined_data[[col_CO2]], na.rm = TRUE), b = median(combined_data$tiempo_transcurrido_numeric, na.rm = TRUE)))
  }, error = function(e) {
    message("Error al ajustar el modelo de respiración de suelo para ", col_CO2, ": ", e)
    NULL
  })
  
  # Verificar si el modelo se ajustó correctamente
  if (!is.null(modelo_respiracion)) {
    # Predecir valores con el modelo ajustado
    combined_data[[pred_CO2]] <- predict(modelo_respiracion, newdata = combined_data)
    
    # Almacenar los resultados
    resultados[[i]] <- list(
      modelo = modelo_respiracion,
      predicciones = combined_data %>%
        mutate(tiempo_transcurrido_numeric, all_of(col_CO2), all_of(pred_CO2))
    )
    
    # Crear gráfico con los datos y el modelo ajustado
    p <- ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
      geom_point(aes(y = .data[[col_CO2]], color = "Datos Reales")) +
      geom_line(aes(y = .data[[pred_CO2]], color = "Predicción"), linetype = "dashed") +
      labs(
        x = "Tiempo Transcurrido (s)",
        y = "CO2",
        title = paste("Modelo de Respiración de Suelo Ajustado para", col_CO2),
        color = "Leyenda"
      ) +
      theme_minimal() +
      scale_color_manual(values = c("Datos Reales" = "blue", "Predicción" = "red"))
    
    # Imprimir el gráfico
    print(p)
  } else {
    message("El modelo no se ajustó correctamente para ", col_CO2, ".")
  }
}

  
  ===================0


library(ggplot2)
library(dplyr)

# Inicializa el gráfico
p <- ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Modelos de Respiración de Suelo Ajustados para CO2_1 a CO2_9",
    color = "Leyenda"
  ) +
  theme_minimal()

# Añadir los datos reales y predicciones para cada CO2_1 a CO2_9
for (i in 1:3) {
  col_CO2 <- paste0("CO2_", i)
  pred_CO2 <- paste0("predicted_CO2_", i)
  
  # Añadir puntos para los datos reales
  p <- p + 
    geom_point(aes(y = .data[[col_CO2]], color = paste0(col_CO2, " Datos Reales"))) +
    # Añadir líneas para las predicciones
    geom_line(aes(y = .data[[pred_CO2]], color = paste0(col_CO2, " Predicción")), linetype = "dashed")
}

p
#####!!!!!!!!###
# Ajustar el modelo de respiración de suelo para CO2_2 (usando modelo de Michaelis-Menten)
modelo_respiracion_CO2_2 <- tryCatch({
  nlsLM(CO2_2 ~400+ a * (tiempo_transcurrido_numeric / (b + tiempo_transcurrido_numeric)), 
        data = combined_data_cortado, 
        start = list(a = max(combined_data$CO2_2), b = median(combined_data_cortado$tiempo_transcurrido_numeric)))
}, error = function(e) {
  message("Error al ajustar el modelo de respiración de suelo para CO2_2: ", e)
  NULL
})

# Verificar si el modelo se ajustó correctamente
if (!is.null(modelo_respiracion_CO2_2)) {
  # Predecir valores con el modelo ajustado
  combined_data_cortado <- combined_data_cortado %>%
    mutate(predicted_CO2_2 = predict(modelo_respiracion_CO2_2, newdata = combined_data_cortado))
  
  # Verificar los primeros registros para confirmar
  head(combined_data_cortado)
  
  # Crear gráfico con los datos y el modelo ajustado para CO2_2
  ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
    geom_point(aes(y = CO2_2), color = "blue") +
    geom_line(aes(y = predicted_CO2_2), color = "red", linetype = "dashed") +
    labs(
      x = "Tiempo Transcurrido (s)",
      y = "CO2",
      title = "Modelo de Respiración de Suelo Ajustado para CO2_2",
      color = "Leyenda"
    ) +
    theme_minimal() +
    scale_color_manual(values = c("Datos Reales" = "blue", "Predicción" = "red"))
} else {
  message("El modelo para CO2_2 no se ajustó correctamente.")
}

######################
library(minpack.lm)
library(dplyr)
library(ggplot2)


#################################################

##########COMBINADO###############

# Crear una nueva columna que combine CO2_1 y CO2_2
combined_data <- combined_data %>%
  mutate(CO2_combined = (CO2_1 + CO2_2 + CO2_3) / 3)

# Ajustar el modelo de respiración de suelo utilizando los datos combinados
modelo_respiracion_combined <- tryCatch({
  nlsLM(CO2_combined ~ 400+a * (tiempo_transcurrido_numeric / (b + tiempo_transcurrido_numeric)), 
        data = combined_data, 
        start = list(a = max(combined_data$CO2_combined), b = median(combined_data$tiempo_transcurrido_numeric)))
}, error = function(e) {
  message("Error al ajustar el modelo de respiración de suelo combinado: ", e)
  NULL
})

# Verificar si el modelo se ajustó correctamente
if (!is.null(modelo_respiracion_combined)) {
  # Predecir valores con el modelo ajustado
  combined_data <- combined_data %>%
    mutate(predicted_CO2_combined = predict(modelo_respiracion_combined, newdata = combined_data))
}



ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_1, color = "CO2_1 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_1, color = "CO2_1 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_2, color = "CO2_2 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_2, color = "CO2_2 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_3, color = "CO2_3 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_3, color = "CO2_3 Predicción"), linetype = "dashed") +
  #geom_point(aes(y = CO2_4, color = "CO2_4 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_4, color = "CO2_4 Predicción"), linetype = "dashed") +
  #geom_point(aes(y = CO2_5, color = "CO2_5 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_5, color = "CO2_5 Predicción"), linetype = "dashed") +
  #geom_point(aes(y = CO2_6, color = "CO2_6 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_6, color = "CO2_6 Predicción"), linetype = "dashed") +
  #geom_point(aes(y = CO2_7, color = "CO2_7 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_7, color = "CO2_7 Predicción"), linetype = "dashed") +
  #geom_point(aes(y = CO2_8, color = "CO2_8 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_8, color = "CO2_8 Predicción"), linetype = "dashed") +
  #geom_point(aes(y = CO2_9, color = "CO2_9 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_9, color = "CO2_9 Predicción"), linetype = "dashed") +
  #geom_point(aes(y = CO2_combined, color = "Datos Reales Combinados")) +
  #geom_line(aes(y = predicted_CO2_combined, color = "Predicción combinada"), linetype = "dashed") +
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Ajuste del Modelo Michaelis-Menten modificado",
    subtitle= "Datos: CO2",
    color = "Leyenda"
  ) +
  theme_minimal() +
  scale_color_manual(values = c(
    "CO2_1 Datos Reales" = "cyan", 
    "CO2_1 Predicción" = "blue", 
    "CO2_2 Datos Reales" = "cyan", 
    "CO2_2 Predicción" = "blue", 
    "CO2_3 Datos Reales" = "cyan", 
    "CO2_3 Predicción" = "blue", 
    "CO2_4 Datos Reales" = "cyan", 
    "CO2_4 Predicción" = "blue", 
    "CO2_5 Datos Reales" = "cyan", 
    "CO2_5 Predicción" = "blue", 
    "CO2_6 Datos Reales" = "cyan", 
    "CO2_6 Predicción" = "blue", 
    "CO2_7 Datos Reales" = "cyan", 
    "CO2_7 Predicción" = "blue", 
    "CO2_8 Datos Reales" = "cyan", 
    "CO2_8 Predicción" = "blue", 
    "CO2_9 Datos Reales" = "cyan", 
    "CO2_9 Predicción" = "blue",
    "Datos Reales Combinados"="yellow",
    "Predicción combinada"="red"
  ))


# Crear gráfico con los datos y el modelo ajustado para CO2_combined


ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_1, color = "CO2_1 Datos Reales")) +
  geom_point(aes(y = CO2_2, color = "CO2_2 Datos Reales")) +
  geom_point(aes(y = CO2_3, color = "CO2_3 Datos Reales")) +
  geom_point(aes(y = CO2_4, color = "CO2_4 Datos Reales")) +
  geom_point(aes(y = CO2_5, color = "CO2_5 Datos Reales")) +
  geom_point(aes(y = CO2_6, color = "CO2_6 Datos Reales")) +
  #geom_point(aes(y = CO2_7, color = "CO2_7 Datos Reales")) +
  #geom_point(aes(y = CO2_8, color = "CO2_8 Datos Reales")) +
  #geom_point(aes(y = CO2_9, color = "CO2_9 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_combined, color = "CO2 Combinado Predicción"), linetype = "dashed") +
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Modelo de Respiración de Suelo Ajustado para Datos Combinados de CO2_1 y CO2_2",
    color = "Leyenda"
  ) +
  theme_minimal() +
  scale_color_manual(values = c(
    "CO2_1 Datos Reales" = "blue", 
    "CO2_2 Datos Reales" = "red", 
    "CO2_3 Datos Reales" = "green", 
    "CO2_4 Datos Reales" = "purple", 
    "CO2_5 Datos Reales" = "orange", 
    "CO2_6 Datos Reales" = "brown", 
    "CO2_7 Datos Reales" = "pink", 
    "CO2_8 Datos Reales" = "cyan", 
    "CO2_9 Datos Reales" = "yellow", 
    "CO2 Combinado Predicción" = "black"
  ))



ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_combined, color = "Sumatoria Datos Reales")) +
  geom_line(aes(y = predicted_CO2_combined, color = "CO2 Combinado Predicción"), linetype = "dashed") +
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Modelo de Respiración de Suelo Ajustado para Datos Combinados de CO2_1 y CO2_2",
    color = "Leyenda"
  ) +
  theme_minimal() +
  scale_color_manual(values = c(
    "Sumatoria Datos Reales" = "red", 
    "CO2 Combinado Predicción" = "black"
  ))


############################################################


# Cortar el dataframe hasta el registro 2000
combined_data_cortado <- combined_data[1:2000, ]

combined_data_cortado1 <- combined_data_cortado %>%
  mutate(tiempo_transcurrido_numeric, CO2_combined, predicted_CO2_combined)


modelo_respiracion_combined
a <- coef(modelo_respiracion_combined)["a"]
b <- coef(modelo_respiracion_combined)["b"]


predicted_values <- 400+a * (combined_data_cortado1$tiempo_transcurrido_numeric / (b +combined_data_cortado1$tiempo_transcurrido_numeric))
pred_data <- data.frame(
  tiempo_transcurrido_numeric = combined_data_cortado1$tiempo_transcurrido_numeric,
  predicted_CO2_combined = predicted_values
)
library(ggplot2)

ggplot(combined_data_cortado1, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_combined, color = "Datos Reales")) +
  geom_line(data = pred_data, aes(y = predicted_CO2_combined, color = "Predicción"), linetype = "dashed") +
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Datos Reales y Predicción del Modelo Ajustado",
    color = "Leyenda"
  ) +
  theme_minimal() +
  scale_color_manual(values = c("Datos Reales" = "blue", "Predicción" = "red"))



############################333
library(ggplot2)

# Crear el gráfico
ggplot(combined_data_cortado, aes(x = tiempo_transcurrido_numeric)) +
  # Datos reales
  geom_point(aes(y = CO2_1, color = "Datos Reales CO2_1"), size = 1) +
  geom_point(aes(y = CO2_2, color = "Datos Reales CO2_2"), size = 1) +
  # Valores predichos para CO2_1
  geom_line(aes(y = predicted_CO2_1, color = "Predichos CO2_1"), size = 1, linetype = "dashed") +
  # Valores predichos para CO2_2
  geom_line(aes(y = predicted_CO2_2, color = "Predichos CO2_2"), size = 1, linetype = "dotted") +
  # Valores combinados predichos
  geom_line(aes(y = predicted_CO2_combined, color = "Predichos Combinados"), size = 1, linetype = "solid") +
  # Etiquetas y tema
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Curvas de CO2 en función del Tiempo",
    color = "Leyenda"
  ) +
  theme_minimal() +
  scale_color_manual(values = c(
    "Datos Reales CO2_1" = "blue",
    "Datos Reales CO2_2" = "red",
    "Predichos CO2_1" = "green",
    "Predichos CO2_2" = "black",
    "Predichos Combinados" = "purple"
  ))


##################################################33




# Cortar el dataframe hasta el registro 2000
combined_data_cortado <- combined_data[1:3000, ]

# Verificar el resultado
head(combined_data_cortado)

ggplot(combined_data_cortado, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_combined, color = "Sumatoria Datos Reales")) +
  geom_line(aes(y = predicted_CO2_combined, color = "CO2 Combinado Predicción"), linetype = "dashed") +
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Modelo de Respiración de Suelo Ajustado para Datos Combinados de CO2_1 a CO2_9",
    color = "Leyenda"
  ) +
  theme_minimal() +
  scale_color_manual(values = c(
    "Sumatoria Datos Reales" = "red", 
    "CO2 Combinado Predicción" = "black"
  ))


library(ggplot2)

#Cortar combined_data hasta los primeros 2000 registros
combined_data_cortado <- combined_data[1:2000, ]


# Ajustar el modelo de respiración de suelo para los datos combinados
modelo_respiracion_combined <- tryCatch({
  nlsLM(CO2_combined ~ 400 + a * (tiempo_transcurrido_numeric / (b + tiempo_transcurrido_numeric)), 
        data = combined_data_cortado, 
        start = list(a = max(combined_data_cortado$CO2_combined), b = median(combined_data_cortado$tiempo_transcurrido_numeric)))
}, error = function(e) {
  message("Error al ajustar el modelo de respiración de suelo: ", e)
  NULL
})

# Verificar si el modelo se ajustó correctamente
if (!is.null(modelo_respiracion_combined)) {
  # Predecir valores con el modelo ajustado hasta 5500 registros
  combined_data_cortado <- combined_data_cortado %>%
    mutate(predicted_CO2_combined = predict(modelo_respiracion_combined, newdata = combined_data_cortado))
  
  # Crear el gráfico con los datos reales y las predicciones
  ggplot(combined_data_cortado, aes(x = tiempo_transcurrido_numeric)) +
    geom_point(aes(y = CO2_combined, color = "Datos Reales")) +
    geom_line(aes(y = predicted_CO2_combined, color = "Predicción"), linetype = "dashed") +
    labs(
      x = "Tiempo Transcurrido (s)",
      y = "CO2",
      title = "Modelo de Respiración de Suelo Ajustado para Datos Combinados de CO2",
      color = "Leyenda"
    ) +
    theme_minimal() +
    scale_color_manual(values = c(
      "Datos Reales" = "red", 
      "Predicción" = "black"
    ))
  # Mostrar las medidas resumen del modelo
  summary(modelo_respiracion_combined)
} else {
  message("El modelo no se ajustó correctamente.")
}


library(ggplot2)
library(minpack.lm)

# Ajustar el modelo de respiración de suelo para los datos combinados
modelo_respiracion_combined <- tryCatch({
  nlsLM(CO2_combined ~ 400+a * (tiempo_transcurrido_numeric / (b + tiempo_transcurrido_numeric)), 
        data = combined_data_cortado, 
        start = list(a = max(combined_data_cortado$CO2_combined), b = median(combined_data_cortado$tiempo_transcurrido_numeric)))
}, error = function(e) {
  message("Error al ajustar el modelo de respiración de suelo: ", e)
  NULL
})

# Verificar si el modelo se ajustó correctamente
if (!is.null(modelo_respiracion_combined)) {
  # Extender el rango de tiempo para la predicción
  tiempo_extendido <- seq(from = min(combined_data_cortado$tiempo_transcurrido_numeric), 
                          to = 2000, 
                          length.out = 2500)
  
  # Crear un nuevo dataframe para las predicciones extendidas
  predicciones_extendidas <- data.frame(
    tiempo_transcurrido_numeric = tiempo_extendido
  )
  
  # Predecir valores con el modelo ajustado hasta 5500 registros
  predicciones_extendidas <- predicciones_extendidas %>%
    mutate(predicted_CO2_combined = predict(modelo_respiracion_combined, newdata = predicciones_extendidas))
  
  # Combinar los datos originales con las predicciones extendidas
  combined_data_cortado_extendido <- rbind(combined_data_cortado, predicciones_extendidas)
  
  # Crear el gráfico con los datos reales y las predicciones extendidas
  ggplot(combined_data_cortado_extendido, aes(x = tiempo_transcurrido_numeric)) +
    geom_point(aes(y = CO2_combined, color = "Datos Reales")) +
    geom_line(aes(y = predicted_CO2_combined, color = "Predicción"), linetype = "dashed") +
    labs(
      x = "Tiempo Transcurrido (s)",
      y = "CO2",
      title = "Modelo de Respiración de Suelo Ajustado con Predicción Extendida",
      color = "Leyenda"
    ) +
    theme_minimal() +
    scale_color_manual(values = c(
      "Datos Reales" = "red", 
      "Predicción" = "black"
    ))
} else {
  message("El modelo no se ajustó correctamente.")
}

library(ggplot2)
library(minpack.lm)

# Ajustar el modelo de respiración de suelo para los datos combinados
modelo_respiracion_combined <- tryCatch({
  nlsLM(CO2_combined ~ 400+a * (tiempo_transcurrido_numeric / (b + tiempo_transcurrido_numeric)), 
        data = combined_data_cortado, 
        start = list(a = max(combined_data_cortado$CO2_combined), b = median(combined_data_cortado$tiempo_transcurrido_numeric)))
}, error = function(e) {
  message("Error al ajustar el modelo de respiración de suelo: ", e)
  NULL
})

# Verificar si el modelo se ajustó correctamente
if (!is.null(modelo_respiracion_combined)) {
  # Extender el rango de tiempo para la predicción
  tiempo_extendido <- seq(from = min(combined_data_cortado$tiempo_transcurrido_numeric), 
                          to = 5500, 
                          length.out = 5500)
  
  # Crear un nuevo dataframe para las predicciones extendidas
  predicciones_extendidas <- data.frame(
    tiempo_transcurrido_numeric = tiempo_extendido
  )
  
  # Predecir valores con el modelo ajustado hasta 5500 registros
  predicciones_extendidas <- predicciones_extendidas %>%
    mutate(predicted_CO2_combined = predict(modelo_respiracion_combined, newdata = predicciones_extendidas))
  
  # Asegurar que el dataframe original tenga la misma columna para combinar
  combined_data_cortado$predicted_CO2_combined <- NA
  
  # Combinar los datos originales con las predicciones extendidas
  combined_data_cortado_extendido <- rbind(
    combined_data_cortado, 
    predicciones_extendidas
  )
  
  # Crear el gráfico con los datos reales y las predicciones extendidas
  ggplot(combined_data_cortado_extendido, aes(x = tiempo_transcurrido_numeric)) +
    geom_point(aes(y = CO2_combined, color = "Datos Reales")) +
    geom_line(aes(y = predicted_CO2_combined, color = "Predicción"), linetype = "dashed") +
    labs(
      x = "Tiempo Transcurrido (s)",
      y = "CO2",
      title = "Modelo de Respiración de Suelo Ajustado con Predicción Extendida",
      color = "Leyenda"
    ) +
    theme_minimal() +
    scale_color_manual(values = c(
      "Datos Reales" = "red", 
      "Predicción" = "black"
    ))
} else {
  message("El modelo no se ajustó correctamente.")
}


######!!!!!!!!!#############

library(ggplot2)
library(minpack.lm)

# Ajustar el modelo de respiración de suelo para los datos combinados
modelo_respiracion_combined <- tryCatch({
  nlsLM(CO2_combined ~400+ a * (tiempo_transcurrido_numeric / (b + tiempo_transcurrido_numeric)), 
        data = combined_data_cortado, 
        start = list(a = max(combined_data_cortado$CO2_combined), b = median(combined_data_cortado$tiempo_transcurrido_numeric)))
}, error = function(e) {
  message("Error al ajustar el modelo de respiración de suelo: ", e)
  NULL
})

# Verificar si el modelo se ajustó correctamente
if (!is.null(modelo_respiracion_combined)) {
  # Extender el rango de tiempo para la predicción
  tiempo_extendido <- seq(from = min(combined_data_cortado$tiempo_transcurrido_numeric), 
                          to = 5500, 
                          length.out = 5500)
  
  # Crear un nuevo dataframe para las predicciones extendidas
  predicciones_extendidas <- data.frame(
    tiempo_transcurrido_numeric = tiempo_extendido,
    predicted_CO2_combined = NA  # Inicializar la columna para las predicciones
  )
  
  # Predecir valores con el modelo ajustado hasta 5500 registros
  predicciones_extendidas$predicted_CO2_combined <- predict(modelo_respiracion_combined, newdata = predicciones_extendidas)
  
  # Agregar las predicciones al data frame original con las columnas iguales
  combined_data_cortado <- combined_data_cortado %>%
    mutate(predicted_CO2_combined = NA) # Inicializar la columna para las predicciones
  
  # Combinar los datos originales con las predicciones extendidas
  combined_data_cortado_extendido <- rbind(
    combined_data_cortado,
    predicciones_extendidas
  )
  
  # Crear el gráfico con los datos reales y las predicciones extendidas
  ggplot(combined_data_cortado_extendido, aes(x = tiempo_transcurrido_numeric)) +
    geom_point(aes(y = CO2_combined, color = "Datos Reales")) +
    geom_line(aes(y = predicted_CO2_combined, color = "Predicción"), linetype = "dashed") +
    labs(
      x = "Tiempo Transcurrido (s)",
      y = "CO2",
      title = "Modelo de Respiración de Suelo Ajustado con Predicción Extendida",
      color = "Leyenda"
    ) +
    theme_minimal() +
    scale_color_manual(values = c(
      "Datos Reales" = "red", 
      "Predicción" = "black"
    ))
} else {
  message("El modelo no se ajustó correctamente.")
}


///////////////////////////7


combined_data_cortado1 <- combined_data_cortado %>%
  mutate(tiempo_transcurrido_numeric, CO2_combined, predicted_CO2_combined)

a <- coef(modelo_combined)["a"]
b <- coef(modelo_combined)["b"]
####################################################

#################################################



# Calcular la diferencia promedio de tiempo entre los registros
diffs <- diff(combined_data_cortado1$tiempo_transcurrido_numeric)
mean_diff <- mean(diffs)

# Generar los nuevos tiempos extendidos hasta 5500 registros
new_times <- seq(
  from = max(combined_data_cortado1$tiempo_transcurrido_numeric),
  by = mean_diff,
  length.out = 3500 - nrow(combined_data_cortado1) + 1
)[-1]  # eliminar el primer elemento que es redundante

# Crear un dataframe para los nuevos tiempos
new_data <- data.frame(tiempo_transcurrido_numeric = new_times)

# Predecir los valores de CO2 para los nuevos tiempos
new_data$predicted_CO2_combined <- predict(modelo_respiracion_combined, newdata = new_data)

# Combinar los datos originales con los nuevos datos
extended_data <- rbind(
  combined_data_cortado1,
  data.frame(
    tiempo_transcurrido_numeric = new_times,
    CO2_combined = NA,
    predicted_CO2_combined = new_data$predicted_CO2_combined
  )
)

# Verificar los primeros y últimos registros para confirmar
head(extended_data)
tail(extended_data)

extended_data<-
# Crear el gráfico
ggplot(extended_data, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_combined, color = "Sumatoria Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_combined, color = "CO2 Combinado Predicción"), linetype = "dashed") +
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Modelo de Respiración de Suelo Ajustado",
    subtitle = "Datos Combinados de CO2",
    color = "Leyenda"
  ) +
  theme_minimal() +
  scale_color_manual(values = c(
    "Sumatoria Datos Reales" = "red", 
    "CO2 Combinado Predicción" = "green"
  ))


#######################################33
library(ggplot2)

ggplot() +
  # Puntos para los datos reales
  geom_point(data = extended_data, aes(x = tiempo_transcurrido_numeric, y = CO2_combined, color = "Sumatoria Datos Reales")) +
  
  # Línea para la predicción futura
  geom_line(data = extended_data, aes(x = tiempo_transcurrido_numeric, y = predicted_CO2_combined, color = "CO2 Combinado Predicción Futura"), linetype = "dashed") +
  
  # Línea para la predicción actual
  geom_line(data = combined_data, aes(x = tiempo_transcurrido_numeric, y = predicted_CO2_combined, color = "CO2 Combinado Predicción"), linetype = "dashed") +
  
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Modelo de Respiración de Suelo Ajustado para Datos Combinados",
    color = "Leyenda"
  ) +
  theme_minimal() +
  scale_color_manual(values = c(
    "Sumatoria Datos Reales" = "red",
    "CO2 Combinado Predicción" = "black",
    "CO2 Combinado Predicción Futura" = "blue"
  ))



# Crear la nueva secuencia de tiempos extendidos desde el último tiempo en combined_data_cortado1
last_time <- max(combined_data_cortado1$tiempo_transcurrido_numeric)
new_times <- seq(last_time + 1, by = 1, length.out = 3500)

# Generar un nuevo data frame con los tiempos extendidos
new_data <- data.frame(
  tiempo_transcurrido_numeric = new_times,
  CO2_combined = NA,  # Valores faltantes para CO2_combined
  predicted_CO2_combined = predict(modelo_respiracion_combined, newdata = data.frame(tiempo_transcurrido_numeric = new_times))
)

# Asegurarse de que ambos data frames tengan las mismas columnas y tipos
new_data <- new_data %>%
  mutate(tiempo_transcurrido_numeric, CO2_combined, predicted_CO2_combined)

# Combinar los data frames
extended_data <- rbind(combined_data_cortado1, new_data)

# Verificar la estructura del data frame combinado
str(extended_data)

###################################3333




library(ggplot2)
library(minpack.lm)
library(dplyr)

# Ajustar el modelo de respiración de suelo para los datos combinados
modelo_respiracion_combined <- tryCatch({
  nlsLM(CO2_combined ~ 400 + a * (tiempo_transcurrido_numeric / (b + tiempo_transcurrido_numeric)), 
        data = combined_data_cortado, 
        start = list(a = max(combined_data_cortado$CO2_combined, na.rm = TRUE), 
                     b = median(combined_data_cortado$tiempo_transcurrido_numeric, na.rm = TRUE)))
}, error = function(e) {
  message("Error al ajustar el modelo de respiración de suelo: ", e)
  NULL
})

# Verificar si el modelo se ajustó correctamente
if (!is.null(modelo_respiracion_combined)) {
  # Extender el rango de tiempo para la predicción
  tiempo_extendido <- seq(from = min(combined_data_cortado$tiempo_transcurrido_numeric), 
                          to = 2000, 
                          length.out = 2500)
  
  # Crear un nuevo dataframe para las predicciones extendidas
  predicciones_extendidas <- data.frame(
    tiempo_transcurrido_numeric = tiempo_extendido,
    CO2_combined = NA  # Añadir una columna CO2_combined con NA para mantener la consistencia
  )
  
  # Predecir valores con el modelo ajustado hasta 5500 registros
  predicciones_extendidas <- predicciones_extendidas %>%
    mutate(predicted_CO2_combined = predict(modelo_respiracion_combined, newdata = predicciones_extendidas))
  
  # Combinar los datos originales con las predicciones extendidas
  combined_data_cortado_extendido <- bind_rows(combined_data_cortado, predicciones_extendidas)
  
  # Crear el gráfico con los datos reales y las predicciones extendidas
  ggplot(combined_data_cortado_extendido, aes(x = tiempo_transcurrido_numeric)) +
    geom_point(aes(y = CO2_combined, color = "Datos Reales")) +
    geom_line(aes(y = predicted_CO2_combined, color = "Predicción"), linetype = "dashed") +
    labs(
      x = "Tiempo Transcurrido (s)",
      y = "CO2",
      title = "Modelo de Respiración de Suelo Ajustado con Predicción Extendida",
      color = "Leyenda"
    ) +
    theme_minimal() +
    scale_color_manual(values = c(
      "Datos Reales" = "red", 
      "Predicción" = "black"
    ))
} else {
  message("El modelo no se ajustó correctamente.")
}


# Crear el gráfico con los datos reales y las predicciones extendidas
ggplot(combined_data_cortado_extendido, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_combined, color = "Datos Reales")) +
  geom_line(aes(y = predicted_CO2_combined, color = "Predicción"), linetype = "dashed") +
  geom_point(aes(y=))
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Modelo de Respiración de Suelo Ajustado con Predicción Extendida",
    color = "Leyenda"
  ) +
  theme_minimal() +
  scale_color_manual(values = c(
    "Sumatoria Datos Reales" = "red", 
    "Predicción 24hs" = "black"
    ))
  
 ######## 
  library(dplyr)
  
  # Verificar las columnas de combined_data_cortado1
  colnames(combined_data_cortado1)
  
  # Crear el nuevo data frame con las columnas necesarias
  new_data_frame <- data.frame(
    tiempo_transcurrido_numeric = new_times,
    CO2_combined = NA,  # Añadir CO2_combined como NA
    predicted_CO2_combined = new_data$predicted_CO2_combined
  )
  
  # Asegurarse de que todas las columnas de combined_data_cortado1 estén en el nuevo data frame
  missing_columns <- setdiff(colnames(combined_data_cortado1), colnames(new_data_frame))
  
  # Añadir las columnas que faltan al nuevo data frame con NA
  if (length(missing_columns) > 0) {
    new_data_frame[missing_columns] <- NA
  }
  
  # Combinar los datos originales con los nuevos datos
  extended_data <- bind_rows(combined_data_cortado1, new_data_frame)
  
