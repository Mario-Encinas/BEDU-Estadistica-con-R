#POSTWORK 1
  
# 1.----
#Importación de los datos de soccer de la temporada 2019/2020 de la primera división de la liga española recopilados en https://www.football-data.co.uk/spainm.php. Los datos se almacenan en el dataframe df.primera_division.

df.primera_division <- read.csv('https://www.football-data.co.uk/mmz4281/1920/SP1.csv')
names(df.primera_division)
#----


 
# 2.----
#Del dataframe completo se extraen las variables correspondientes a los goles anotados por el equipo de casa (FTHG) y los anotados por el equipo visitante (FTAG) en cada partido, y se almacenan ambas columnas en el dataframe df.goles.

df.goles <- df.primera_division[, c("FTHG", "FTAG")]
 
#----



# 3.----
#Una vez extraídos los datos de los goles aislados, se generan las tablas de frecuencia para posteriormente calcular los valores de probabilidad del número de goles anotados. Con la función table, se agrupan el número de renglones en las que cada valor del número de goles sucedió. Esto es análogo a las funciones GROUP BY y COUNT de MySQL. 
#Primero, se genera la tabla de frecuencias de los goles anotados por el equipo de casa:
  

table(df.goles$FTHG)


#Utilizando el enfoque de probabilidad clásica, se calculan las siguientes probabilidades:
  
#  - La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x = 0, 1, 2, ...)

#Se divide el vector de frecuencias entre el número total de partidos:
  

table(df.goles$FTHG) / nrow(df.primera_division)
prop.table(table(df.goles$FTHG))

#*La función prop.table realiza esta operación de división automáticamente.*
  


#- La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y = 0, 1, 2, ...)

#La misma operación se realiza para los goles anotados por el equipo visitante:
  

prop.table(table(df.goles$FTAG))




#- La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x = 0, 1, 2, ..., y = 0, 1, 2, ...)

#Por último, se aplica la misma función para calcular la probabilidad bivariada de que ambos equipos anoten x y y número de goles:
  

prop.table(table(df.goles))
