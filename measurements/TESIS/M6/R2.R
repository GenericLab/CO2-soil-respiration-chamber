# Cargar la librería necesaria
library(minpack.lm)  # Asegúrate de tener instalada la librería minpack.lm para nlsLM
library(ggplot2)

# Crear una lista para almacenar los resultados
resultados <- list()

for (i in 1:3) {
  # Crear el nombre de las columnas dinámicamente
  col_CO2 <- paste0("CO2_", i)
  
  # Verificar si la columna existe en combined_data
  if (!col_CO2 %in% names(combined_data)) {
    message("La columna ", col_CO2, " no existe en combined_data.")
    resultados[[col_CO2]] <- list(modelo = NULL, R2 = NA)
    next
  }
  
  # Ajustar el modelo de respiración de suelo
  modelo_respiracion <- tryCatch({
    nlsLM(
      as.formula(paste(col_CO2, "~ 400 + a * (tiempo_transcurrido_numeric / (b + tiempo_transcurrido_numeric))")),
      data = combined_data,
      start = list(
        a = max(combined_data[[col_CO2]], na.rm = TRUE),
        b = median(combined_data$tiempo_transcurrido_numeric, na.rm = TRUE)
      )
    )
  }, error = function(e) {
    message("Error al ajustar el modelo de respiración de suelo para ", col_CO2, ": ", e$message)
    NULL
  })
  
  # Si el modelo se ajusta correctamente, calcular el R^2
  if (!is.null(modelo_respiracion)) {
    # Predicciones del modelo
    predicciones <- predict(modelo_respiracion)
    
    # Valores observados
    valores_observados <- combined_data[[col_CO2]]
    
    # Asegurarse de que no hay valores NA en los valores observados o predicciones
    valid_idx <- !is.na(valores_observados) & !is.na(predicciones)
    valores_observados <- valores_observados[valid_idx]
    predicciones <- predicciones[valid_idx]
    
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
    message("R^2 para ", col_CO2, ": ", round(R2, 4))
  } else {
    # Si el modelo no se ajusta, almacenar NA en la lista de resultados
    resultados[[col_CO2]] <- list(modelo = NULL, R2 = NA)
  }
}

# Extraer los valores de R^2 y los nombres de las columnas
r2_values <- sapply(resultados, function(x) x$R2)
column_names <- names(resultados)

# Verificar que tienen la misma longitud
if (length(column_names) != length(r2_values)) {
  stop("Las longitudes de 'column_names' y 'r2_values' no coinciden.")
}

# Crear un data frame con los resultados
r2_df <- data.frame(Columna = column_names, R2 = r2_values, stringsAsFactors = FALSE)

# Mostrar la tabla
print(r2_df)

# Crear un gráfico de barras de los valores de R^2
ggplot(r2_df, aes(x = Columna, y = R2)) +
  geom_bar(stat = "identity", fill = "skyblue") +
  theme_minimal() +
  labs(title = "Valores de R² por Columna", x = "Columna", y = expression(R^2)) +
  ylim(0, 1) +  # Limita el eje y de 0 a 1
  geom_text(aes(label = round(R2, 3)), vjust = -0.5)  # Agrega etiquetas con el valor de R²






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
  geom_point(aes(y = CO2_combined, color = "Datos Reales Combinados")) +
  geom_line(aes(y = predicted_CO2_combined, color = "Predicción combinada"), linetype = "dashed") +
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
  ))+

 
  
# Calcular R² para CO2_combined
valores_observados_combined <- combined_data$CO2_combined
predicciones_combined <- combined_data$predicted_CO2_combined

valid_idx_combined <- !is.na(valores_observados_combined) & !is.na(predicciones_combined)
valores_observados_combined <- valores_observados_combined[valid_idx_combined]
predicciones_combined <- predicciones_combined[valid_idx_combined]

media_observados_combined <- mean(valores_observados_combined)

SST_combined <- sum((valores_observados_combined - media_observados_combined)^2)
SSR_combined <- sum((valores_observados_combined - predicciones_combined)^2)

R2_combined <- 1 - (SSR_combined / SST_combined)

# Agregar el resultado a la lista
resultados[["CO2_combined"]] <- list(modelo = NULL, R2 = R2_combined)

# Imprimir el R^2 para CO2_combined
message("R^2 para CO2_combined: ", round(R2_combined, 4))

####################################

# Asumiendo que ya has calculado y almacenado los valores de R² en la lista 'resultados'

# Crear el gráfico
ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_1, color = "CO2_1 Datos Reales")) +
  geom_line(aes(y = predict(resultados[["CO2_1"]]$modelo), color = "CO2_1 Predicción"), linetype = "dashed") +
  geom_text(aes(x = max(tiempo_transcurrido_numeric), 
                y = max(predict(resultados[["CO2_1"]]$modelo), na.rm = TRUE), 
                label = paste0("R² = ", round(resultados[["CO2_1"]]$R2, 3))), 
            vjust = -0.5, hjust = 1) +
  
  geom_point(aes(y = CO2_2, color = "CO2_2 Datos Reales")) +
  geom_line(aes(y = predict(resultados[["CO2_2"]]$modelo), color = "CO2_2 Predicción"), linetype = "dashed") +
  geom_text(aes(x = max(tiempo_transcurrido_numeric), 
                y = max(predict(resultados[["CO2_2"]]$modelo), na.rm = TRUE), 
                label = paste0("R² = ", round(resultados[["CO2_2"]]$R2, 3))), 
            vjust = -0.5, hjust = 1) +
  
  geom_point(aes(y = CO2_3, color = "CO2_3 Datos Reales")) +
  geom_line(aes(y = predict(resultados[["CO2_3"]]$modelo), color = "CO2_3 Predicción"), linetype = "dashed") +
  geom_text(aes(x = max(tiempo_transcurrido_numeric), 
                y = max(predict(resultados[["CO2_3"]]$modelo), na.rm = TRUE), 
                label = paste0("R² = ", round(resultados[["CO2_3"]]$R2, 3))), 
            vjust = -0.5, hjust = 1) +
  
  #geom_point(aes(y = CO2_4, color = "CO2_4 Datos Reales")) +
  #geom_line(aes(y = predict(resultados[["CO2_4"]]$modelo), color = "CO2_4 Predicción"), linetype = "dashed") +
  #geom_text(aes(x = max(tiempo_transcurrido_numeric), 
           #     y = max(predict(resultados[["CO2_4"]]$modelo), na.rm = TRUE), 
            #    label = paste0("R² = ", round(resultados[["CO2_4"]]$R2, 3))), 
            #vjust = -0.5, hjust = 1) +
  
  #geom_point(aes(y = CO2_5, color = "CO2_5 Datos Reales")) +
  #geom_line(aes(y = predict(resultados[["CO2_5"]]$modelo), color = "CO2_5 Predicción"), linetype = "dashed") +
  #geom_text(aes(x = max(tiempo_transcurrido_numeric), 
          #      y = max(predict(resultados[["CO2_5"]]$modelo), na.rm = TRUE), 
           #     label = paste0("R² = ", round(resultados[["CO2_5"]]$R2, 3))), 
            #vjust = -0.5, hjust = 1) +
  
  #geom_point(aes(y = CO2_6, color = "CO2_6 Datos Reales")) +
  #geom_line(aes(y = predict(resultados[["CO2_6"]]$modelo), color = "CO2_6 Predicción"), linetype = "dashed") +
  #geom_text(aes(x = max(tiempo_transcurrido_numeric), 
             #   y = max(predict(resultados[["CO2_6"]]$modelo), na.rm = TRUE), 
              #  label = paste0("R² = ", round(resultados[["CO2_6"]]$R2, 3))), 
            #vjust = -0.5, hjust = 1) +
  
  #geom_point(aes(y = CO2_combined, color = "Datos Reales Combinados")) +
  #geom_line(aes(y = predict(resultados[["CO2_combined"]]$modelo), color = "Predicción combinada"), linetype = "dashed") +
  #geom_text(aes(x = max(tiempo_transcurrido_numeric), 
             #   y = max(predict(resultados[["CO2_combined"]]$modelo), na.rm = TRUE), 
            #    label = paste0("R² = ", round(resultados[["CO2_combined"]]$R2, 3))), 
            #vjust = -0.5, hjust = 1) +
  
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Ajuste del Modelo Michaelis-Menten modificado",
    subtitle = "Datos: CO2",
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
    #"CO2_4 Datos Reales" = "cyan", 
    #"CO2_4 Predicción" = "blue", 
    #"CO2_5 Datos Reales" = "cyan", 
    #"CO2_5 Predicción" = "blue", 
    #"CO2_6 Datos Reales" = "cyan", 
    #"CO2_6 Predicción" = "blue", 
    "Datos Reales Combinados" = "yellow",
    "Predicción combinada" = "red"
  ))

##############################

####FINAL


# Añadir la columna `predicted_CO2_combined` al data frame `r2_df`
r2_df$Columna <- c(paste0("CO2_", 1:3), "CO2_combined")

# Crear el gráfico con las curvas y las etiquetas de R²
ggplot(combined_data, aes(x = tiempo_transcurrido_numeric*2.4)) +
  geom_point(aes(y = CO2_1, color = "CO2_1 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_1, color = "CO2_1 Predicción"), linetype = "dashed") +
  geom_text(data = r2_df[r2_df$Columna == "CO2_1", ], aes(x = Inf, y = Inf, label = paste("R² =", round(R2, 3))),
            hjust = 1.2, vjust = 2, color = "blue") +
  
  geom_point(aes(y = CO2_2, color = "CO2_2 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_2, color = "CO2_2 Predicción"), linetype = "dashed") +
  geom_text(data = r2_df[r2_df$Columna == "CO2_2", ], aes(x = Inf, y = Inf, label = paste("R² =", round(R2, 3))),
            hjust = 1.2, vjust = 2, color = "blue") +
  
  geom_point(aes(y = CO2_3, color = "CO2_3 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_3, color = "CO2_3 Predicción"), linetype = "dashed") +
  geom_text(data = r2_df[r2_df$Columna == "CO2_3", ], aes(x = Inf, y = Inf, label = paste("R² =", round(R2, 3))),
            hjust = 1.2, vjust = 2, color = "blue") +
  
  geom_point(aes(y = CO2_4, color = "CO2_4 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_4, color = "CO2_4 Predicción"), linetype = "dashed") +
  geom_text(data = r2_df[r2_df$Columna == "CO2_4", ], aes(x = Inf, y = Inf, label = paste("R² =", round(R2, 3))),
            hjust = 1.2, vjust = 2, color = "blue") +
  
  geom_point(aes(y = CO2_5, color = "CO2_5 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_5, color = "CO2_5 Predicción"), linetype = "dashed") +
  geom_text(data = r2_df[r2_df$Columna == "CO2_5", ], aes(x = Inf, y = Inf, label = paste("R² =", round(R2, 3))),
            hjust = 1.2, vjust = 2, color = "blue") +
  
  geom_point(aes(y = CO2_6, color = "CO2_6 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_6, color = "CO2_6 Predicción"), linetype = "dashed") +
  geom_text(data = r2_df[r2_df$Columna == "CO2_6", ], aes(x = Inf, y = Inf, label = paste("R² =", round(R2, 3))),
            hjust = 1.2, vjust = 2, color = "blue") +
  
  geom_point(aes(y = CO2_combined, color = "Datos Reales Combinados")) +
  geom_line(aes(y = predicted_CO2_combined, color = "Predicción combinada"), linetype = "dashed") +
  geom_text(data = r2_df[r2_df$Columna == "CO2_combined", ], aes(x = Inf, y = Inf, label = paste("R² =", round(R2, 3))),
            hjust = 1.2, vjust = 2, color = "red") +
  
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


##########3
#########FINAL FINAL
# Crear el gráfico con las curvas y las etiquetas R² al final de cada curva
ggplot(combined_data, aes(x = tiempo_transcurrido_numeric/41.66)) +
  geom_point(aes(y = CO2_1, color = "CO2_1 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_1, color = "CO2_1 Predicción"), linetype = "dashed") +
  geom_text(aes(x = max(tiempo_transcurrido_numeric/41.66), y = max(predicted_CO2_1), 
                label = paste0("R²: ", round(r2_df$R2[r2_df$Columna == "CO2_1"], 3))), 
            hjust = -0.1, color = "blue", size = 2.7) +
  
  geom_point(aes(y = CO2_2, color = "CO2_2 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_2, color = "CO2_2 Predicción"), linetype = "dashed") +
  geom_text(aes(x = max(tiempo_transcurrido_numeric/41.66), y = max(predicted_CO2_2), 
                label = paste0("R²: ", round(r2_df$R2[r2_df$Columna == "CO2_2"], 3))), 
            hjust = -0.1, color = "blue", size = 2.7) +
  
  geom_point(aes(y = CO2_3, color = "CO2_3 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_3, color = "CO2_3 Predicción"), linetype = "dashed") +
  geom_text(aes(x = max(tiempo_transcurrido_numeric/41.66), y = max(predicted_CO2_3), 
                label = paste0("R²: ", round(r2_df$R2[r2_df$Columna == "CO2_3"], 3))), 
            hjust = -0.1, color = "blue", size = 2.7) +
  
  #geom_point(aes(y = CO2_4, color = "CO2_4 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_4, color = "CO2_4 Predicción"), linetype = "dashed") +
  #geom_text(aes(x = max(tiempo_transcurrido_numeric), y = max(predicted_CO2_4), 
  #             label = paste0("R²: ", round(r2_df$R2[r2_df$Columna == "CO2_4"], 3))), 
  #         hjust = -0.1, color = "blue", size = 2.7) +
  
  #geom_point(aes(y = CO2_5, color = "CO2_5 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_5, color = "CO2_5 Predicción"), linetype = "dashed") +
  #geom_text(aes(x = max(tiempo_transcurrido_numeric), y = max(predicted_CO2_5), 
  #              label = paste0("R²: ", round(r2_df$R2[r2_df$Columna == "CO2_5"], 3))), 
  #          hjust = -0.1, color = "blue", size = 2.7) +
  
  #geom_point(aes(y = CO2_6, color = "CO2_6 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_6, color = "CO2_6 Predicción"), linetype = "dashed") +
  #geom_text(aes(x = max(tiempo_transcurrido_numeric), y = max(predicted_CO2_6), 
  #             label = paste0("R²: ", round(r2_df$R2[r2_df$Columna == "CO2_6"], 3))), 
  #         hjust = -0.1, color = "blue", size = 2.7) +

  
  #geom_point(aes(y = CO2_7, color = "CO2_7 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_7, color = "CO2_ 7Predicción"), linetype = "dashed") +
  #geom_text(aes(x = max(tiempo_transcurrido_numeric), y = max(predicted_CO2_7), 
   #             label = paste0("R²: ", round(r2_df$R2[r2_df$Columna == "CO2_7"], 3))), 
    #        hjust = -0.1, color = "blue", size = 2.7) +
  
  #geom_point(aes(y = CO2_8, color = "CO2_8 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_8, color = "CO2_8 Predicción"), linetype = "dashed") +
  #geom_text(aes(x = max(tiempo_transcurrido_numeric), y = max(predicted_CO2_8), 
   #             label = paste0("R²: ", round(r2_df$R2[r2_df$Columna == "CO2_8"], 3))), 
    #        hjust = -0.1, color = "blue", size = 2.7) +
  
  #geom_point(aes(y = CO2_9, color = "CO2_9 Datos Reales")) +
  #geom_line(aes(y = predicted_CO2_9, color = "CO2_9 Predicción"), linetype = "dashed") +
  #geom_text(aes(x = max(tiempo_transcurrido_numeric), y = max(predicted_CO2_9), 
   #             label = paste0("R²: ", round(r2_df$R2[r2_df$Columna == "CO2_9"], 3))), 
    #        hjust = -0.1, color = "blue", size = 2.7) +
  
  geom_point(aes(y = CO2_combined, color = "Datos Reales Combinados")) +
  geom_line(aes(y = predicted_CO2_combined, color = "Predicción combinada"), linetype = "dashed") +
  geom_text(aes(x = max(tiempo_transcurrido_numeric/41.66), y = max(predicted_CO2_combined), 
                label = paste0("R²: ", round(r2_df$R2[r2_df$Columna == "CO2_combined"], 3))), 
            hjust = -0.1, color = "red", size = 3) +
  
  labs(
    x = "Tiempo Transcurrido (h)",
    y = "CO2",
    title = "Ajuste del Modelo Michaelis-Menten modificado",
    subtitle = "Datos: CO2, Muestra Marisol 1",
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
    "Datos Reales Combinados" = "yellow",
    "Predicción combinada" = "red"
  ))+
  theme(legend.text = element_text(size = 8))



##############3

####FINAL PLUS
ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_1, color = "CO2_1 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_1, color = "CO2_1 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_2, color = "CO2_2 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_2, color = "CO2_2 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_3, color = "CO2_3 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_3, color = "CO2_3 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_4, color = "CO2_4 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_4, color = "CO2_4 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_5, color = "CO2_5 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_5, color = "CO2_5 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_6, color = "CO2_6 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_6, color = "CO2_6 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_combined, color = "Datos Reales Combinados")) +
  geom_line(aes(y = predicted_CO2_combined, color = "Predicción combinada"), linetype = "dashed") +
  geom_text(data = r2_df, aes(x = Inf, y = Inf, label = paste0("R² = ", round(R2, 2)), color = Columna), 
            hjust = -0.1, vjust = -0.5, size = 3.5, nudge_x = 0.5, nudge_y = 0.5) +
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
    "Datos Reales Combinados"="yellow",
    "Predicción combinada"="red"
  ))

####
annotate("text", x = 1500, y = max(combined_data$CO2_1, na.rm = TRUE) * 0.9, 
         label = paste0("R² (CO2_1) = ", round(r2_values[1], 2)), color = "blue") +
  annotate("text", x = 1500, y = max(combined_data$CO2_2, na.rm = TRUE) * 0.85, 
           label = paste0("R² (CO2_2) = ", round(r2_values[2], 2)), color = "blue") +
  annotate("text", x = 1500, y = max(combined_data$CO2_3, na.rm = TRUE) * 0.8, 
           label = paste0("R² (CO2_3) = ", round(r2_values[3], 2)), color = "blue") +
  annotate("text", x = 1500, y = max(combined_data$CO2_4, na.rm = TRUE) * 0.75, 
           label = paste0("R² (CO2_4) = ", round(r2_values[4], 2)), color = "blue") +
  annotate("text", x = 1500, y = max(combined_data$CO2_5, na.rm = TRUE) * 0.7, 
           label = paste0("R² (CO2_5) = ", round(r2_values[5], 2)), color = "blue") +
  annotate("text", x = 1500, y = max(combined_data$CO2_6, na.rm = TRUE) * 0.65, 
           label = paste0("R² (CO2_6) = ", round(r2_values[6], 2)), color = "blue") +
  annotate("text", x = 1500, y = max(combined_data$CO2_combined, na.rm = TRUE) * 0.6, 
           label = paste0("R² (CO2 Combined) = ", round(r2_values[7], 2)), color = "red")
#########################################################3

# Agregar el cálculo de R² para CO2_combined y predicted_CO2_combined
valores_observados_combined <- combined_data$CO2_combined
predicciones_combined <- combined_data$predicted_CO2_combined

# Asegurarse de que no hay valores NA
valid_idx_combined <- !is.na(valores_observados_combined) & !is.na(predicciones_combined)
valores_observados_combined <- valores_observados_combined[valid_idx_combined]
predicciones_combined <- predicciones_combined[valid_idx_combined]

# Media de los valores observados
media_observados_combined <- mean(valores_observados_combined)

# Suma de cuadrados totales (SST) y residuales (SSR)
SST_combined <- sum((valores_observados_combined - media_observados_combined)^2)
SSR_combined <- sum((valores_observados_combined - predicciones_combined)^2)

# Cálculo de R²
R2_combined <- 1 - (SSR_combined / SST_combined)

# Agregar a la lista de resultados
resultados[["CO2_combined"]] <- list(modelo = modelo_respiracion_combined, R2 = R2_combined)

# Agregar R² de CO2_combined a la tabla de resultados
r2_df <- rbind(r2_df, data.frame(Columna = "CO2_combined", R2 = R2_combined, stringsAsFactors = FALSE))

# Mostrar la tabla actualizada
print(r2_df)

# Modificar el gráfico para agregar las etiquetas de R²
ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_1, color = "CO2_1 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_1, color = "CO2_1 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_2, color = "CO2_2 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_2, color = "CO2_2 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_3, color = "CO2_3 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_3, color = "CO2_3 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_4, color = "CO2_4 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_4, color = "CO2_4 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_5, color = "CO2_5 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_5, color = "CO2_5 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_6, color = "CO2_6 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_6, color = "CO2_6 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_combined, color = "Datos Reales Combinados")) +
  geom_line(aes(y = predicted_CO2_combined, color = "Predicción combinada"), linetype = "dashed") +
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Ajuste del Modelo Michaelis-Menten modificado",
    subtitle = "Datos: CO2",
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
    "Datos Reales Combinados" = "yellow",
    "Predicción combinada" = "red"
  )) +
  # Agregar etiquetas de R² al gráfico
  geom_text(aes(x = max(tiempo_transcurrido_numeric), y = max(CO2_1, na.rm = TRUE), 
                label = paste("R² =", round(resultados[["CO2_1"]]$R2, 3))), color = "blue", hjust = 1) +
  geom_text(aes(x = max(tiempo_transcurrido_numeric), y = max(CO2_combined, na.rm = TRUE), 
                label = paste("R² =", round(R2_combined, 3))), color = "red", hjust = 1)
##########


# Modificar el gráfico para agregar las etiquetas de R²
ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_1, color = "CO2_1 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_1, color = "CO2_1 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_2, color = "CO2_2 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_2, color = "CO2_2 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_3, color = "CO2_3 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_3, color = "CO2_3 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_4, color = "CO2_4 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_4, color = "CO2_4 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_5, color = "CO2_5 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_5, color = "CO2_5 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_6, color = "CO2_6 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_6, color = "CO2_6 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_combined, color = "Datos Reales Combinados")) +
  geom_line(aes(y = predicted_CO2_combined, color = "Predicción combinada"), linetype = "dashed") +
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Ajuste del Modelo Michaelis-Menten modificado",
    subtitle = "Datos: CO2",
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
    "Datos Reales Combinados" = "yellow",
    "Predicción combinada" = "red"
  )) +
  # Agregar etiquetas de R² al gráfico
  geom_text(
    aes(
      x = max(tiempo_transcurrido_numeric, na.rm = TRUE),
      y = max(CO2_1, na.rm = TRUE), 
      label = ifelse(!is.na(resultados[["CO2_1"]]$R2), paste("R² =", round(resultados[["CO2_1"]]$R2, 3)), "R² = NA")
    ), 
    color = "blue", 
    hjust = 1
  ) +
  geom_text(
    aes(
      x = max(tiempo_transcurrido_numeric, na.rm = TRUE),
      y = max(CO2_combined, na.rm = TRUE), 
      label = ifelse(!is.na(R2_combined), paste("R² =", round(R2_combined, 3)), "R² = NA")
    ), 
    color = "red", 
    hjust = 1
  )
##############################3


ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_1, color = "CO2_1 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_1, color = "CO2_1 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_2, color = "CO2_2 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_2, color = "CO2_2 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_3, color = "CO2_3 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_3, color = "CO2_3 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_4, color = "CO2_4 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_4, color = "CO2_4 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_5, color = "CO2_5 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_5, color = "CO2_5 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_6, color = "CO2_6 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_6, color = "CO2_6 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_combined, color = "Datos Reales Combinados")) +
  geom_line(aes(y = predicted_CO2_combined, color = "Predicción combinada"), linetype = "dashed") +
  labs(
    x = "Tiempo Transcurrido (s)",
    y = "CO2",
    title = "Ajuste del Modelo Michaelis-Menten modificado",
    subtitle = "Datos: CO2",
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
    "Datos Reales Combinados" = "yellow",
    "Predicción combinada" = "red"
  )) +
  # Agregar etiquetas de R² para cada línea en posiciones específicas
  geom_text(
    data = data.frame(x = Inf, y = max(combined_data$CO2_1, na.rm = TRUE), label = paste("R² =", round(resultados[["CO2_1"]]$R2, 3))),
    aes(x = x, y = y, label = label), 
    color = "blue", 
    hjust = 1,
    inherit.aes = FALSE
  ) +
  geom_text(
    data = data.frame(x = Inf, y = max(combined_data$CO2_combined, na.rm = TRUE), label = paste("R² =", round(R2_combined, 3))),
    aes(x = x, y = y, label = label), 
    color = "red", 
    hjust = 1,
    inherit.aes = FALSE
  )
###################################3




# Agregar etiquetas de R² a cada curva en la leyenda
ggplot(combined_data, aes(x = tiempo_transcurrido_numeric)) +
  geom_point(aes(y = CO2_1, color = "CO2_1 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_1, color = "CO2_1 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_2, color = "CO2_2 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_2, color = "CO2_2 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_3, color = "CO2_3 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_3, color = "CO2_3 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_4, color = "CO2_4 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_4, color = "CO2_4 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_5, color = "CO2_5 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_5, color = "CO2_5 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_6, color = "CO2_6 Datos Reales")) +
  geom_line(aes(y = predicted_CO2_6, color = "CO2_6 Predicción"), linetype = "dashed") +
  geom_point(aes(y = CO2_combined, color = "Datos Reales Combinados")) +
  geom_line(aes(y = predicted_CO2_combined, color = "Predicción combinada"), linetype = "dashed") +
  geom_text(data = r2_df, aes(x = Inf, y = Inf, label = paste0(Columna, ": R² = ", round(R2, 2))), 
            hjust = -0.1, vjust = -0.5, size = 3.5, nudge_x = 0.5, nudge_y = 0.5, show.legend = FALSE) +
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
    "Datos Reales Combinados"="yellow",
    "Predicción combinada"="red"
  )) +
  theme(legend.text = element_text(size = 8))

