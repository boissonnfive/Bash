#! /bin/bash -x

# +---------------------------------------------------------------------------+
# | Récupère le menu du jour de la cantine de l'école des Dinarelles.         |
# +---------------------------------------------------------------------------+

# +---------------------------------------------------------------------------+
# |  Fichier     : Cantine.glet                                               |
# |  Version     : 1.0.1                                                      |
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
#  9. On récupère les menus du mois en cours
# 10. On ne garde que ce qu'il y a après <strong>${AUJOURDHUI}<\/strong>
# 11. On remplace <br /> par des sauts de ligne
# 12. On efface les lignes vides


# +---------------------------------------------------------------------------+
# |                             FONCTIONS                                     |
# +---------------------------------------------------------------------------+


main()
{
	# On récupère le mois en cours
	MOIS_EN_COURS=$(mois_en_cours)
	MOIS_EN_COURS=$(premiereLettreEnMajuscule $MOIS_EN_COURS)                 # => Septembre
	# MOIS_EN_COURS="Mars"
	#echo $MOIS_EN_COURS
	
	# On récupère le mois suivant
	MOIS_PROCHAIN=$(mois_prochain)
	MOIS_PROCHAIN=$(premiereLettreEnMajuscule $MOIS_PROCHAIN) # => Octobre
	# MOIS_PROCHAIN="Avril"
	#echo $MOIS_PROCHAIN
	
	# On récupère la date d'aujourd'hui (format : Jour N°)
	AUJOURDHUI=$(aujourd_hui)
	# AUJOURDHUI="Vendredi 30"
	#echo $AUJOURDHUI
	
	# On récupère la date de demain (format : Jour N°)
	DEMAIN=$(demain)
	# DEMAIN="Lundi 2"
	#echo $DEMAIN	
	
	# On récupère le menu de la cantine
	MENU=$(menu_cantine)

	if [ -z "$MENU" ]; then
		echo "Impossible de récupérer le menu à partir de la page web. Vérifiez votre connexion à internet."
	else
		MENU_DU_MOIS=$(menu_du_mois ${MOIS_EN_COURS} ${MOIS_PROCHAIN} "${MENU}")

		if [ -z "$MENU_DU_MOIS" ]; then
			echo "Impossible de récupérer le menu du mois.\nFin du script."
		else
			MENU_DU_JOUR=$(menu_du_jour "${AUJOURDHUI}" "${DEMAIN}" "${MENU_DU_MOIS}")

			if [ -z "$MENU_DU_JOUR" ]; then
				echo "Il n'y a pas de cantine ce jour : "$(date "+%A %-d %B %Y")
			else
				echo "Menu du "$(date "+%A %-d %B %Y")" :"
				menu_apres_filtre "$MENU_DU_JOUR"
				# echo "$MENU_DU_JOUR"
			fi
		fi
	fi
}

# Mets la première lettre du mot en majuscule
# $1 : le mot dont la première lettre doit être mise en majuscule
# exemple : septembre => Septembre
premiereLettreEnMajuscule()
{
	echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}" # => Septembre
}

# Renvoi le mois en cours
mois_en_cours()
{
	date +%B
}

# Renvoi le mois prochain
mois_prochain()
{
	date -v+1m +%B
}


# Renvoi la date du jour sour la forme : jour N°
aujourd_hui()
{
	date "+%A %-d"
}

# On récupère la date du prochain jour de cantine
# Aujourd'hui si on est lundi, mardi, mercredi ou jeudi
# lundi si on est vendredi/samedi/dimanche
# $1 : formatage (%B pour le mois, %A %-d pour jour n°)
# retour : date au format spécifié
demain()
{
	# formatage date => voir man sfrtime
	# %A  : le jour de la semaine
	# %d  : le numéro du jour dans le mois
	# %-* : ne préfixe pas les numéros par des 0
	# -v(+/-)*  : ajoute ou retranche des unités (d pour jour, m pour mois, y pour année)
	dec=$(decalage)
	# echo $@
	date -v+${dec}d "+%A %-d"
}

# On calcule le nombre de jours entre aujourd'hui et le prochain
# jour de cantine
# Renvoi : le nombre de jours de décalage par rapport à la date du jour
# Exemples :
# Vendredi => Lundi : 3 jours (Si on est vendredi, le prochain jour de cantine est lundi)
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
	# elif [ $i == "Dimanche" -o $i == "Mercredi" ]; then
	# 	# demain = lundi/jeudi = jour + 1
	# 	RET=1
	# else
	# 	# aujourd'hui
	# 	RET=0
	# fi
    else
    	RET=1
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
	sed -e :a -e '$d;N;2,10ba' -e 'P;D'
}


# Renvoi la liste des menus du mois en cours
# de la cantine de Rémy
# $1 : Nom du mois en cours (ex: Septembre)
# $2 : Nom du mois prochain (ex: Octobre)
# $3 : Liste complète des menus
menu_du_mois()
{
	# echo ${1}
	# echo ${2}
	# echo "${3}"
	echo "${3}" | sed -n "/<h3 > ${1}<\/h3>/,/<h3 > ${2}<\/h3>/p"
}

# Renvoi le menu du jour de la cantine de Rémy
# à partir de la page web du site des angles
# $1 : Jour d'aujourd'hui (ex: Lundi 2)
# $2 : Jour suivant       (ex: Mardi 3)
# $3 : Liste des menus du mois en cours
menu_du_jour()
{
	# echo "${1}"
	# echo "${2}"
	# echo "${3}"
	
	BORNE_INF=$(echo $AUJOURDHUI | sed -nE "s/[A-Z][a-z]+ ([0-9][0-9]?)/\1/p")
	BORNE_SUP=$(echo $DEMAIN | sed -nE "s/[A-Z][a-z]+ ([0-9][0-9]?)/\1/p")

	if [ $BORNE_SUP -gt $BORNE_INF ]; then
		# echo "OK"
		echo "${3}" | tr -cd '[:print:]\n' | sed -nE "s/.+${1}(.+)${2}.+/\1/p"
	else
		# La borne supérieure est inférieure à la borne inférieure => C'est le dernier jour du mois !
		# echo "${3}" | sed -nE "s/.+${1}(.+)<\/p>.+/\1/p"
		echo "${3}" | sed -nE "s/.+${1}(.+)/\1/p"
	fi
}


# Renvoi le menu du jour de la cantine de Rémy
# à partir de la page web du site des angles
# $1 : Menu du jour en html
menu_apres_filtre()
{
	# On remplace <br /> par des sauts de ligne
	# On efface les lignes vides
	echo "${1}" | sed $'s/<br \/>/\\\n/g' | sed '/^$/d'
}



# +---------------------------------------------------------------------------+
# |                        DÉBUT DU PROGRAMME                                 |
# +---------------------------------------------------------------------------+

main $@

