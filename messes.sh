#! /bin/bash

# +---------------------------------------------------------------------------+
# | Récupère l'heure et le lieu de la prochaine messe dominicale aux Angles.  |
# +---------------------------------------------------------------------------+

# +---------------------------------------------------------------------------+
# |  Fichier     : Messe.glet                                                 |
# |  Version     : 1.0.0                                                      |
# |  Auteur      : Bruno Boissonnet                                           |
# |  Date        : 12/09/2017                                                 |
# +---------------------------------------------------------------------------+


# Algorithme :
#
# 1. Récupérer la date du jour
# 2. Calculer le nombre de jours avant le prochain dimanche
# 3. Récupérer la date du prochain dimanche
# 4. Formater cette date (AAA-MM-JJ)
# 5. Créer l'adresse web qui affichera la prochaine messe à cette date (en ce lieu)
# 6. Utiliser la commande `curl --silent` pour récupérer le code source de la page
# 7. Trouver la ligne qui affiche le lieu de la messe
# 8. Trouver la ligne qui affiche l'heure de la messe
# 9. Utiliser sed pour récupérer le lieu de la messe
# 10. Utiliser sed pour récupérer l'heure de la messe




VILLE=ANGLES
DEPARTEMENT=30
CODE_POSTAL=30133


# +---------------------------------------------------------------------------+
# |                             FONCTIONS                                     |
# +---------------------------------------------------------------------------+


main()
{
	DATE_FORMATEE_PROCHAIN_DIMANCHE=$(dateFormateeDuProchainDimanche)
	#echo $DATE_FORMATEE_PROCHAIN_DIMANCHE
	#DATE_FORMATEE_PROCHAIN_DIMANCHE=12-11-2017
	
	ADRESSE=$(construitURL ${VILLE} ${DEPARTEMENT} ${CODE_POSTAL} ${DATE_FORMATEE_PROCHAIN_DIMANCHE})
	#echo $ADRESSE
	
	echo "Prochaine messe : "
	RESULTAT=$(dateEtHeureMesse ${ADRESSE})  # => 2017-09-17T09:30
	if [ "$RESULTAT" == "" ]; then
		echo "ATTENTION ! Pas de messe aux Angles le "$DATE_FORMATEE_PROCHAIN_DIMANCHE
	else
		echo ${RESULTAT}
		lieuMesse ${ADRESSE}                 # => Notre Dame de l'Assomption (Eglise des Angles)
	fi
}

# Renvoie le jour de la semaine
# retour : forme raccourcie (ex : sun ou Dim)
jourDeLaSemaine()
{
	# date => Mar 12 sep 2017 11:52:32 CEST

	# Récupère tout mais remplace par ce qu'il y a entre parenthèses
	# (le mot qui commence la phrase
	# et qui est composé d'une majuscule et de 
	# deux minuscules)
	# date | sed -nE 's/([A-Z][a-z]{2})[ ].*/\1/p'

	# Récupère tout mais remplace par ce qu'il y a entre parenthèses
	# (tous les caractères qui ne sont pas des espaces)
	date | sed -nE 's/([^ ]*).*/\1/p'
}

# Renvoie le nombre de jours avant dimanche
# retour : un nombre entre 0 et 6 (-1 si erreur)
nombreDeJoursAvantDimanche()
{
	JOUR=$(jourDeLaSemaine)
	#echo $JOUR

	# Compte le nombre de jour qui nous sépare de dimanche
	if [ "$JOUR" == "Sun" -o "$JOUR" == "Dim" ]; then
		NB_JOUR=0
	elif [ "$JOUR" == "Mon" -o "$JOUR" == "Lun" ]; then
		NB_JOUR=6
	elif [ "$JOUR" == "Tue" -o "$JOUR" == "Mar" ]; then
		NB_JOUR=5
	elif [ "$JOUR" == "Wed" -o "$JOUR" == "Mer" ]; then
		NB_JOUR=4
	elif [ "$JOUR" == "Thu" -o "$JOUR" == "Jeu" ]; then
		NB_JOUR=3
	elif [ "$JOUR" == "Fri" -o "$JOUR" == "Ven" ]; then
		NB_JOUR=2
	elif [ "$JOUR" == "Sat" -o "$JOUR" == "Sam" ]; then
		NB_JOUR=1
	else
		echo "Jour inconnu !"
		NB_JOUR=-1
	fi

	echo ${NB_JOUR}
}


# Renvoie la date formatée du prochain dimanche
# retour : JJ-MM-AAA
dateFormateeDuProchainDimanche()
{
	NB_JOUR=$(nombreDeJoursAvantDimanche)
	date -v+${NB_JOUR}d "+%d-%m-%Y"
}


# Crée l'URL nécessaire pour récupérer la prochaine messe
# de la ville spécifiée à la date spécifiée
# $1: Ville
# $2: Département
# $3: Code postal
# $4: Date formatée (JJ-MM-AAA)
# retour : l'URL correcte pour le site messes.info
construitURL()
{
	echo https://www.messes.info/horaires/${1}%20.fr%20${2}%20${3}%20${4}
}

# Récupère la date et l'heure formatée de la prochaine messe
# $1: URL du site que l'on questionne
# retour : JJ/MM/AAAA à HHhMM
dateEtHeureMesse()
{
	curl --silent "${1}" | sed -nE 's/<meta itemprop=\"startDate\" content="([0-9]{4}-[0-9]{2}-[0-9]{2}T[0-9]{2}:[0-9]{2})\">/\1/p' | sed -nE 's/([0-9]{4})-([0-9]{2})-([0-9]{2})T([0-9]{2}):([0-9]{2})/\3\/\2\/\1 à \4h\5/p'
}

# Récupère le lieu de la prochaine messe
# $1: URL du site que l'on questionne
# retour : une chaîne représentant le lieu
lieuMesse()
{
	# Correct mais trop compliqué :
	# curl --silent "${1}" | sed -nE -e '1 s/^.*<span itemprop=\"name\">(.+)<\/span> à.*$/\1/p; t' -e '1,// s//\1/p'
	curl --silent "${1}" | sed -nE 's/^.*itemprop=\"url\"><span itemprop=\"name\">([^<]*)<\/span>.*$/\1/p'
}


# +---------------------------------------------------------------------------+
# |                        DÉBUT DU PROGRAMME                                 |
# +---------------------------------------------------------------------------+


main

