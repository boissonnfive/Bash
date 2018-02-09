# Programmation en bash


## Le shebang : #!

Tout script bash est un fichier :

- qui commence par la ligne : `#! /bin/bash`
- est exécutable ( chmod u+x fichier)
[- possède l'extension .sh]
- où chaque ligne est une commande

**NOTE :** pour concaténer deux commandes on utilise le symbôle `;`
ex: commande1 ; commande2

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

**Opérateurs logiques**

- Ou (-o) : [ "$expr1" -o "$expr2" ]
- Et (-a) : [ "$expr1" -a "$expr2" ]
- Ou (||) : [ "$expr1" ] || [ "$expr2" ]
- Et (&&) : [ "$expr1" ] && [ "$expr2" ]

**L'instruction case**

```Shell
case expression in
Valeur1 ou Patron1)
  # liste de commandes
  ;;
Valeur2 ou Patron2)
  # liste de commandes
  ;;
Valeur3 ou Patron3)
  # liste de commandes
  ;;
*)
  # liste de commandes
  ;;
esac
```

*Note :* patron = expression régulière

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

## Pour approfondir ##

- [Pourquoi mettre des guillemets autour des variables](https://stackoverflow.com/questions/10067266/when-to-wrap-quotes-around-a-shell-variable)
- [Man sfrtime](https://developer.apple.com/legacy/library/documentation/Darwin/Reference/ManPages/man3/strftime.3.html#//apple_ref/doc/man/3/strftime)
- [Guide Bash du débutant](https://traduc.org/Guides_pratiques/Suivi/Bash-Beginners-Guide/Document#chap_05)
- [Advanced Bash-Scripting Guide](http://tldp.org/LDP/abs/html/index.html)
- [Bourne-Again Shell](https://fr.wikipedia.org/wiki/Bourne-Again_shell)
- [Apprendre X en Y minutes](https://learnxinyminutes.com/docs/fr-fr/bash-fr/)
