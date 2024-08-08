#SUPUESTOS DEL MODELO##

library(nlstools)


modelo_respiracion_combined_residuos<- nlsResiduals(modelo_respiracion_combined)
modelo_respiracion_combined_residuos
plot(modelo_respiracion_combined_residuos, which = 1)
summary(modelo_respiracion_combined_residuos)


# Supongamos que ya tienes el modelo ajustado y el data frame combined_data_cortado

# Crear la nueva secuencia de tiempos extendidos desde el último tiempo en combined_data_cortado
last_time <- max(combined_data_cortado$tiempo_transcurrido_numeric)
new_times <- seq(last_time + 1, by = 1, length.out = 2000)

# Generar un nuevo data frame con los tiempos extendidos
predicciones_extendidas <- data.frame(
  tiempo_transcurrido_numeric = new_times,
  CO2_combined = NA,  # Valores faltantes para CO2_combined
  predicted_CO2_combined = predict(modelo_respiracion_combined, newdata = data.frame(tiempo_transcurrido_numeric = new_times))
)

# Asegurarse de que ambos data frames tienen las mismas columnas
predicciones_extendidas <- predicciones_extendidas %>%
  mutate(names(combined_data_cortado))

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

