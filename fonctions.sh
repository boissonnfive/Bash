# fonctions utiles en bash


# ---------------------- LOG -------------------------------------

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

# Renvoi le dossier en cours
workingDirectory()
{
	dirname $0
}

# Renvoi l'extension du fichier
extension()
{
	echo ${i##*.}
}

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

# Dump la BD mySQL
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


# ------------------------------- ERREURS ------------------------------

# Affiche les messages en fonction du résultat de la commande
# $1 : résultat de la commande
# $2 : message en cas de succès
# $3 : message en cas d'échec
# si échec, fin du script
gestionDesErreurs()
{
	if [ $? != "0" ]; then
	    echo "Creation du paquet de livraison                                         [NOK]"
	    echo "Fin du script."
	    exit
	fi
	echo "Creation du paquet de livraison                                      [OK]"
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
telechargeFTP()
{
	ftp <<**
	open ${FTPAddress}
	cd ${FTPDir}
	bin
	prompt
	mget *.${fileFormat}
	mdelete *.${fileFormat}
	bye
	**
}


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