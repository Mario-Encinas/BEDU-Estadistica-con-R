# POSTWORK 2
  
  
# 1.----
#Importa los datos de soccer de las temporadas 2017/2018, 2018/2019 y 2019/2020 de la primera divisi�n de la liga espa�ola a R, los datos los puedes encontrar en el siguiente enlace: https://www.football-data.co.uk/spainm.php


df.1718 <- read.csv('https://www.football-data.co.uk/mmz4281/1718/SP1.csv')
df.1819 <- read.csv('https://www.football-data.co.uk/mmz4281/1819/SP1.csv')
df.1920 <- read.csv('https://www.football-data.co.uk/mmz4281/1920/SP1.csv')
#----

  
# 2.----
#Obten una mejor idea de las caracter�sticas de los data frames al usar las funciones: str, head, View y summary


str(df.1718)
head(df.1718)
View(df.1718)
summary(df.1718) 

str(df.1819) 
head(df.1819)
View(df.1819)
summary(df.1819)

str(df.1920)
head(df.1920)
View(df.1920)
summary(df.1920)

#----
  
# 3.----
# Con la funci�n select del paquete dplyr selecciona �nicamente las columnas Date, HomeTeam, AwayTeam, FTHG, FTAG y FTR; esto para cada uno de los data frames. (Hint: tambi�n puedes usar lapply).

suppressMessages(library(dplyr))
df.1920<-df.1920[,-3] # Eliminamos la columna Tiempo de este data frame
df<-list(df.1718,df.1819,df.1920)
df<-lapply(df,select,Date:FTR)

# ----
  
# 4.----
# Aseg�rate de que los elementos de las columnas correspondientes de los nuevos data frames sean del mismo tipo (Hint 1: usa as.Date y mutate para arreglar las fechas). Con ayuda de la funci�n rbind forma un �nico data frame que contenga las seis columnas mencionadas en el punto 3 (Hint 2: la funci�n do.call podr�a ser utilizada).


head(as.Date(df.1718$Date,format="%d/%m/%Y"))


# Observamos que al utilizar la funci�n as.Date, nos convierte la fecha en formato extra�o.

#Lo corregimos reemplazando el string "00" con el string "20", y convertrimos de nuevo a Fecha:
  

df<-lapply(df,mutate,Date=as.Date(sub("00","20",as.character(as.Date(Date,format="%d/%m/%Y")))))
df<-do.call(rbind,df)
head(df)


