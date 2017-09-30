# Programmation en bash


## Le shebang : #!

Tout script bash est un fichier :

- qui commence par la ligne : `#! /bin/bash`
- est exécutable ( chmod u+x fichier)
[- possède l'extension .sh]

## Les commentaires ##

Tout ce qui se situe entre le caractère `#` et la fin de ligne.

```Shell
# affiche la date                               (commentaire avant du code)
date +%d/%m/%Y  # au format jj/mm/AAAA          (commenatire après du code)
# echo $PATH                                    (code en commentaires)
```

## Les variables ##

*ATTENTION! pas d'espace avant ni après le "="*

```Shell
PRENOM="Bruno"
NOM="Boissonnet"
AGE=41

echo "Prénom : $PRENOM"
echo "Nom : $NOM"
echo "Âge : $AGE"
```

**Variables numériques** (mais seulement des entiers, pas des flottants)

```Shell
z=10
z=$(($z+3))  # z = 13
z=$((z+3))
let z=z+3
let "z += 3"
echo $z
```

## Les conditions ##

```Shell
if [ condition1 ]; then
	#instructions
else
	if [ condition2 ]; then
		#instructions
	elif [ condition3 ]; then
		#instructions
	else
		#instructions
	fi
fi
```

Opérateurs sur chaînes : == ou =, !=, <, >, -z, -n
Opérateurs sur nombres : -eq, -ne, lt, gt, -le, -ge, <, >, <=, >=
**ATTENTION!** Toujours mettre les opérandes entre guillemets. ( [ "$OP1" = "$OP2" ])

## Les boucles ##

```Shell
for (( i = 0; i < 10; i++ )); do
	# instructions
done
```
```Shell
for i in $LISTE; do
	# instructions
done
```
```Shell
while [ condition ]; do
	# instructions
done
```

## Les tableaux ##

```Shell
backup_list[0]=fjdkslq
backup_list[1]=fjdkslq
#...

i=0                         
while (( $i < ${#backup_list[@]} ));do
	#echo "le backup n°$i est ${backup_list[i++]}"
done
```


## Les procédures et les fonctions ##

```Shell
afficheLesParametres()
{
	for param in "$@"
	do
	 echo -e "\tParamètre : $param"
	done
}

# appel
afficheLesParametres $@
```

```Shell
demain()
{
	date -v+1d
}

# appel #
DEMAIN=$(demain)
```

## Les paramètres du script ##

- $0 Contient le nom du script tel qu'il a été invoqué 
- $* L'ensembles des paramètres sous la forme d'un seul argument 
- $@ L'ensemble des arguments, un argument par paramètre 
- $# Le nombre de paramètres passés au script 
- $? Le code retour de la dernière commande 
- $$ Le PID su shell qui exécute le script 
- $! Le PID du dernier processus lancé en arrière-plan 


