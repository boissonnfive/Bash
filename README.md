# Bash #

Mon travail sur Bash

## Mes fichiers ##

- pragrammation.md : mes notes sur la programmation en bash
- modele.sh        : squelette de script bash
- fonctions.sh     : Contient les fonctions utiles que j'ai crées ou glanées sur le net.
- cantine.sh       : Récupère le menu du jour de la cantine de l'école des Dinarelles.
- messes.sh        : Récupère l'heure et le lieu de la prochaine messe dominicale aux Angles.
- meteo.sh         : Récupère la météo du jour.



## fonctions.sh ##

### Dates ###

- demain     : Renvoie la date de demain
- hier       : Renvoie la date d'hier
- aujourdhui : Renvoie la date d'aujourd'hui

### LOG ###

- DateLOG :  Renvoie un pointage utile pour les fichiers de log au format jj/mm/aaaa Hhmn:s (ex: 29/09/2017 20h45:31)
- printHeader : Écris un en-tête de fichier de log
- printFooter : Écris un pied-de-page pour fichier de log

### DOSSIERS/FICHIERS ###

- chemin                             : Renvoi le chemin du fichier
- nom                                : Renvoi le nom du fichier sans le chemin
- extension                          : Renvoi l'extension du fichier
- nomSansExtension                   : Renvoi le nom sans l'extension
- isExtension                        : Test l'extension du fichier
- permutationCirculaireFichiers      : Permutation circulaire des noms des photos jpg du dossier
- renommeTousLesFichiersDuRepertoire : Renomme tous les fichiers du répertoire courant

### CVS

- getCVSProject : get a specified release of a project
- coCVSProject : check out a specified release of a project
- ciCVSProject : check in all changes
- tagCVSProject : Pose un tag sur le projet

### String

- replaceInFile : replace a string by another in a file
- replaceInFile2 : replace a string by another in a file ONLY if there is no comma in the line
- exportFromFile : export to a file a part of another file
- insertFile1InFile2 : insert the content of a file in another file
- premiereLettreEnMajuscule : Mets la première lettre du mot en majuscule

### PARAMS ###

- processParams : Procédure de traitement des paramètres du programme
- debugParams : Affiche les paramètres du programme
- usage : Affiche un message d'aide

### Divers

- dumpDB : fait une sauvegarde de la BDD mySQL
- runInAutomator : Lance un processus automator
- CAC40 : 
- syncFolder : sync source and target folders with rsync
- copieSSH : copie sur le serveur le fichier passé en paramètre
- gestionDesErreurs : Affiche les messages en fonction du résultat de la commande

