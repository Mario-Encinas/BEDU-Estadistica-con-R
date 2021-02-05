
## Desarrollo

  
  #### Importa el conjunto de datos match.data.csv a R y realiza lo siguiente:
  

library(knitr)
library(ggplot2)
library(dplyr)
library(ggfortify)



df <- read.csv("https://raw.githubusercontent.com/beduExpert/Programacion-con-R-Santander/master/Sesion-06/Postwork/match.data.csv")
#Agrega una nueva columna sumagoles que contenga la suma de goles por partido.
df <- mutate(df, sumagoles = home.score + away.score)
df <- mutate(df, date = as.Date(date, "%Y-%m-%d"))
# Obtén el promedio por mes de la suma de goles.
  
#Se crea otro dataframe con el rango completo de los datos de match.data.csv, incluyendo aquellos meses en los que no hay partidos (junio y julio).

date.full <- data.frame( date = seq(min(df$date), max(df$date),
                                    by = "1 month"))


#Se restan los caracteres de los días en los observables de la variable "date". Esto convierte a los valores en strings.

df$date <- substr(df$date, 1, 7)
date.full$date <- substr(date.full$date, 1, 7)


#Se agrupan los datos:
  

promedios <- df %>%
  select(date, sumagoles) %>%
  group_by(date) %>%
  summarise(Promedio = mean(sumagoles))




kable(head(promedios),caption = "Promedio de goles por partido agrupados por mes")


#### Crea la serie de tiempo del promedio por mes de la suma de goles hasta diciembre de 2019.

# Se mezclan los dataframes de los promedios agrupados y las fechas completas, de tal forma que se generan renglones para los meses faltantes (junio y julio) con valores de promedio NA

promedios2 <- merge(date.full, promedios, by = "date", all.x = TRUE)
ts.prom <- ts(promedios2$Promedio, start = c(2010,8), end = c(2019,12), frequency = 12)

## Grafica la serie de tiempo.



autoplot(ts.prom, ts.colour = "blue1", ts.linetype = "solid") + labs(title = "Promedio de goles por partido", x="Mes", y="Promedio")


