#!/usr/bin/env bash


source ./fonctions.sh

EXTENSION=txt

isExtension $1 ${EXTENSION}
gestionDesErreurs coucou "L'extension du fichier est .${EXTENSION}      " "L'extension du fichier n'est pas .${EXTENSION}"