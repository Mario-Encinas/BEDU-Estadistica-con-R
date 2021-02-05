#Ahora investigarás la dependencia o independencia del número de goles anotados por el equipo de casa y el número de goles anotados por el equipo visitante mediante un procedimiento denominado bootstrap, revisa bibliografía en internet para que tengas nociones de este desarrollo.

#Librerias ####
# setwd("C:/Users/Orlando/Documents/BEDU/Modulo 2- R y Python/R/Postwork")
# install.packages("rsample")
library(ggplot2)
library(dplyr)
library(rsample)
#####




#Parte 1 ----
#Ya hemos estimado las probabilidades conjuntas de que el equipo de casa anote X=x goles (x=0,1,... ,8),
#y el equipo visitante anote Y=y goles (y=0,1,... ,6), en un partido. Obtén una tabla de cocientes al 
#dividir estas probabilidades conjuntas por el producto de las probabilidades marginales correspondientes.

#Obtenemos la base de datos 
df.1718 <- read.csv('https://www.football-data.co.uk/mmz4281/1718/SP1.csv')
df.1819 <- read.csv('https://www.football-data.co.uk/mmz4281/1819/SP1.csv')
df.1920 <- read.csv('https://www.football-data.co.uk/mmz4281/1920/SP1.csv')
suppressMessages(library(dplyr))
df.1920<-df.1920[,-3]
df<-list(df.1718,df.1819,df.1920)
df<-lapply(df,select,Date:FTR)
df<-lapply(df,mutate,Date=as.Date(sub("00","20",as.character(as.Date(Date,format="%d/%m/%Y")))))
df[df.1718$Date]
df<-do.call(rbind,df)


base<-df
base<-base[,c("FTHG","FTAG")]

df.home<-base$FTHG
df.visit<-base$FTAG

# Calculamos probabilidades
prob.home<-prop.table(table(base$FTHG))
prob.visit<-prop.table(table(base$FTAG))
conjunta<-prop.table(table(base$FTHG,base$FTAG))
conjunta
cocientes<-conjunta

# Calculamos tabla cociente
for(i in 1:9){
for(j in 1:7){

cocientes[i,j]<-cocientes[i,j]/(prob.home[i]*prob.visit[j])

}  
}

cocientes
# Graficamos con un heatmap la matriz de cocientes

distancias<-(cocientes-1)^2
  distancias
as.data.frame(distancias)

ggplot(as.data.frame(distancias),aes(Var1,Var2,fill=Freq)) + geom_tile()
#----


#Parte 2 -----
#Mediante un procedimiento de boostrap, obtén más cocientes similares a los obtenidos en la tabla del punto anterior.
#Esto para tener una idea de las distribuciones de la cual vienen los cocientes en la tabla anterior. Menciona en cuáles
#casos le parece razonable suponer que los cocientes de la tabla en el punto 1, son iguales a 1 (en tal caso tendríamos 
#independencia de las variables aleatorias X y Y).


#observando la conjunta, decidimos reducir nuestra matriz de probabilidad conjunta para que solo tome valores de x,y=0,1,2,3,4.
conjunta<-conjunta[1:5,1:5]

cocientes_list<-list() # Creamos una lista para guardar cada table de cocientes.

cocientes<-matrix(0,5,5) # Redefinimos la tabla como una matriz de 5x5
medias<-0 # Creamos un vector para guardar las medias de cada tabla de cocientes.



# Calculamos 1000 tablas de cocientes por medio de un reemuestreo con reemplazo
for(n in 1:1000){

resample<-sample(1:nrow(base),nrow(base),replace = TRUE)


conjunta<-prop.table(table(df.home[resample],df.visit[resample]))

conjunta<-conjunta[1:5,1:5]

prob.home<-prop.table(table(df.home[resample]))
prob.home<-prob.home[1:5]

prob.visit<-prop.table(table(df.visit[resample]))
prob.visit<-prob.visit[1:5]

colnames(cocientes)<-c(0,1,2,3,4)
rownames(cocientes)<-c(0,1,2,3,4)

# Calculamos la tabla de cocientes
for(i in 1:length(prob.home)){
  for(j in 1:length(prob.visit)){
    
    cocientes[i,j]<-conjunta[i,j]/(prob.home[i]*prob.visit[j])
    
  }  
}
medias[n]<-mean(cocientes)
cocientes_list[[n]]<-cocientes
}





## Graficamos las medias obtenidas
medias<-as.data.frame(medias)
ggplot(medias) + geom_histogram(aes(x=medias),bins=40) + geom_vline(aes(xintercept = mean(medias),color="Media global"),linetype="dashed") + labs(title = "Distribución de medias de tablas cociente",x="Medias",y="Frecuencia")


#Para determinar si son independientes, realizaremos una prueba de hipótesis.
#Utilizaremos la media como estadístico, para representar la dependencia o independencia de las variables en cuestión
library(normtest)
require(nortest)


#Realizamos pruebas de normalidad de nuestra poblacion de medias
###Utilizamos la prueba no paramétrica de pearson para la Normalidad
norm.tests<-0

ad<-ad.test(medias$medias)
li<-lillie.test(medias$medias)
pear<-pearson.test(medias$medias)
sw<-shapiro.test(medias$medias)
ks<-ks.test(medias$medias,'pnorm')

norm.tests<-c(ad$p.value,li$p.value,pear$p.value,sw$p.value,ks$p.value)

names(norm.tests)<-c("Anderson Darling","Lilliefors","Pearson","Shapiro'Wilks","Kolmogorov-Smirnof")
norm.tests #Todas las pruebas rechazan normalidad, ya que sus H0 es que las medias provienen de una distribución normal. Todos los pvalues<.05, lo cual rechaza normalidad.

#Realizamos una prueba no paramétrica, la Wilcoxon, la cual escogimos ya que la distribución se asemeja a una simétrica.
wilcox.test(medias$medias,alternative = "two.sided",mu=1)

# con un p-valor muy pequeño, se rechaza la hipotesis de que nuestra medias es igual a 1, por lo que rechazamos independencia de variables.

# Esto coincide con la naturaleza de las variables. Durante un partido, influye mucho la marcación del otro equipo con la tuya.
# Si un equipo lleva una ventaja considerable (de 2 o mas goles), la estrategia más común es jugar a la defensiva y no seguir acumulando puntos.
# De esta manera, la marcación de un equipo depende de la del otro




