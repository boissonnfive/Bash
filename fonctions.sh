#!/usr/bin/env bash
# fonctions utiles en bash


# ---------------------- DATE -----------------------------------

# Renvoie la date de demain
demain()
{
	date -v+1d "+%d/%m/%Y"
}

# Renvoie la date d'hier
hier()
{
	date -v+1d "+%d/%m/%Y"
}

# Renvoie la date d'aujourd'hui
aujourdhui()
{
	date "+%d/%m/%Y"
}


# ---------------------- LOG -------------------------------------
# Renvoie un pointage utile pour les fichiers de log
# au format jj/mm/aaaa Hhmn:s (ex: 29/09/2017 20h45:31)
dateLOG()
{
	date "+%d/%m/%Y %Hh%M:%S"
}

# print a header in the file
# $1: file to print the header into
# $2: source folder
# $3: target folder
printHeader()
{
	heure=$(date +%Hh%M)
	date=$(date +%d/%m/%Y)
	
	nom_backup=$(basename "$2")
	nom_cible=$(basename "$3")
	
	echo "" >> $1
	echo "-----------------------------------------------------------------" >> $1
	echo 'Backup du' $date 'a' $heure 'de "'$nom_backup'" vers "'$nom_cible'"'  >> $1
	echo "-----------------------------------------------------------------" >> $1
}


# print a footer in the file
# $1: file to print the header into
printFooter()
{
	echo "" >> $1
	echo "*****************************************************************" >> $1
}


# ------------------- BACKUP ------------------------------

# sync source and target folders with rsync
# $1: backup log file
# $2: source folder
# $3: target folder
syncFolder()
{
	# Creation du répertoire de sauvegarde
	mkdir -p "$3"	
	#rsync -vrup --delete "${source}" "${cible}" >> $rapport
	rsync -avu --exclude '*~' "$2" "$3" >> $1
}



# ------------------------ AUTOMATOR -----------------------------

# Lance un processus automator
# $1: chemin complet du fichier processus
runInAutomator()
{
	# automator ne marche pas quand il est lancé par launchd !?
	automator $1
}

# ----------------------------- DOSSIERS/FICHIERS ---------------------

# Renvoi le chemin du fichier
# $1 : fichier dont on veut le chemin
# Retour : chemin du fichier
# Exemple : /tmp/my.dir/filename.tar.gz => /tmp/my.dir
chemin()
{
	dirname "${1}"
}


# Renvoi le nom du fichier sans le chemin
# $1 : fichier dont on veut le nom
# Retour : nom du fichier
# Exemple : /tmp/my.dir/filename.tar.gz => filename.tar.gz
nom()
{
	basename "${1}"
}

# Renvoi l'extension du fichier
# $1 : fichier dont on veut l'extension
# Retour : l'extension du fichier
# Exemple : /tmp/my.dir/filename.tar.gz => tar.gz
extension()
{
	echo "${1#*.}"
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


# Test l'extension du fichier
# $1 : fichier que l'on veut tester
# $2 : extension supposée
# Retour : 0 si l'extension proposée est l'extension du fichier, 1 sinon
isExtension()
{
	if [[ ${1} == *.${2} ]]; then
        RET=0
    else
    	RET=1
    fi
    return $RET
}


## TODO : remplacer ls $1 par cd $1 et un for sur *.jpg
# Permutation circulaire des noms des photos jpg du dossier
# $1 : dossier contenant les fichiers
permutationCirculaireFichiers()
{
	#echo $files
	temp="temp.jpg"
	
	for i in $(ls $1); do
		EXT=`echo ${i##*.}`
		#if [[ "$EXT" == "jpg" || "$EXT" == "JPG" ]]; then
	    	mv "$1"${i} "$1"${temp}
	    	temp=${i}
		#fi
	done
	mv "$1"temp.jpg "$1"${temp}
}

# Renomme tous les fichiers du répertoire courant
# $1 : chaîne à remplacer
# $2 : nouvelle chaine
renommeTousLesFichiersDuRepertoire()
{
	# for e in *; do mv "$e" "`echo $e | sed -e 's/\ /_/g'`"; done
	for e in *; do mv "$e" "`echo $e | sed -e 's/$1/$2/g'`"; done
}


# -------------------------------- mySQL ----------------------------

# fait une sauvegarde de la BDD mySQL
# $1 : utilisateur
# $2 : mot de passe
# $3 : hôte
# $4 : base de données mySQL
dumpDB()
{
	# dump database in file
	mysqldump -u$1 -p$2 -h$3 $4 >> $4.dump

}


# ------------------------------------ CAC40 ------------------------------

CAC40()
{
	curl -s "http://www.boursorama.com/cours.phtml?symbole=1rPCAC" | sed -nE '579 s/^.+([0-9] [0-9]{3}\.[0-9]{2}).+$/\1/p'
}

# --------------------------------- CVS ----------------------------

# get a specified release of a project
# $1: cvs repository
# $2: release
# $3: project repository
getCVSProject()
{
	cvs -d $1 export -r $2 $3 > /dev/null 2>&1
}

# check out a specified release of a project
# $1: cvs repository
# $2: release
# $3: project repository
coCVSProject()
{
	cvs -d $1 co $3 > /dev/null 2>&1
}

# check in all changes
ciCVSProject()
{
	cvs ci -m \"\" > /dev/null 2>&1
}

# Pose un tag sur le projet
# S1 : nom du tag
tagCVSProject()
{
	cvs tag $1  > /dev/null 2>&1
}


# ------------------------------- string ----------------------------

# replace a string by another in a file
# $1: string to replace
# $2: new string
# $3: file name
replaceInFile()
{
	sed -i 's/'$1'/'$2'/g' $3 > /dev/null 2>&1
	RETURN=$?
	if [ ${RETURN} != "0" ]; then
	    echo "Replace "$1" with "$2" in "$3"            [NOK]"
	fi
	return ${RETURN}
}

# replace a string by another in a file ONLY if there is no comma in the line
# $1: string to replace
# $2: new string
# $3: file name
replaceInFile2()
{
	#sed -i '/[^'$1':]/s/'$1'/'$2'/g' $3 > /dev/null 2>&1
	sed -i '/'$1':/!s/'$1'/'$2'/g' $3 > /dev/null 2>&1
	RETURN=$?
	if [ ${RETURN} != "0" ]; then
	    echo "Replace "$1" with "$2" in "$3"            [NOK]"
	fi
	return ${RETURN}
}


# export to a file a part of another file
# $1: starting string
# $2: ending string
# $3: input file name
# $4: export file name
exportFromFile()
{
	cat $3 | sed -n '/'$1'/,/'$2'/p' > $4
	RETURN=$?
	if [ ${RETURN} != "0" ]; then
	    echo "Export part between "$1" and "$2" from "$3" in "$4"            [NOK]"
	fi
	return ${RETURN}
}


# insert the content of a file in another file
# $1: string to insert after (the string is replaced)
# $2: input file name
# $3: export file name
insertFile1InFile2()
{
	FILE_TEMP2=atemp2.txt
	sed -e '/'$1'/{r '$2'' -e 'd;}' $3 > ${FILE_TEMP2}
	RETURN=$?
	if [ ${RETURN} != "0" ]; then
	    echo "Insert "$2" in "$3" after string "$1"            [NOK]"
	else
	    mv ${FILE_TEMP2} $3
		RETURN=$?
	fi
	return ${RETURN}
}


# Mets la première lettre du mot en majuscule
# $1 : le mot dont la première lettre doit être mise en majuscule
# exemple : septembre => Septembre
premiereLettreEnMajuscule()
{
	echo "$(tr '[:lower:]' '[:upper:]' <<< ${1:0:1})${1:1}"
}


# ------------------------------- ERREURS ------------------------------

# Affiche les messages en fonction du résultat de la commande
# $1 : résultat de la commande
# $2 : message en cas de succès
# $3 : message en cas d'échec
# si échec, fin du script
# Les messages doivent avoir la même longueur (utilisez des espaces sinon)
gestionDesErreurs()
{
	if [ $? != "0" ]; then
	    echo $3"                                  [NOK]"
	    echo "Fin du script."
	    exit
	fi
	echo $2"                                  [OK]"
}


# ---------------------------- RESEAU ----------------------------

# copie sur le serveur le fichier passé en paramètre
# $1 : fichier à copier sur le serveur
copieSSH()
{
	scp -P 2222 $1 root@90.80.38.17:./Desktop/installation/$1
}

# Open a FTP transaction, get all files and delete them then.
# $1 : adresse FTP 
# $2 : dossier source FTP
# Remark: this transaction needs a configuration file (.netrc) with the
# following data:
# machine XXX.XXX.XXX.XXX
# login machin
# password machinpwd

## TODO : réparer l'erreur « syntax error: unexpected end of file »
## causée par le code suivant
# telechargeFTP()
# {
# 	ftp <<**
# 	open ${FTPAddress}
# 	cd ${FTPDir}
# 	bin
# 	prompt
# 	mget *.${fileFormat}
# 	mdelete *.${fileFormat}
# 	bye
# 	**
# }


# -------------------------- PARAMS -----------------------------

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

# Affiche les paramètres du programme
# $1 : les paramètres du programme
# retour : NA
# exemple : debugParams $@
debugParams()
{
	# Affichage du nom su script
	echo "Le nom de mon script est : $0"
	# Affichage du nombre de paramètres
	echo "Vous avez passé $# paramètres"
	# Liste des paramètres (un seul argument)
	for param in "$*"
	do
	 echo "Voici la liste des paramètres (un seul argument) : $param"
	done
	# Liste des paramètres (un paramètre par argument)
	echo "Voici la liste des paramètres (un paramètre par argument) :"
	for param in "$@"
	do
	 echo -e "\tParamètre : $param"
	done
	# Affichage du processus
	echo "Le PID du shell qui exécute le script est : $$"

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


