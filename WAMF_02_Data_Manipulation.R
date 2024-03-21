##################################################
#### Data Manipulation & Additional Analyses  ####
##################################################

# Load necessary libraries
# Charger les bibliothèques nécessaires

library(tidyverse)
library(patchwork)

# warmup: use any of the methods from the last lesson to set your working directory
# warmup: utilisez l'une des méthodes de la dernière leçon pour définir votre répertoire de travail

getwd()

# Load sample data set
# Charger un exemple d'ensemble de données
df <- read.csv(file="your path here/data/gbif_data.csv")
colonies_df <- read.csv(file="your path here/colonies.csv")

# the "colonies" data set is from the publication Hurme et al. 2022 in 
# Functional Ecology. 

# l'ensemble de données "colonies" est issu de la publication Hurme et al. 2022 dans
# Functional Ecology. 

# source: https://datadryad.org/stash/dataset/doi:10.5061/dryad.z08kprrdb

# Explore dataset:
# Explorer l'ensemble de données:

names(df)
str(df)

df2 <- df %>% 
  filter(order == "Chiroptera") %>% # "filter" to include or exclude values / "filtrer" pour inclure ou exclure des valeurs
  filter(!family == "Vespertilionidae") %>% # use ! to exclude a group / utiliser ! exclure un groupe
  mutate(groupCommonName = "non-vesper bats") # create a new variable / créer une nouvelle variable

# what does your data set look like now?
# à quoi ressemble votre ensemble de données maintenant?

str(df2)

# summarize the data:
# résumer les données:

df_sum <- df2 %>%
  mutate(country = level0Name) %>% # create a new variable name / crée un nouveau nom de variable
  group_by(country) %>% # group / groupe
  summarize(n_families = n_distinct(family), # summarize number of unique families / résumer le nombre de familles uniques
            n_genera = n_distinct(genus), # summarize number of unique genera / résumer le nombre de genres uniques
            n_sp = n_distinct(species)) # summarize number of unique species

df_sum

df_sum2 <- df %>%
  filter(order == c("Rodentia", "Chiroptera", "Primates")) %>% # include only rodents, bats, and primates /
         # inclut uniquement les rongeurs, les chauves-souris et les primates
  group_by(order, genus) %>% # group by 2 types of categories / regrouper par 2 types de catégories
  summarize(n_records = n(), # summarize total number of rows / résumer le nombre total de lignes
            n_unique_records = n_distinct(gbifID)) # summarize number of unique records / 
        # résumer le nombre d'enregistrements uniques

df_sum2

View(df_sum2) # what are we checking for here? / qu'est-ce qu'on vérifie ici ?

boxplot(df_sum2$n_records ~ df_sum2$order)

# how many are missing values? / combien de valeurs manquent ?
View(df2 %>% filter(species == ""))

# visualizations with a new dataset:
# visualisations avec un nouvel ensemble de données:
names(colonies_df)
head(colonies_df)

# how to extract year from a date:
# comment extraire l'année d'une date:

colonies_df2 <- colonies_df %>%
  mutate(date = ymd(date)) %>%
  mutate(year = year(date)) %>%
  mutate(month = month(date))

View(colonies_df2)

colonies_sum <- colonies_df2 %>%
  group_by(Long, Lat, Country, Location) %>%
  summarize(n_observations = n(),
            avg_count = mean(count),
            min_count = min(count), 
            max_count = max(count))

# are you getting an error? why?
# obtenez-vous une erreur? pourquoi ?

colonies_sum <- colonies_df %>%
  group_by(Long, Lat, Country, Location) %>%
  summarize(n_observations = n(),
            avg_count = mean(Count),
            min_count = min(Count), 
            max_count = max(Count))

# do you see any issues? explore on your own!
# voyez-vous des problèmes? explorez par vous-même!

View(colonies_df %>%
  filter(Country == "Zambia"))

# remove /supprimer les NAs:

colonies_sum <- colonies_df %>%
  filter(!is.na(Count)) %>%
  group_by(Long, Lat, Country, Location) %>%
  summarize(n_observations = n(),
            avg_count = mean(Count),
            min_count = min(Count), 
            max_count = max(Count))

colonies_sum
  
# Data Visualization with ggplot2
# Create a line plot of average count vs. total observations:

# Visualisation de données avec ggplot2
# Créez un tracé linéaire du nombre moyen par rapport au total des observations:

ggplot(colonies_sum, aes(x = n_observations, y = avg_count)) +
  geom_line() +
  theme_minimal()

# Create a bar plot by country:
# Créer un graphique à barres par pays:
ggplot(colonies_sum, aes(x = Country, y = avg_count, fill = Country)) +
  geom_bar(stat="identity", position="dodge") +
  theme_classic()

p1 <- colonies_sum %>%
  filter(!Country == "Zambia") %>%
  ggplot(aes(x = Country, y = avg_count, fill = Country)) +
  geom_bar(stat="identity", position="dodge") +
  coord_flip() +
  theme_classic()

p1

# another option: try geom_jitter:
# une autre option: essayez geom_jitter:
colonies_df2 <- subset(colonies_df, colonies_df$Country!="Zambia")
p1b <- ggplot(aes(x = Country, y = Count, fill = Country), data = colonies_df2) +
  geom_boxplot(outlier.shape = NA) +
  geom_jitter(color="black", size=0.4, alpha=0.9, width = 0.2)

p1b

p2 <- colonies_sum %>%
  filter(!Country == "Zambia") %>%
  ggplot(aes(x = Country, y = n_observations, fill = Country)) +
  geom_bar(stat="identity", position="dodge") +
  coord_flip() +
  theme_classic()

p2

# try using a facet wrap, with different scaling options:
# essayez d'utiliser un habillage de facettes, avec différentes options de mise à l'échelle:

p3 <- colonies_df2 %>%
  filter(Country %in% c("Ghana", "Kenya")) %>%
  ggplot(aes(x = Location, y = Count, fill = as.factor(year))) +
  geom_bar(stat="identity", position="dodge") +
  coord_flip() +
 # facet_wrap(~Country) +
 # facet_wrap(~Country, scales = "free_y") +
  facet_wrap(~Country, scales = "free") +
  theme_classic()

p3

# use patchwork to make a multi panel plot:
# utilisez patchwork pour créer un tracé multi-panneaux:
p1 + p2

# explore more options for patchwork:
# explorez plus d'options pour le patchwork:
p1 + p2 + plot_annotation(tag_levels = "A") + plot_layout(guides = "collect")

?patchwork

# saving a plot with specific resolution, size, etc:
# enregistrer un tracé avec une résolution, une taille, etc. spécifiques:
ggsave(plot = last_plot(), "colonies_figure_1.png", width = 8, height = 6,
       units = "in", bg = NULL)

# where is that figure saved?
# où ce chiffre est-il enregistré?
getwd()

ggsave(plot = p1, "colonies_figure_1a.png", dpi = 400, bg = NULL)

# view more options:
# afficher plus d'options:
?ggsave

##### convert between long and wide format /  convertir entre le format long et large #####

colonies_wide <- colonies_df %>%
  mutate(year = year(date)) %>%
  filter(year > 2010) %>%
  select(X, year, Country, Location, Long, Lat, Count) %>%
  pivot_wider(names_from = year, values_from = Count)
  
colonies_long <- colonies_wide %>%
  pivot_longer(names_to = "year", 
               cols = c("2013", "2014", "2015", "2012", "2011"),
               values_to = "Count", values_drop_na = TRUE)

# sometimes you may need to convert between long & wide to get
# data into a format that is right for whichever ggplot type
# you want to make.

# Parfois, vous devrez peut-être convertir entre long et large pour obtenir
# données dans un format adapté à n'importe quel type de ggplot
# que tu veux faire.

####### more advances statistical tests / tests statistiques plus avancés ######

# Power analyses: determine optimal sample sizes:
# Analyses de puissance: déterminer les tailles d'échantillon optimales:
?power.t.test
power.t.test(n = NULL, delta = 0.95, power = NULL, sig.level = 0.05)

# what happens to sample size if you set power to 1?
# qu'arrive-t-il à la taille de l'échantillon si vous réglez la puissance sur 1?

power.anova.test(groups = 4, n = NULL, between.var = 0.4, 
                 within.var = 0.5, power = 0.95, sig.level = 0.05)

power.prop.test(p1 = .5, p2 = 0.501, sig.level=.05, power=0.90)

# Another t-test example: t-test for comparing before and after 2011:
# Autre exemple de test t : test t pour comparer avant et après 2011:
group1 <- colonies_df2 %>%
  filter(year >= 2011) %>%
  pull(Count)

group2 <- colonies_df2 %>%
  filter(year < 2011) %>%
  pull(Count)

t_test_result <- t.test(group1, group2)

# Print t-test result
# Imprimer le résultat du test t
print(t_test_result)

# anova: comparing variance between groups
# anova: comparaison de la variance entre les groupes
mod1 <- aov(Count ~ Country, data = colonies_df2)
summary.aov(mod1)

mod2 <- aov(Count ~ Country + year, data = colonies_df2)
summary.aov(mod2)

# do groups differ?
# which groups differ?

# les groupes diffèrent-ils?
# Quels groupes diffèrent?
?TukeyHSD
TukeyHSD(mod2, "Country")

### linear model
### modèle linéaire
mod3 <- lm(Count ~ Country + year, data = colonies_df2)

# is this different from the previous anova (mod2)?
# est-ce différent de l'anova précédente (mod2)?
summary(mod3)
str(mod3)

# explore model output:
# explorer la sortie du modèle:
View(data.frame(mod1$effects, mod1$residuals))

# testing assumptions: do the residuals look normally distributed?
# hypothèses de test: les résidus semblent-ils normalement distribués?
stats::qqnorm(resid(mod3))
hist(resid(mod3))

### transformation & addition of an interaction to see if residuals improve:
### transformation & ajout d'une interaction pour voir si les résidus s'améliorent:

mod4 <- lm(log10(Count + 1) ~ Country*year + month, data = colonies_df2)
summary(mod4)

stats::qqnorm(resid(mod4), plot.it = TRUE)
hist(resid(mod4)) 

# try a model with intercept alone:
# essayez un modèle avec interception seule:
mod0 <- lm(log10(Count + 1) ~ 1, data = colonies_df2)
summary(mod0)

# compare this null model against your model with year and country interaction:
# comparez ce modèle nul à votre modèle avec l'interaction entre l'année et le pays:
anova(mod0, mod4)

# find the R squared values for each model
# which model explains more variance?
# how well does a model with just year perform compared to year*Country?

# another way to compare models: AIC, AICc, and BIC:
# you will need to look into this more as a follow-up to this class,
# but the purpose of this code is to show options for comparing
# different models & model evaluation tools.

# trouver les valeurs R au carré pour chaque modèle
# quel modèle explique plus de variance ?
# Quelles sont les performances d'un modèle avec seulement une année par rapport à l'année*Pays?

# une autre façon de comparer les modèles : AIC, AICc et BIC :
# vous devrez approfondir cela dans le cadre du suivi de ce cours,
# mais le but de ce code est d'afficher des options de comparaison
# différents modèles et outils d'évaluation de modèles.

AIC(mod0, mod4)
BIC(mod0, mod4)


### testing for correlation: variance inflation factor
### test de corrélation: facteur d'inflation de la variance
mod5 <- lm(log10(Count + 1) ~ Country + year + month + 
             ratio, data = colonies_df2)
summary(mod5)

?vif
# use :: to call a function from a specific package:
# utilisez :: pour appeler une fonction à partir d'un package spécifique:
car::vif(mod5)
car::vif(mod5, type = "predictor")

cor.test(colonies_df$Count, colonies_df$Long)
cor.test(colonies_df$Count, colonies_df$min_mean_duration)
cor.test(colonies_df$Count, colonies_df$X)

# why might row number be correlated with count? consider experimental design
# pourquoi le numéro de ligne pourrait-il être corrélé au nombre? envisager la conception expérimentale

# get confidence intervals from model output:
# obtenir les intervalles de confiance à partir des résultats du modèle:
confint(mod5)

# remember that all statistical tests have assumptions!
# it is important to consider those assumptions & evaluate whether
# the test you have chosen is appropriate. additionally, understanding
# potential sources of biases (spatial autocorrelation, temporal 
# autocorrelation, non-independent sampling, etc) is important 
# when interpreting results.

# rappelez-vous que tous les tests statistiques ont des hypothèses!
# il est important de considérer ces hypothèses et d'évaluer si
# le test que vous avez choisi est approprié. en outre, comprendre
# sources potentielles de biais (autocorrélation spatiale,
# autocorrélation, échantillonnage non indépendant, etc.) est important
# lors de l'interprétation des résultats.

# centering & standardizing:
# centrage et normalisation:
global_mean <- mean(colonies_df2$Count, na.rm = TRUE)
global_sd <- sd(colonies_df2$Count, na.rm = TRUE)
colonies_df2_std <- colonies_df2 %>%
  mutate(count_standardized = (Count - global_mean)/global_sd) %>%
  mutate(count_centered = Count - global_mean)

# this type of standardization ((value - population mean)/population sd) 
# is called z-scoring and can be calculated with some packages
# or is easy to create as a new variable using code such as above

# ce type de standardisation ((valeur - moyenne de la population)/écart-type de la population)
# est appelé z-scoring et peut être calculé avec certains packages
# ou est facile à créer en tant que nouvelle variable en utilisant un code tel que ci-dessus

hist(colonies_df2_std$count_standardized)
hist(colonies_df2_std$count_centered)

mod6 <- lm(count_standardized ~ Country + year + month + 
             ratio, data = colonies_df2_std)
summary(mod6)
hist(resid(mod6))
qqnorm(resid(mod6))

# why is this type of standardization perhaps not the best
# for this given data set? think: distribution

# pourquoi ce type de standardisation n'est-il peut-être pas le meilleur
# pour cet ensemble de données donné? pensez: distribution
?distribution

##### logistic regression / régression logistique####
# generate some presence/absence data:
# générer des données de présence/absence:

set.seed(123) 

pres <- rep(c(0,1,1,1,1,0,0,0,0,1,0,1,0,0,1), 2)
var1 <- c(rnorm(15, mean = 50, sd = 4), rnorm(15, mean = 25, sd = 2))
var2 <- c(rnorm(10, mean = -10, sd = 4), rnorm(20, mean = -20, sd = 0.5))

pres_df <- data.frame(cbind(pres, var1, var2))

mod_a <- glm(pres ~ var1, data = pres_df, family = binomial(link = "logit"))
summary(mod_a)

mod_b <- glm(pres ~ var1 + var2, data = pres_df, family = binomial(link = "logit"))
summary(mod_b)

# interpreting model output is slightly different for logistic regression.
# look into this on your own to explore why!

# L'interprétation des résultats du modèle est légèrement différente pour la régression logistique.
# Examinez cela par vous-même pour découvrir pourquoi!

qqnorm(resid(mod_b))

# why do these residuals look so weird? does it really make sense to
# look at residuals for a logistic regression? what other ways can you
# determine if you data meets the assumptions of different model types?

# pourquoi ces résidus semblent-ils si bizarres? est-ce vraiment logique de
# regarder les résidus pour une régression logistique ? de quelles autres manières pouvez-vous
# déterminer si vos données répondent aux hypothèses des différents types de modèles?

######## BONUS EXERCISE / EXERCICE EN PRIME ######
# in groups of 2, work together to design & create an awesomely bad ggplot.
# consider using: terrible colors, un-intuitive plot types, design choices
# that make interpretation confusing, etc. we will then present
# each awesomely bad plot & explain to the group why they are against the 
# principles of data visualization. the worst plot wins!

# En groupes de 2, travaillez ensemble pour concevoir et créer un ggplot incroyablement mauvais.
# envisagez d'utiliser: des couleurs épouvantables, des types d'intrigues peu intuitifs, 
# des choix de conception qui rendent l'interprétation confuse, etc. nous présenterons ensuite
# chaque intrigue incroyablement mauvaise et expliquez au groupe pourquoi ils sont contre le
# principes de visualisation des données. le pire complot gagne !
