
#Temperatura
ggplot(data1, aes(x = tiempo_transcurrido, y = field1)) +
  geom_point() +
  geom_line(colour="red") +
  labs(x = "Tiempo", 
       y = "Temperatura (°c)", 
       title = "Mediciones de Temperatura")+
  ggtitle("Mediciones de Temperatura",
          subtitle = "Muestra OT1b Cámara 1")

ggplot(data2, aes(x = tiempo_transcurrido, y = field1)) +
  geom_point() +
  geom_line(colour="red") +
  labs(x = "Tiempo", 
       y = "Temperatura (°c)", 
       title = "Mediciones de Temperatura")+
  ggtitle("Mediciones de Temperatura",
          subtitle = "Muestra OT2b Cámara 2")

#Humedad
ggplot(data1, aes(x = tiempo_transcurrido, y = field4)) +
  geom_point() +
  geom_line(colour="red") +
  labs(x = "Tiempo", 
       y = "Humedad relativa %", 
       title = "Sensor 1 mediciones de Humedad")+
  ggtitle("Humedad relativa %",
          subtitle = "Muestra OT1b Cámara 1")

ggplot(data2, aes(x = tiempo_transcurrido, y = field4)) +
  geom_point() +
  geom_line(colour="red") +
  labs(x = "Tiempo", 
       y = "Humedad relativa %", 
       title = "Sensor 1 mediciones de Humedad")+
  ggtitle("Humedad relativa %",
          subtitle = "Muestra OT2b Cámara 2")
