library(dplyr)
library(minpack.lm)
library(ggplot2)

# Asumiendo que combined_data_cortado y modelo_respiracion_combined ya existen

# Crear la nueva secuencia de tiempos extendidos desde el último tiempo en combined_data_cortado
last_time <- max(combined_data_cortado$tiempo_transcurrido_numeric)
new_times <- seq(last_time + 1, by = 1, length.out = 3500)

# Generar un nuevo data frame con los tiempos extendidos
predicciones_extendidas <- data.frame(
  tiempo_transcurrido_numeric = new_times,
  CO2_combined = NA,
  predicted_CO2_combined = predict(modelo_respiracion_combined, newdata = data.frame(tiempo_transcurrido_numeric = new_times))
)

# Asegurarse de que ambos data frames tienen las mismas columnas y tipos de datos
predicciones_extendidas <- predicciones_extendidas %>%
  mutate(
    CO2_combined = as.numeric(CO2_combined),
    predicted_CO2_combined = as.numeric(predicted_CO2_combined)
  )

# Añadir columnas faltantes con NA en predicciones_extendidas
missing_cols <- setdiff(names(combined_data_cortado), names(predicciones_extendidas))
for (col in missing_cols) {
  predicciones_extendidas[[col]] <- NA
}

# Ordenar las columnas para que coincidan
predicciones_extendidas <- predicciones_extendidas[names(combined_data_cortado)]

# Combinar los data frames
combined_data_cortado_extendido <- rbind(combined_data_cortado, predicciones_extendidas)

# Verificar la estructura del data frame combinado
str(combined_data_cortado_extendido)

# Graficar los datos extendidos
ggplot() +
  # Puntos para los datos reales
  geom_point(data = combined_data_cortado, aes(x = tiempo_transcurrido_numeric, y = CO2_combined, color = "Sumatoria Datos Reales")) +
  
  # Línea para la predicción futura
  geom_line(data = combined_data_cortado_extendido, aes(x = tiempo_transcurrido_numeric, y = predicted_CO2_combined, color = "CO2 Combinado Predicción Futura"), linetype = "dashed") +
  
  # Línea para la predicción actual
  geom_line(data = combined_data_cortado, aes(x = tiempo_transcurrido_numeric, y = predicted_CO2_combined, color = "CO2 Combinado Predicción"), linetype = "dashed") +
  
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



###################33

library(dplyr)
library(minpack.lm)
library(ggplot2)

# Asumiendo que combined_data_cortado y modelo_respiracion_combined ya existen

# Crear la nueva secuencia de tiempos extendidos desde el último tiempo en combined_data_cortado
last_time <- max(combined_data_cortado$tiempo_transcurrido_numeric)
new_times <- seq(last_time + 1, by = 1, length.out = 3500)

# Generar un nuevo data frame con los tiempos extendidos
predicciones_extendidas <- data.frame(
  tiempo_transcurrido_numeric = new_times,
  CO2_combined = NA,
  predicted_CO2_combined = predict(modelo_respiracion_combined, newdata = data.frame(tiempo_transcurrido_numeric = new_times))
)

# Asegurarse de que ambos data frames tienen las mismas columnas y tipos de datos
predicciones_extendidas <- predicciones_extendidas %>%
  mutate(
    CO2_combined = as.numeric(CO2_combined),
    predicted_CO2_combined = as.numeric(predicted_CO2_combined)
  )

# Añadir columnas faltantes con NA en predicciones_extendidas
missing_cols <- setdiff(names(combined_data_cortado), names(predicciones_extendidas))
for (col in missing_cols) {
  predicciones_extendidas[[col]] <- NA
}

# Ordenar las columnas para que coincidan
predicciones_extendidas <- predicciones_extendidas[names(combined_data_cortado)]

# Combinar los data frames
combined_data_cortado_extendido <- rbind(combined_data_cortado, predicciones_extendidas)

# Verificar la estructura del data frame combinado
str(combined_data_cortado_extendido)

# Graficar los datos extendidos
ggplot() +
  # Puntos para los datos reales
  geom_point(data = combined_data_cortado, aes(x = tiempo_transcurrido_numeric, y = CO2_combined, color = "Sumatoria Datos Reales")) +
  
  # Línea para la predicción futura
  geom_line(data = combined_data_cortado_extendido, aes(x = tiempo_transcurrido_numeric, y = predicted_CO2_combined, color = "Predicción Futura"), linetype = "dashed") +
  
  # Línea para la predicción actual
  geom_line(data = combined_data_cortado, aes(x = tiempo_transcurrido_numeric, y = predicted_CO2_combined, color = "Predicción"), linetype = "solid") +
  
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Modelo de Respiración de Suelo Ajustado para Datos Combinados",
    color = "Leyenda"
  ) +
  theme_minimal() +
  scale_color_manual(values = c(
    "Sumatoria Datos Reales" = "red",
    "Predicción" = "black",
    "Predicción Futura" = "blue"
  ))


#######################33



library(dplyr)
library(minpack.lm)
library(ggplot2)

# Asegurarse de que no haya valores NA en predicted_CO2_combined
combined_data_cortado <- combined_data_cortado %>%
  filter(!is.na(predicted_CO2_combined))

# Crear la nueva secuencia de tiempos extendidos desde el último tiempo en combined_data_cortado
last_time <- max(combined_data_cortado$tiempo_transcurrido_numeric)
new_times <- seq(last_time + 1, by = 1, length.out = 3500)

# Generar un nuevo data frame con los tiempos extendidos
predicciones_extendidas <- data.frame(
  tiempo_transcurrido_numeric = new_times,
  CO2_combined = NA,
  predicted_CO2_combined = predict(modelo_respiracion_combined, newdata = data.frame(tiempo_transcurrido_numeric = new_times))
)

# Asegurarse de que ambos data frames tienen las mismas columnas y tipos de datos
predicciones_extendidas <- predicciones_extendidas %>%
  mutate(
    CO2_combined = as.numeric(CO2_combined),
    predicted_CO2_combined = as.numeric(predicted_CO2_combined)
  )

# Añadir columnas faltantes con NA en predicciones_extendidas
missing_cols <- setdiff(names(combined_data_cortado), names(predicciones_extendidas))
for (col in missing_cols) {
  predicciones_extendidas[[col]] <- NA
}

# Ordenar las columnas para que coincidan
predicciones_extendidas <- predicciones_extendidas[names(combined_data_cortado)]

# Combinar los data frames
combined_data_cortado_extendido <- rbind(combined_data_cortado, predicciones_extendidas)

# Verificar la estructura del data frame combinado
str(combined_data_cortado_extendido)

# Graficar los datos extendidos
ggplot() +
  # Puntos para los datos reales
  geom_point(data = combined_data_cortado, aes(x = tiempo_transcurrido_numeric, y = CO2_combined, color = "Sumatoria Datos Reales")) +
  
  # Línea para la predicción futura
  geom_line(data = combined_data_cortado_extendido %>% filter(!is.na(predicted_CO2_combined)), 
            ae
