#! /bin/bash -x

# +---------------------------------------------------------------------------+
# | Récupère le menu du jour de la cantine de l'école des Dinarelles.         |
# +---------------------------------------------------------------------------+

# +---------------------------------------------------------------------------+
# |  Fichier     : cantine.sh                                                 |
# |  Version     : 2.0.0                                                      |
# |  Auteur      : Bruno Boissonnet                                           |
# |  Date        : 12/04/2018                                                 |
# +---------------------------------------------------------------------------+


# +---------------------------------------------------------------------------+
# |                             FONCTIONS                                     |
# +---------------------------------------------------------------------------+


main()
{
	# On récupère le mois en cours
	MOIS_EN_COURS=$(mois_en_cours)
	MOIS_EN_COURS=$(premiereLettreEnMajuscule $MOIS_EN_COURS)                 # => Septembre
	
	# On récupère le mois suivant
	MOIS_PROCHAIN=$(mois_prochain)
	MOIS_PROCHAIN=$(premiereLettreEnMajuscule $MOIS_PROCHAIN) # => Octobre
	
	# On récupère la date d'aujourd'hui (format : Jour N°)
	AUJOURDHUI=$(aujourd_hui)
	
	# On récupère la date de demain (format : Jour N°)
	DEMAIN=$(demain)
	
	# On récupère le menu de la cantine
	MENU=$(menu_cantine)

	if [ -z "$MENU" ]; then
		echo "Impossible de récupérer le menu."
	else
		MENU_DU_MOIS=$(menu_du_mois ${MOIS_EN_COURS} ${MOIS_PROCHAIN} "${MENU}")

		if [ -z "$MENU_DU_MOIS" ]; then
			echo "Impossible de récupérer le menu du mois."
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
	if [ $i == "Mardi" ]; then
		# demain = jeudi = jour + 2
		RET=2
	elif [ $i == "Vendredi" ]; then
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
	DOSSIER_EN_COURS=$(dirname $0)
	cat ${DOSSIER_EN_COURS}/cantine_2018.txt
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
	echo "${3}" | sed -n "/${1}/,/${2}/p"
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
	
	AUJOURDHUI=${1}

	BORNE_INF=$(echo ${1} | sed -nE "s/[A-Z][a-z]+ ([0-9][0-9]?)/\1/p")
	BORNE_SUP=$(echo ${2} | sed -nE "s/[A-Z][a-z]+ ([0-9][0-9]?)/\1/p")

	# Si la borne supérieure est inférieure à la borne inférieure => C'est le dernier jour du mois !
	if [ $BORNE_SUP -gt $BORNE_INF ]; then
		# echo "OK"
		
		RES=$(echo "${3}" | sed -n "/${1}/p" )

		if [ -z "$RES" ]; then
			echo "Impossible de trouver ${1}."
			return ""
		else

			# Si aujourd'hui est le 1er du mois
			if [ $BORNE_INF -eq 1 ]; then
				RES=$(echo "${3}" | sed -n "/${1}er/p")
				if [ -z "$RES" ]; then
					AUJOURDHUI=${1}
				else
					AUJOURDHUI=${1}er
				fi
			fi


			RES=$(echo "${3}" | sed -n "/${2}/p" )

			if [ -z "$RES" ]; then
				echo "Impossible de trouver ${2}."
				return ""
			fi
		fi

		# echo "${3}" | tr -cd '[:print:]\n' | sed -nE "s/.+${1}(.+)${2}.+/\1/p"
		# On récupère ce qu'il y a entre les deux jours
		# Puis on efface la première ligne (jour 1)
		# et la dernière ligne (jour 2)
		echo "${3}" | sed -n "/${AUJOURDHUI}/,/${2}/p" | sed 1d | sed -e '$ d'
			

	else
		# echo "${3}" | sed -nE "s/.+${1}(.+)<\/p>.+/\1/p"
		# On récupère ce qu'il y a entre le dernier jour du mois et la fin du texte
		# Puis on efface la première ligne (jour 1)
		# et la dernière ligne (mois suivant)
		echo "${3}" | sed -nE "/${1}/,$ p" | sed 1d | sed -e '$ d'
	fi
}


# Supprime les lignes vides et les espaces inutiles
# $1 : Menu du jour
menu_apres_filtre()
{
	# On efface les lignes vides
	# et les espaces inutiles
	# et les lignes qui ne contiennent qu'un seul caractère
	echo "${1}" |  sed '/^$/d' | sed 's/  //g' | sed -E '/^.{1}$/d'
}



# +---------------------------------------------------------------------------+
# |                        DÉBUT DU PROGRAMME                                 |
# +---------------------------------------------------------------------------+

main $@

