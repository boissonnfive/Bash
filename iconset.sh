#!/bin/bash

# +---------------------------------------------------------------------------+
# | Crée un fichier icône .icns à partir d'un fichier image .PNG              |
# | Usage:  ./iconset.sh [-h] fichierPNG                                      |
# +---------------------------------------------------------------------------+


# +---------------------------------------------------------------------------+
# |  Fichier     : iconset.sh                                                 |
# |  Version     : 1.0.0                                                      |
# |  Auteur      : Bruno Boissonnet                                           |
# |  Date        : 29/05/2018                                                 |
# +---------------------------------------------------------------------------+




# +---------------------------------------------------------------------------+
# |                             FONCTIONS                                     |
# +---------------------------------------------------------------------------+

# fonction principale du programme
main()
{
	processParams "$@"
	# instructions
	# RESULTAT=$(fonction $1 $2)
	
	creerIconset "${FICHIER_PNG}"
	#cd ~/Desktop
}

# Affiche un message d'aide
# Pas de paramètres
usage()
{    
    echo "Usage: $0 [-options] fichierPNG"
    echo "Crée un fichier icône .icns à partir d'un fichier image .PNG. "
    echo ""
    echo "    -h:         affiche cette aide"
    echo "    parametre1: le fichier PNG"
    echo ""
}

# Procédure de traitement des paramètres du programme
# $1 : les paramètres du programme
# retour : NA
# exemple : processParams $@
processParams()
{
	if [ $# -gt 0 ]; then
    	if [ "$1" == "-h" ]; then
			usage
			exit 0
    	elif [ $# -eq 1 ]; then
			FICHIER_PNG=$1
			# echo ${FICHIER_PNG}
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
# $1 : fichier PNG pour créer l'icône
# $2 : Dossier .iconset
# ...
# retour : renvoie ...
# exemple : 
creerIconset()
{
	RET=""
	
	local DOSSIER_DESTINATION=$(dirname "${1}")
	local NOM_FICHIER=$(nomSansExtension "${1}")
	local DOSSIER_TEMP=/tmp/${NOM_FICHIER}.iconset
	
	mkdir ${DOSSIER_TEMP}

	sips -z 1024 1024 "${1}" --out ${DOSSIER_TEMP}/icon_512x512@2x.png 2>&1 >/dev/null
	sips -z 512 512 "${1}" --out ${DOSSIER_TEMP}/icon_512x512.png 2>&1 >/dev/null
	cp ${DOSSIER_TEMP}/icon_512x512.png ${DOSSIER_TEMP}/icon_256x256@2x.png
	sips -z 256 256 "${1}" --out ${DOSSIER_TEMP}/icon_256x256.png 2>&1 >/dev/null
	cp ${DOSSIER_TEMP}/icon_256x256.png ${DOSSIER_TEMP}/icon_128x128@2x.png
	sips -z 128 128 "${1}" --out ${DOSSIER_TEMP}/icon_128x128.png 2>&1 >/dev/null
	sips -z 64 64 "${1}" --out ${DOSSIER_TEMP}/icon_32x32@2x.png 2>&1 >/dev/null
	sips -z 32 32 "${1}" --out ${DOSSIER_TEMP}/icon_32x32.png 2>&1 >/dev/null
	cp ${DOSSIER_TEMP}/icon_32x32.png ${DOSSIER_TEMP}/icon_16x16@2x.png
	sips -z 16 16 "${1}" --out ${DOSSIER_TEMP}/icon_16x16.png 2>&1 >/dev/null

	# mv test test.iconset
	
	iconutil -c icns -o "${DOSSIER_DESTINATION}/${NOM_FICHIER}.icns" ${DOSSIER_TEMP}
	rm -Rf ${DOSSIER_TEMP}
	# echo $RET
}



# Renvoi le nom sans l'extension
# $1 : fichier dont on veut le nom
# Retour : le nom sans le chemin ni l'extension
# Exemple : /tmp/my.dir/filename.tar.gz => filename
nomSansExtension()
{
	fichier=$(basename "${1}")
	echo "${fichier%%.*}"
}

# +---------------------------------------------------------------------------+
# |                        DÉBUT DU PROGRAMME                                 |
# +---------------------------------------------------------------------------+

main "$@"




