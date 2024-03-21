################################################
#### Intro to R & Basic Data Visualization ####
###############################################

#### GETTING STARTED /  COMMENCER ####
# what are these hashtags?? hashtags let you write text in an R script but
# it doesn't actually run the code. that will make sense later but 
# basically, putting a hashtag in front of text lets you take notes and 
# annotate your R scripts, which is a good practice so you don't forget 
# what you did or why...

###### if you want to create a heading you need hashtags on both sides ########

# c'est quoi ces hashtags ?? les hashtags vous permettent d'écrire du texte dans un script R mais
# il n'exécute pas réellement le code. cela aura du sens plus tard mais
# en gros, mettre un hashtag devant le texte permet de prendre des notes et
# annotez vos scripts R, ce qui est une bonne pratique pour ne pas oublier
# ce que tu as fait ou pourquoi...

###### si vous souhaitez créer un titre, vous avez besoin de hashtags des deux côtés ########

# download R and R studio at http://www.r-project.org/ and http://www.rstudio.org/

# to run commands from your script, hit command + enter or the run button (top right corner)
# you can also type commands directly into the console, for example, if you don't want to
# save it in a script.

# pour exécuter les commandes de votre script, appuyez sur commande + entrée ou sur le bouton Exécuter (coin supérieur droit)
# vous pouvez également taper des commandes directement dans la console, par exemple, si vous ne souhaitez pas
# enregistrez-le dans un script.

# find out which version of R you have:
# découvrez quelle version de R vous possédez:
version

# you can get help documentation for any function by typing a ? in front of it:
# vous pouvez obtenir de la documentation d'aide pour n'importe quelle fonction en tapant un ? devant:
?version

# viewing citations:
# affichage des citations:
citation()

# get familiar with how R works. it can be a calculator e.g.
# Familiarisez-vous avec le fonctionnement de R. ça peut être une calculatrice par ex:
1 + 1

# assigning and using variables:
# assigner et utiliser des variables:
x <- 7
x

x + 2
x/2

y <- c(2,3,5)

2*y

x*y

y[1]
(x + y[1])/2
(x + 2)/2

# phrases or characters need to be in quotation marks
# it wouldn't be a coding class without some "hello world!":
print("hello world!")

#expressions ou caractères doivent être entre guillemets
# ce ne serait pas un cours de codage sans un "hello world!":
print("bonjour tout le monde!")

# what happens without quotation marks?
# que se passe-t-il sans les guillemets?
print(mammals)

# you can write your own vectors using the "concatenate" function e.g.
# vous pouvez écrire vos propres vecteurs en utilisant la fonction "concaténer", par ex.:
a <- c(1,2,3,4)
b <- c(5,6,7,8)

# this tells R that you are giving it a list of values
# cela indique à R que vous lui donnez une liste de valeurs
sum(a)
mean(b)
str(a)
print(a)

a <- a*2
a
# what is "a" now?
# qu'est-ce que "a" maintenant?

# creating a data matrix: cbind: binds lists by columns, rbind: binds lists by rows
# création d'une matrice de données: cbind: lie les listes par colonnes, rbind: lie les listes par lignes
m <- cbind(a,b)
m2 <- rbind(a,b)

# use "View" to look at your data:
# utilisez "View" pour consulter vos données:
View(m)
View(m2)

# you can also look at your new matrix in the console:
# vous pouvez également regarder votre nouvelle matrice dans la console:
m
m2

# in R, columns and rows can also be selected following the syntax of [rows, columns]
# so to select the second row of m:
# dans R, les colonnes et les lignes peuvent également être sélectionnées en suivant la syntaxe de [lignes, colonnes]
# donc pour sélectionner la deuxième ligne de m:
m[2,]

# and the second column of m2:
# et la deuxième colonne de m2:
m2[,2]

# you can also do simple stats very easily. here's an example from our mosquito paper.
# these are values representing little brown (mylu) and big brown (epfu) bat diet samples 
# (23 and 7) with at least one mosquito species detected in a guano sample vs 
# guano samples with no mosquitos detected (9 and 14):

# Vous pouvez également faire des statistiques simples très facilement. voici un exemple de notre papier anti-moustique.
# ce sont des valeurs représentant des échantillons de régime alimentaire de petites chauves-souris brunes (mylu) et grosses (epfu)
# (23 et 7) avec au moins une espèce de moustique détectée dans un échantillon de guano vs
# échantillons de guano sans moustiques détectés (9 et 14):

a <- c(23,7)
b <- c(9,14)
c <- cbind(a,b)
c

# use a chi-squared test:
# utiliser un test du chi carré:
?chisq.test
chisq.test(c)

# t.tests for a small data set (without uploading anything!)
# create an example (just for testing):
# rnorm gives you random numbers from a normal distribution 
# runif gives you random numbers from a uniform distribution

# t.tests pour un petit ensemble de données (sans rien télécharger!)
# créez un exemple (juste pour tester):
# rnorm vous donne des nombres aléatoires issus d'une distribution normale
# runif vous donne des nombres aléatoires issus d'une distribution uniforme

a <- rnorm(30, mean = 5, sd = 0.2)
b <- runif(30, min = 0, max = 20)

# view a histogram of these values:
# afficher un histogramme de ces valeurs:
hist(a)
hist(b)

t.test(a,b)
wilcox.test(a,b)

# what happens if your samples are paired?
# compare the output from different tests:
# que se passe-t-il si vos échantillons sont appariés?
# comparer les résultats de différents tests:
t.test(a,b, paired = TRUE)
wilcox.test(a,b, paired = TRUE)

# digging deeper: which test changes more with a paired study design? 
# why might that be? explore more on your own to understand the differences
# between parametric and nonparametric tests. 

# creuser plus profondément: quel test change le plus avec une conception d'étude jumelée?
# pourquoi cela pourrait-il être le cas? explorez davantage par vous-même pour comprendre les différences
# entre les tests paramétriques et non paramétriques.

#### setting your working directory: 3 ways / définir votre répertoire de travail: 3 façons ####
# from the GUI: session -> set working directory

# replace the paths below with your own file paths to your desktop folders
# remplacez les chemins ci-dessus ^ par vos propres chemins vers vos dossiers de bureau

# e.g., setwd("C://Users/"your name"/Desktop/WAMF RStats Workshop/data)
# using code (mac):
setwd("/insert your path here/WAMF RStats Workshop/data")

# using code (on a pc):
setwd("C://insert your path here/WAMF RStats Workshop/data")

# interactive (pc only):
choose.dir()

# more info:
?setwd

# see what your working directory is:
# voyez quel est votre répertoire de travail:
getwd()

#### uploading a csv: 3 ways / Télécharger un CSV: 3 façons ####
# upload directly using a path (replace with your file path)
# téléchargez directement en utilisant un chemin (remplacez par le chemin de votre fichier)

# this data is from GBIF (gbif.org):
df <- read.csv(file="/your path/data/gbif_data.csv")

# upload from your working directory:
# upload depuis votre répertoire de travail:
df <- read.csv(file="gbif_data.csv")

# or upload using this function:
# ou téléchargez en utilisant cette fonction:
df <- read.csv(file.choose())

# what if your data doesn't have a header? see:
# et si vos données n'ont pas d'en-tête? voir:
?read.csv

# you can upload nearly any file type in R, including .txt and .xls
# but you need another package for that. there are several! see if you 
# can find them online.

# vous pouvez télécharger presque n'importe quel type de fichier dans R, y compris .txt et .xls
# mais vous avez besoin d'un autre package pour cela (il y en a plusieurs ! voyez si vous
# peut les trouver lorsque vous avez accès à Internet.

# useful ways to look at your data:
# façons utiles d'examiner vos données:
names(df)
summary(df)
head(df) # return the first part of a data frame / renvoyer la première partie d'un bloc de données
tail(df) # return the last part of a data frame / renvoyer la dernière partie d'un bloc de données
dim(df) # dimensions of the data frame / dimensions du bloc de données
str(df) # structure of the data frame / structure de la trame de données
nrow(df) # number of rows / Nombre de rangées
length(df) # number of columns / le nombre de colonnes

my_df <- df
names(my_df)

# look at a subset of the data (rows 1-100):
# regardez un sous-ensemble de données (lignes 1 à 100):
View(df[1:100,])

# look at a subset of certain rows 
# regarde un sous-ensemble de certaines lignes
names(df)
View(df[1:100, c(2,17,22)]) # see institution code, species, & level1Name

# view the different options for the orders 
# visualiser les différentes options pour les commandes
levels(as.factor(df$order)) 

# change a variable from a character to a factor
# changer une variable d'un caractère à un facteur
df$order <- as.factor(df$order) 

levels(df$order)
str(df)

##### summaries ####
summary(df$order)
summary(as.factor(df$family))

hist(df$year)
hist(df$decimalLatitude)
hist(df$decimalLongitude)

summary(df$decimalLatitude)
summary(df$decimalLongitude)

plot(df$decimalLongitude, df$decimalLatitude)

# changing column names by column order:
# modification des noms de colonnes par ordre des colonnes:
colnames(df)[9] <- "lat"
colnames(df)[10] <- "lon"

# create a new variable: 
# créer une nouvelle variable:
df$country <- df$level0Name
names(df)
head(df)

# changing column names based on column name
# changer les noms de colonnes en fonction du nom de la colonne
names(df)[names(df) == "lon"] <- "long"
names(df)
head(df)

# removing columns:
# suppression de colonnes:
df_subset <- df[-c(18, 19)]

# subsetting data
# données de sous-ensemble
df_bats <- subset(df, df$order == "Chiroptera")
head(df_bats)

# levels of a variable within the data subset:
# niveaux d'une variable dans le sous-ensemble de données:
levels(as.factor(df_bats$family))

# challenge: can you find out if your favorite mammalian family is included in this dataset?
# challenge : saurez-vous savoir si votre famille de mammifères préférée est incluse dans cet ensemble de données?

# rename a value:
# renommer une valeur:
df_bats$family[df_bats$family == "Vespertilionidae"] <- "vesper bats"
levels(as.factor(df_bats$family))

##### packages / paquets ####
# we need a few packages (which act like plugins or apps with additional functionality)
# for the next few steps. After installing a package, you need to call it using the "library" function.

# nous avons besoin de quelques packages (qui agissent comme des plugins ou des applications avec des fonctionnalités supplémentaires)
# pour les prochaines étapes. Après avoir installé un package, vous devez l'appeler à l'aide de la fonction "bibliothèque".

install.packages("mapdata")
install.packages("maps")
install.packages("praise")
install.packages("ggpplot2")
install.packages("unikn")
install.packages("ggridges")
install.packages("DataEditR")
library(mapdata)
library(maps)
library(praise)
library(ggplot2)
library(unikn)
library(ggridges)
library(DataEditR)

# try out my favorite package (it only has 1 function):
# essayez mon package préféré (il n'a qu'une seule fonction):
praise()
?praise
praise("${Exclamation}! This WAMF R workshop is ${adjective}!")

# visit the "praise" github page:
# https://github.com/rladies/praise
# what do you see? explore the folders to see how a package is made!

# visitez la page github "louange":
# https://github.com/rladies/praise
# que vois-tu? explorez les dossiers pour voir comment un package est créé!

# there are many resources available WITH each R package, so you can
# access a lot of tutorials without ever connecting to the internet!

# il existe de nombreuses ressources disponibles AVEC chaque package R, vous pouvez donc
# accédez à de nombreux tutoriels sans jamais vous connecter à Internet!

# View available vignettes:
# Afficher les vignettes disponibles:
vignette(all = FALSE)

# View specific vignettes:
# Afficher des vignettes spécifiques:
vignette("dplyr")
vignette("ggplot2-specs")

# citations for a package:
# citations pour un package:
citation("ggplot2")

# ouvrir une nouvelle fenêtre
windows()

# remind yourself of the names of your df:
# rappelez-vous les noms de vos df:
names(df)

# edit your dataframe IN R using package "DataEditR":
# note: needs wifi connection...but why?

# éditez votre dataframe IN R en utilisant le package "DataEditR":
# remarque : nécessite une connexion wifi... mais pourquoi?
df_edit <- DataEditR::data_edit(x = df)

View(df_edit)

# did that work?
# now, you can save your edited file using the GUI, or like this:

# est-ce que ça a marché?
# maintenant, vous pouvez enregistrer votre fichier modifié en utilisant l'interface graphique, ou comme ceci:

write.csv(df_edit, file = "gbif_subset.csv")

# to write a .csv file without numbers in the first column:
# pour écrire un fichier .csv sans chiffres dans la première colonne:

# write.csv(df_edit, file = "gbif_subset.csv", row.names = FALSE)

# people will often use a # in front of any code that writes a file, so you can turn
# it on or off without worrying about rewriting that file.

# les gens utiliseront souvent un # devant tout code qui écrit un fichier, vous pouvez donc tourner
# Activez-le ou désactivez-le sans vous soucier de réécrire ce fichier.

##### making a basic map / créer une carte de base ####
# R can be used for many mapping functions! this one is nice especially for figures
# where you may want an inset of your study region in a broader context.

# R peut être utilisé pour de nombreuses fonctions de cartographie! celui-ci est sympa surtout pour les chiffres
# où vous souhaiterez peut-être un encart de votre région d'étude dans un contexte plus large.
quartz()
map("worldHires", xlim = c(-20,55), ylim=c(-40,40))
map("worldHires", "Nigeria", add = TRUE, col = "green4", fill = TRUE)
map("worldHires", "Cameroon", add = TRUE, col = "yellow", fill = TRUE)

# zoom in more:
map("worldHires", "Nigeria", xlim = c(0,20), ylim=c(-5,15), col = "gray90", fill = TRUE)

# "pch" controls the shape of points on a plot. its documentation lists more info:
# "pch" contrôle la forme des points sur un tracé. sa documentation répertorie plus d'informations:
?pch
?points

points(df$lat, df$long, cex = 0.5, pch = 16, col = "red", add = TRUE) 
# cex = point size, pch = point shape, col = point color

# challenge: make your own map by changing the colors or scales of the map:
# défi : réalisez votre propre carte en changeant les couleurs ou les échelles de la carte:
colors()

# making maps with your own color palette:
# make a color palette using hexadecimal color codes:

# créer des cartes avec votre propre palette de couleurs:
# créer une palette de couleurs en utilisant des codes de couleurs hexadécimaux:
my_colors <- c("#CFB06F", "#437B88", "#EA93A0", "#9F3537", "#97BC50", "#FE5D2B", "#ADA9A4")

# or with color names:
# ou avec les noms de couleurs:
my_colors2 <- c("cornflowerblue", "gray80", "firebrick1", "hotpink2")

# View palettes:
# Afficher les palettes:
unikn::seecol(my_colors)
unikn::seecol(my_colors2)

## more figures with your custom palettes:
# create some fake data: 
## plus de figures avec vos palettes personnalisées:
# créer de fausses données:

dd <- data.frame(ID=c(rep("a",10),rep("b",10),rep("c",10),rep("d",10),
                    rep("e",10),rep("f",10),rep("g",10)),
               v1=rnorm(70,0,100),
               v2=runif(70, 0, 1))

dd

# figures: we will revisit how to use ggplot exactly, but for now, 
# we can show some of its capabilities:

# chiffres: nous reviendrons sur la manière d'utiliser ggplot exactement, mais pour l'instant,
# nous pouvons montrer certaines de ses capacités:

ggplot(dd, aes(x=ID, y=v1, fill=factor(ID)))+ # input your data and aesthetics / saisissez vos données et votre esthétique
  geom_boxplot(outlier.shape=NA)+ # remove the outlier from geom_boxplot / supprimer la valeur aberrante de geom_boxplot
  geom_point(pch=1)+ # add points over the boxplots (includes the outlier) / ajouter des points sur les boxplots (inclut la valeur aberrante)
  scale_fill_manual(values=my_colors)+ # manually change the colors / changer manuellement les couleurs
  theme_minimal() # set the overall plot theme / définir le thème général de l'intrigue

ggplot(dd, aes(x=v2, y=ID, fill=ID))+
  geom_density_ridges(alpha=0.8)+ # alpha changes the transparency / alpha change la transparence
  scale_fill_manual(values=my_colors)+
  scale_y_discrete(limits=rev(df$ID))+ # change the scale / changer d'échelle
  theme_classic() # see a different theme / voir un thème différent

# more info on colors:
# http://www.stat.columbia.edu/~tzheng/files/Rcolor.pdf
# http://tools.medialab.sciences-po.fr/iwanthue/
# http://colorbrewer2.org

# beautiful!!!! 
praise()
