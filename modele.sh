#! /bin/bash

# +---------------------------------------------------------------------------+
# | Récupère le menu du jour de la cantine de l'école des Dinarelles.         |
# | Usage:  ./copyright-photo.sh [-h] parametre1 parametre2                   |
# +---------------------------------------------------------------------------+

# +---------------------------------------------------------------------------+
# |  Fichier     : Cantine.glet                                               |
# |  Version     : 1.0.0                                                      |
# |  Auteur      : Bruno Boissonnet                                           |
# |  Date        : 19/09/2017                                                 |
# +---------------------------------------------------------------------------+


# Algorithme :
#
# 1. On récupère le mois en cours
# 2. On récupère le mois suivant
# 3. On récupère la date d'aujourd'hui
# 4. On récupère la date de demain
# 5. Utiliser la commande `curl --silent` pour récupérer le code source de la page
# 6. On efface les dix dernières lignes du fichier pour ne pas lire des caractères qui ne sont pas en UTF-8
# 7. On récupère les menus du mois en cours
# 8. On ne garde que la deuxième ligne
# 9. On efface toute la ligne avant <strong>${AUJOURDHUI}<\/strong> et tout après <strong>${DEMAIN}<\/strong>
# 10. On remplace <br /> par des sauts de ligne
# 11. On efface les lignes qui contiennent "<strong>" et les lignes vides


# +---------------------------------------------------------------------------+
# |                             FONCTIONS                                     |
# +---------------------------------------------------------------------------+

# fonction principale du programme
main()
{
	processParams $@
	# instructions
	# RESULTAT=$(fonction $1 $2)
}

# Affiche un message d'aide
# Pas de paramètres
usage()
{    
    echo "Usage: $0 [-options] parametre1 parametre2"
    echo "Tamponne une photo avec un texte. "
    echo ""
    echo "    -h:         affiche cette aide"
    echo "    parametre1: le texte à ajouter à l'image"
    echo "    parametre2: la photo à tamponner"
    echo ""
}

# Procédure de traitement des paramètres du programme
# $1 : les paramètres du programme
# retour : NA
# exemple : processParams $@
processParams()
{
	if [ $# -gt 0 ]; then
    	if [ $1 == "-h" ]; then
			usage
			exit 0
    	elif [ $# -eq 2 ]; then
			TEXT=$1
			PHOTO=$2
			echo $TEXT
			echo $PHOTO
    	else
			usage
			exit 0
		fi
    else
			usage
			exit 0
    fi
}

# Description de la fonction
# $1 : paramètre 1
# $2 : paramètre 2
# ...
# retour : renvoie ...
# exemple : 
fonction()
{
	RET=""
	# instructions
	echo $RET
}


# +---------------------------------------------------------------------------+
# |                        DÉBUT DU PROGRAMME                                 |
# +---------------------------------------------------------------------------+

main $@

