#! /bin/bash

# +---------------------------------------------------------------------------+
# | Récupère le menu du jour de la cantine de l'école des Dinarelles.         |
# +---------------------------------------------------------------------------+

# +---------------------------------------------------------------------------+
# |  Fichier     : Cantine.glet                                               |
# |  Version     : 1.0.0                                                      |
# |  Auteur      : Bruno Boissonnet                                           |
# |  Date        : 19/09/2017                                                 |
# +---------------------------------------------------------------------------+


# Algorithme :
#
#  1. On calcule le décalage entre le jour en cours et le prochain jour de cantine (car il n'y a pas cantine tous les jours et on veut afficher le menu du prochain jour de cantine)
#  2. On récupère le mois en cours
#  3. On récupère le mois suivant
#  4. On récupère la date d'aujourd'hui
#  5. On récupère la date de demain
#  6. Utiliser la commande `curl --silent` pour récupérer le code source de la page
#  7. On efface les dix dernières lignes du fichier pour ne pas lire des caractères qui ne sont pas en UTF-8
#  8. On supprime les double espaces et les espaces dans les balises et juste avant/après
#  9. On récupère les menus du mois en cours
# 10. On ne garde que la deuxième ligne
# 11. On ne garde que ce qu'il y a entre <strong>${AUJOURDHUI}<\/strong> et <strong>${DEMAIN}<\/strong>
# 12. On remplace <br /> par des sauts de ligne
# 13. On efface les lignes vides


# +---------------------------------------------------------------------------+
# |                             FONCTIONS                                     |
# +---------------------------------------------------------------------------+


main()
{
	# On récupère le mois en cours
	MOIS=$(aujourd_hui +%B)                                 # => septembre
	MOIS=$(premiereLettreEnMajuscule $MOIS)                 # => Septembre
	# echo $MOIS
	
	# On récupère le mois suivant
	MOIS_SUIVANT=$(aujourd_hui -v+1m +%B)                   # => octobre
	MOIS_SUIVANT=$(premiereLettreEnMajuscule $MOIS_SUIVANT) # => Octobre
	# echo $MOIS_SUIVANT

	# On récupère la date d'aujourd'hui (format : Jour N°)
	AUJOURDHUI=$(aujourd_hui "+%A %-d")                     # => Lundi 2, Mardi 15 ou Jeudi 27   
	# echo $AUJOURDHUI
	
	# On récupère la date de demain (format : Jour N°)
	DEMAIN=$(aujourd_hui -v+1d "+%A %-d")                    # => Mardi 3, Mercredi 16 ou Vendredi 28
	# echo $DEMAIN
	# exit	
	
	# On récupère le menu de la cantine
	MENU=$(menu_cantine)
	# echo "$MENU"

	if [ -z "$MENU" ]; then
		echo "Il n'y a pas de cantine ce jour : "$(aujourd_hui "+%A %-d %B %Y")
	else
		echo "Menu du "$(aujourd_hui "+%A %-d %B %Y")" :"
		echo "$MENU"
	fi

}

# Mets la première lettre du mot en majuscule
# $1 : le mot dont la première lettre doit être mise en majuscule
# exemple : septembre => Septembre
premiereLettreEnMajuscule()
{
	echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}" # => Septembre
}


# On récupère la date du prochain jour de cantine
# Aujourd'hui si on est lundi, mardi, mercredi ou jeudi
# lundi si on est vendredi/samedi/dimanche
# $1 : formatage (%B pour le mois, %A %-d pour jour n°)
# retour : date au format spécifié
aujourd_hui()
{
	# formatage date => voir man sfrtime
	# %A  : le jour de la semaine
	# %d  : le numéro du jour dans le mois
	# %-* : ne préfixe pas les numéros par des 0
	# -v(+/-)*  : ajoute ou retranche des unités (d pour jour, m pour mois, y pour année)
	dec=$(decalage)
	# echo $@
	date -v+${dec}d "$@"
}

# On calcule le décalage par rapport à aujourd'hui pour avoir
# le prochain jour de cantine
# Renvoi : le nombre de jours de décalage par rapport à la date du jour
# Exemples :
# Vendredi => Lundi : 3 jours
# Samedi   => Lundi : 2 jours
# Dimanche => Lundi : 1 jours
# Mercredi => Jeudi : 1 jours
decalage()
{
	# formatage date => voir man sfrtime
	# %A  : le jour de la semaine
	i=$(date +%A)
	# echo $i
	if [ $i == "Vendredi" ]; then
		# demain = lundi = jour + 3
		RET=3
	elif [ $i == "Samedi" ]; then
		# demain = lundi = jour + 2
		RET=2
	elif [ $i == "Dimanche" -o $i == "Mercredi" ]; then
		# demain = lundi = jour + 1
		RET=1
	else
		# aujourd'hui
		RET=0
	fi
	
	echo $RET
}


# Renvoi le menu de la cantine de Rémy
# Récupéré sur le site de la mairie des Angles
# puis passé à la moulinette de sed
menu_cantine()
{
	curl --silent "http://www.ville-les-angles.fr/fr/menus-des-cantines-1-3-54" | \
	# On efface les dix dernières lignes du fichier pour ne pas lire des caractères qui ne sont pas en UTF-8
	sed -e :a -e '$d;N;2,10ba' -e 'P;D' | \
	# On supprime les double espaces et les espaces dans les balises et juste avant/après
	sed -nE -e 's/[ ][ ]/ /gp' -e 's/([ ]<|<[ ]|[ ]<[ ])/</gp' -e 's/([ ]>|>[ ]|[ ]>[ ])/>/gp' | \
	# On récupère les menus du mois en cours
	sed -n "/<h3>${MOIS}<\/h3>/,/<h3>${MOIS_SUIVANT}<\/h3>/p" | \
	# On ne garde que la deuxième ligne
	sed -n '2p' | \
	# On ne garde que ce qu'il y a entre <strong>${AUJOURDHUI}<\/strong> et <strong>${DEMAIN}<\/strong>
	sed -nE "s/.+<strong>${AUJOURDHUI}<\/strong>(.+)<strong>${DEMAIN}<\/strong>.+/\1/p" | \
	# On remplace <br /> par des sauts de ligne
	sed $'s/<br \/>/\\\n/g' | \
	# On efface les lignes vides
	sed '/^$/d'
}



# +---------------------------------------------------------------------------+
# |                        DÉBUT DU PROGRAMME                                 |
# +---------------------------------------------------------------------------+

main $@

