

#1.Con el último data frame obtenido en el postwork de la sesión 2, elabora tablas de frecuencias relativas para estimar las siguientes probabilidades:
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

#La probabilidad (marginal) de que el equipo que juega en casa anote x goles (x=0,1,2,)

prop.table(table(base$FTHG))

#La probabilidad (marginal) de que el equipo que juega como visitante anote y goles (y=0,1,2,)

prop.table(table(base$FTAG))
#La probabilidad (conjunta) de que el equipo que juega en casa anote x goles y el equipo que juega como visitante anote y goles (x=0,1,2,, y=0,1,2,)

prop.table(table(base$FTHG,base$FTAG))

#Realiza lo siguiente:
#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo de casa
dfH<-as.data.frame(prop.table(table(base$FTHG)))
suppressMessages(library(ggplot2))

ggplot(dfH,aes(Var1,Freq))+geom_bar(stat = "identity",fill='blue4')+scale_color_brewer(palette = "Set2")+labs(title="Probabilidades del equipo Visitante", subtitle = "Masa de probabilidad", x="Goles",y="Probabilidad") + theme(legend.position = "top")


#Un gráfico de barras para las probabilidades marginales estimadas del número de goles que anota el equipo visitante.
dfA<-as.data.frame(prop.table(table(base$FTAG)))
ggplot(dfA,aes(Var1,Freq))+geom_bar(stat = "identity",fill='darkred')+scale_color_brewer(palette = "Set2")+labs(title="Probabilidades del equipo de Casa", subtitle = "Masa de probabilidad", x="Goles",y="Probabilidad") + theme(legend.position = "top")

#Un HeatMap para las probabilidades conjuntas estimadas de los números de goles que anotan el equipo de casa y el equipo visitante en un partido.

dfHA<-as.data.frame(prop.table(table(base$FTHG,base$FTAG)))
ggplot(dfHA,aes(Var1,Var2,fill=Freq))+geom_tile()+labs(title="Probabilidades Conjunta", x="Equipo de Casa",y="Equipo Visitante")
