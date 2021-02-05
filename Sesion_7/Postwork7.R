#Alojar el fichero data.csv en una base de datos llamada match_games, nombrando al collection
#como match

#Una vez hecho esto, realizar un count para conocer el número de registros que se tiene en la base

#Realiza una consulta utilizando la sintaxis de Mongodb, en la base de datos para conocer el número
#de goles que metió el Real Madrid el 20 de diciembre de 2015 y contra que equipo jugó,
#¿perdió ó fue goleada?
  
#Por último, no olvides cerrar la conexión con la BDD

library(mongolite)

match <- mongo("match", "match_games",
      url = "mongodb+srv://Usuario:Contraseña@cursobedu.ftknr.mongodb.net/test?readPreference=primary&ssl=true")

match$count('{}')

game.madrid <- match$find('{"$and": [
                           {"Date": { "$gte" : { "$date" : "2015-12-20T00:00:00Z" }}},
                           {"Date": { "$lte" : { "$date" : "2015-12-20T00:00:00Z" }}}],
                           "$or": [
                           {"AwayTeam": "Real Madrid"},
                           {"HomeTeamTeam": "Real Madrid"}]}')


if (game.madrid$AwayTeam == "Real Madrid"){
  print(game.madrid$HomeTeam)
  print(game.madrid$FTAG)
  print(game.madrid$FTR)
}else{
  print(game.madrid$AwayTeam)
  print(game.madrid$FTHG)
  print(game.madrid$FTR)
}

rm(match)




