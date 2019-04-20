#! /bin/bash -x

# +---------------------------------------------------------------------------+
# | Transforme tous les .svg du dossier en .png.                              |
# | Usage:  ./svg2png.sh [-h] parametre1 parametre2                            |
# +---------------------------------------------------------------------------+

# +---------------------------------------------------------------------------+
# |  Fichier     : svg2png.sh                                                  |
# |  Version     : 1.0.0                                                      |
# |  Auteur      : Bruno Boissonnet                                           |
# |  Date        : 20/04/2019                                                 |
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
        elif [ $# -lt 2 ]; then
            svgVersPng "$1"
        else
            usage
            exit 0
        fi
    else
        TousSvgVersPng
    fi
}


# Transforme un fichier svg en png
# [Dans le dossier "Inkscape_PNG"]
# $1 : nom du fichier svg
# retour : NA
# exemple : svgVersPng fichier
TousSvgVersPng()
{
    for i in *.[sS][vV][gG];do
        svgVersPng "$i"
    done
}

# Transforme un fichier svg en png
# [Dans le dossier "Inkscape_PNG"]
# $1 : nom du fichier svg
# retour : NA
# exemple : svgVersPng fichier
svgVersPng()
{
    RET=""
    INKSCAPE_PGM="/Applications/Inkscape.app/Contents/Resources/bin/inkscape"
    PNG=$(nomSansExtension "${1}")
    CWD=$(pwd)
    DEST_DIR="Inkscape_PNG"
    mkdir "${DEST_DIR}"
    # instructions
    if [ -x "${INKSCAPE_PGM}" ]; then
        ${INKSCAPE_PGM} -z "${CWD}/${1}" -e "${CWD}/${DEST_DIR}/${PNG}.png"
    else
        echo "Error : Inkscape not found ! Please install Inkscape before runing this script."
    fi
    
    # echo $RET
}


# Renvoi le nom sans l'extension
# $1 : fichier dont on veut le nom
# Retour : le nom sans le chemin ni l'extension
# Exemple : /tmp/my.dir/filename.tar.gz => filename.tar
nomSansExtension()
{
    fichier=$(basename "${1}")
    echo "${fichier%.*}"
}

# +---------------------------------------------------------------------------+
# |                        DÉBUT DU PROGRAMME                                 |
# +---------------------------------------------------------------------------+

main $@

