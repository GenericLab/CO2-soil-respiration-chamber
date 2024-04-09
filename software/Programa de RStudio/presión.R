ggplot(data1, aes(x = tiempo_transcurrido, y = field7)) +
  geom_point() +
  geom_line(colour="red") +
  labs(x = "Tiempo", 
       y = "Presión ", 
       title = "Mediciones de Presión")+
  ggtitle("Mediciones de Presión",
          subtitle = "Muestra OT1b Cámara 1")

ggplot(data2, aes(x = tiempo_transcurrido, y = field7)) +
  geom_point() +
  geom_line(colour="red") +
  labs(x = "Tiempo", 
       y = "Presión ", 
       title = "Mediciones de Presión")+
  ggtitle("Mediciones de Presión",
          subtitle = "Muestra OT2b Cámara 2")
