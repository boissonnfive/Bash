#! /bin/bash
#Smart Weather by enochou (mod boissonnfive)

# +---------------------------------------------------------------------------+
# |                      Récupère la météo du jour.                           |
# +---------------------------------------------------------------------------+

# +---------------------------------------------------------------------------+
# |  Fichier     : meteo.sh                                                   |
# |  Version     : 1.0.0                                                      |
# |  Auteur      : Bruno Boissonnet                                           |
# |  Date        : 19/09/2017                                                 |
# +---------------------------------------------------------------------------+



# +---------------------------------------------------------------------------+
# |                             FONCTIONS                                     |
# +---------------------------------------------------------------------------+


main()
{
	# On récupère la latitude du lieu du script
	lat=$(latitude)
	echo $lat
	# On récupère la longitude du lieu du script
	lon=$(longitude)
	echo $lon
	# On récupère le bilan météo du jour
	#bilan=$(meteo)
	#echo $bilan
	# On filtre la température sur le bilan météo du jour
	temperature=`temperature_meteo $bilan`
	echo $temperature
	# On filtre la description sur le bilan météo du jour
	description=$(description_meteo $bilan)
	echo $description

}

# Renvoi la latitude du lieu du script
latitude()
{
	geolocation=`curl -s ipinfo.io`
	coords=`echo $geolocation | python -c 'import json, sys; print json.load(sys.stdin)["loc"]'`
	lat=${coords%,*}
	echo $lat
}

# Renvoi la longitude du lieu du script
longitude()
{
	geolocation=`curl -s ipinfo.io`
	coords=`echo $geolocation | python -c 'import json, sys; print json.load(sys.stdin)["loc"]'`
	lon=${coords#*,}
	echo $lon
}

# Renvoi le bilan météo du jour
meteo()
{
	curl -s "http://api.openweathermap.org/data/2.5/weather?lat="43.96239920000001"&lon="4.762762000000066"&format=json&APPID=56b48ad9398e0fd64e55e00ff3f67689&units=metric"
}


# Renvoi la température à partir du bilan météo
# $1 : bilan météo
# retour : le nombre représentant la température (ex : 15)
temperature_meteo()
{
	bilan=`curl -s "http://api.openweathermap.org/data/2.5/weather?lat="43.96239920000001"&lon="4.762762000000066"&format=json&APPID=56b48ad9398e0fd64e55e00ff3f67689&units=metric"`
	temp=`echo $bilan | python -c 'import json, sys; print json.load(sys.stdin)["main"]["temp"]'`
	echo ${temp%%.*} # enlève les chiffres après la virgule
}

# Renvoi la température à partir du bilan météo
# $1 : bilan météo
# retour : description du temps (ex : « Ciel dégagé »)
description_meteo()
{
	bilan=`curl -s "http://api.openweathermap.org/data/2.5/weather?lat="43.96239920000001"&lon="4.762762000000066"&format=json&APPID=56b48ad9398e0fd64e55e00ff3f67689&units=metric"`
	description=`echo $bilan | python -c 'import json, sys; print json.load(sys.stdin)["weather"][0]["description"]'`
	if [ "$description" = "clear sky" ];then
		description="Ciel dégagé"
	elif [ "$description" = "light rain" ];then
		description="Pluie légère"
	elif [ "$description" = "moderate rain" ];then
		description="Pluie éparse"
	elif [ "$description" = "few clouds" ];then
		description="Légèrement nuageux"
	elif [ "$description" = "overcast clouds" ];then
		description="Couvert"
	elif [ "$description" = "broken clouds" ];then
		description="Éclaircies"
	elif [ "$description" = "scattered clouds" ];then
		description="Nuages épars"
	elif [ "$description" = "mist" ];then
		description="Brumeux"
	elif [ "$description" = "fog" ];then
		description="Brouillard"
	fi
	echo $description
}


# +---------------------------------------------------------------------------+
# |                        DÉBUT DU PROGRAMME                                 |
# +---------------------------------------------------------------------------+

main $@
exit

# Les Angles : coordonnées GPS :
# source : https://www.coordonnees-gps.fr
# Latitude : 43.96239920000001
# Longitude : 4.762762000000066
