#--------------------------------------#
# ACTIVATION DES LIRAIRIES NECESSAIRES #
#--------------------------------------#
install.packages("rpart")
library(rpart)
install.packages("rpart.plot")
library(rpart.plot)
install.packages("C50")
library(C50)
install.packages("randomForest")
library(randomForest)
install.packages("e1071")
library(e1071)
install.packages("naivebayes")
library(naivebayes)
install.packages("nnet")
library(nnet)
install.packages("kknn")
library(kknn)
install.packages("ROCR")
library(ROCR)
install.packages("rvest")
library(rvest)
install.packages("ggplot2")
library(ggplot2)
install.packages("plyr")
library(plyr)
install.packages("dplyr")
library(dplyr)
install.packages("scales")
library(scales)
install.packages("maps")
library(maps)
install.packages("mapproj")
library(mapproj)
install.packages("plotly")
library(plotly)
install.packages("qplot")
library(qplot)
library(ggplot2)
install.packages("digest")
library(digest)
install.packages("stringr")
library(stringr)
install.packages("sqldf")
library(sqldf)
install.packages("tree")
library(tree)

#the directory
getwd()

#Visualisation
str(catalogue)
str(immatriculations)
str(marketing)
str(client)


#----------------------------------------------#
#join immatriculations and client#
#----------------------------------------------#
names(Immatriculation_Data)
customer <-merge(Customers_Data, Immatriculation_Data, by="immatriculation")

customer
client2voitures <- Customers_Data[Customers_Data$customers_ext.X2eme.Voiture!="FALSE",]
client2voitures
print(customer)

#test de doulons d'un seule matricule#

Immatriculation_Data[Immatriculation_Data$immatriculation=="1000 HF 96",]

#----------------------------------------------#
#changement des noms de colonnes#
#----------------------------------------------#

colnames(Customers_Data)[2] <- "customers_ext.age"
colnames(Customers_Data)[3] <- "customers_ext.sexe"
colnames(Customers_Data)[4] <- "customers_ext.taux"
colnames(Customers_Data)[5] <- "customers_ext.situationFamiliale"
colnames(Customers_Data)[6] <- "customers_ext.nbEnfantsAcharge"
colnames(Customers_Data)[7] <- "customers_ext.X2eme.Voiture"
colnames(Customers_Data)[8] <- "immatriculation"
colnames(Immatriculation_Data)[2] <- "immatriculation"

colnames(Customers_Data)

#DOUBLONS
#pour clients dans les immatriculations
doublons <- Customers_Data[duplicated(Customers_Data$immatriculation),]
doublons

sum(duplicated(Customers_Data$immatriculation))

client_unique<-unique(Customers_Data)
client_unique

Immatriculation_Data[Immatriculation_Data$immatriculation=="1557 AB 48",]

#delete the doubles in client 
Customers_Data <- Customers_Data[duplicated(Customers_Data$immatriculation) =="FALSE",]
client_sans_doublons <- Customers_Data[duplicated(Customers_Data$immatriculation) =="FALSE",]
client_sans_doublons

#doublons dans immatriculations:
doublons_immat <- Immatriculation_Data[duplicated(Immatriculation_Data$immatriculation)=="TRUE",]
doublons_immat

Immatriculation_Data <- Immatriculation_Data[duplicated(Immatriculation_Data$immatriculation)=="FALSE",]
immatriculations_sans_doublons <- Immatriculation_Data[duplicated(Immatriculation_Data$immatriculation) =="FALSE",]


#on relie les 2 tables 
customers <-merge(Customers_Data, Immatriculation_Data, by="...1")
#just to see the structure of the data 
table(Customers_Data$immatriculation)
str(Customers_Data)
str(Immatriculation_Data)

summary(customers)

#doubles in customers
customers[duplicated(customers$immatriculation)=="TRUE",]


#----------#
#CATEGORIES#
#----------#
Immatriculation_Data$immatriculation_ext.longueur <- as.factor(Immatriculation_Data$immatriculation_ext.longueur)
library(stringr)
Immatriculation_Data$immatriculation_ext.longueur <- str_replace(Immatriculation_Data$immatriculation_ext.longueur,"tr\xe8s longue", "treslongue")
summary(Immatriculation_Data)


#nuage de point categories de voiture
summary(catalogue_Data)
catalogue_Data
ggplot(catalogue_Data, aes(x = catalogue.longueur, y = catalogue.puissance)) + geom_point()

qplot(catalogue.longueur, catalogue.puissance, data= catalogue_Data)

qplot(catalogue.longueur, catalogue.nbplaces, data=catalogue_Data)

qplot(catalogue.longueur, catalogue.prix, data=catalogue_Data)

qplot(catalogue.nbplaces, catalogue.prix, data=catalogue_Data)

qplot(catalogue.nbplaces, catalogue.nbportes, data=catalogue_Data)

qplot(catalogue.longueur, catalogue.nbportes, data=catalogue_Data) 

qplot(catalogue.puissance, catalogue.prix, data=catalogue_Data, color=catalogue.longueur)

qplot(catalogue.nbplaces, catalogue.puissance, data=catalogue_Data)

qplot(catalogue.nom, catalogue.prix, data=catalogue_Data, color=catalogue.longueur)


#doubles catalogue
catalogue_Data[duplicated(catalogue_Data)=="TRUE",]
#none


Coupé <- catalogue_Data[catalogue_Data$catalogue.longueur=="courte",]
Crossover <- catalogue_Data[catalogue_Data$catalogue.nbplaces==7,]
sport <- catalogue_Data[catalogue_Data$catalogue.puissance >300,]
berlineconfort <- catalogue_Data[catalogue_Data$catalogue.longueur=="treslongue" & catalogue_Data$catalogue.puissance> 190 & catalogue_Data$catalogue.puissance <300,]
Break <- catalogue_Data[catalogue_Data$catalogue.longueur=="longue"& catalogue_Data$catalogue.puissance <200,]
berline <- catalogue_Data[catalogue_Data$catalogue.longueur=="longue" & catalogue_Data$catalogue.nbplaces!=7,]
Fourgonnette <- catalogue_Data[catalogue_Data$catalogue.longueur=="moyenne" & catalogue_Data$catalogue.puissance <250,]
summary(Customers_Data)

#attribuer les cat?gories aux don?nes de Immatriculations

#first TEST :
immatriculation_Data$categorie <- ifelse(Immatriculation_Data$immatriculation_ext.longueur =="courte", Immatriculation_Data$categorie <- "Coupé", 
                                     ifelse(Immatriculation_Data$immatriculation_ext.nbplaces ==7, immatriculation$categorie <- "Crossover", 
                                            ifelse(Immatriculation_Data$immatriculation_ext.puissance >= 200 & Immatriculation_Data$immatriculation_ext.longueur=="treslongue", Immatriculation_Data$categorie <- "sport", Immatriculation_Data$categorie <- "berlineconfort")))

#corrected TEST 1 :
Immatriculation_Data$categorie <- ifelse(Immatriculation_Data$immatriculation_ext.longueur == "courte", "Coupé", 
                                         ifelse(Immatriculation_Data$immatriculation_ext.nbplaces == 7, "Crossover", 
                                                ifelse(Immatriculation_Data$immatriculation_ext.puissance >= 200 & Immatriculation_Data$immatriculation_ext.longueur == "treslongue", "sport", "berlineconfort")))

#second TEST :
immatriculations$categorie <- ifelse(immatriculations$longueur =="courte", immatriculations$categorie <- "citadine", 
                                     ifelse(immatriculations$nbPlaces ==7, immatriculation$categorie <- "monospace", 
                                            ifelse(immatriculations$puissance > 300, immatriculations$categorie <- "sport", 
                                                   ifelse(immatriculations$longueur =="treslongue" & immatriculations$puissance> 190 & immatriculations$puissance <300, immatriculations$categorie <- "berlineconfort", 
                                                          ifelse(immatriculations$longueur=="moyenne", immatriculations$categorie <- "berlinecompact", immatriculations$categorie<- "berline")))))

#corrected TEST 2:

Immatriculation_Data$categorie <- ifelse(Immatriculation_Data$immatriculation_ext.longueur == "courte", "Coupé", 
                                     ifelse(Immatriculation_Data$immatriculation_ext.nbplaces == 7, "Crossover", 
                                            ifelse(Immatriculation_Data$immatriculation_ext.puissance > 300, "sport", 
                                                   ifelse(Immatriculation_Data$immatriculation_ext.longueur == "treslongue" & Immatriculation_Data$immatriculation_ext.puissance >= 190 & Immatriculation_Data$immatriculation_ext.puissance < 300 & Immatriculation_Data$immatriculation_ext.longueur != "courte" & Immatriculation_Data$immatriculation_ext.longueur != "moyenne", "berlineconfort", 
                                                          ifelse(Immatriculation_Data$immatriculation_ext.longueur == "moyenne", "Break", "berline")))))


Immatriculation_Data[Immatriculation_Data$immatriculation_ext.nbplaces == 7, ]

#no nb place==7
summary(Immatriculation_Data)
Immatriculation_Data$categorie<- as.factor(Immatriculation_Data$categorie)
#join between imma and client 
customers <-merge(Customers_Data, Immatriculation_Data, by="...1")
summary(customers)
customers$situationFamiliale<-as.factor(customers$situationFamiliale)
class(customers$customers_ext.situationFamiliale)
customers$situationFamiliale <- gsub("Mari\\�\\(e\\)", "En Couple", customers$situationFamiliale)

#del column not usefull 

View(customers)
customers <- subset(customers, select= -immatriculation)
customers <- subset(customers, select= -immatriculation_ext.nbplaces)

names(customers)
customers


#training part

# Load the caret package
install.packages("caret")
library(caret)

# Set the seed for reproducibility
set.seed(123)

# Split the dataset into 70% training and 30% testing
train_indices <- createDataPartition(customers$categorie, p = 0.7, list = FALSE)
View(train_indices)
training_data <- customers[train_indices, ]
View(training_data)
testing_data <- customers[-train_indices, ]
View(testing_data)
testing_data <- testing_data[, -which(names(testing_data) == "categorie")]
summary(training_data)
summary(testing_data)

#------------#
#CLASSIFIEURS#
#------------#

#Suppression des variables inutiles

training_data <- subset(training_data, select = -immatriculation_ext.nbportes)
training_data <- subset(training_data, select = -immatriculation_ext.longueur)
training_data <- subset(training_data, select = -immatriculation_ext.puissance)
training_data <- subset(training_data, select = -immatriculation_ext.marque)
training_data <- subset(training_data, select = -immatriculation_ext.nom)
training_data <- subset(training_data, select = -immatriculation_ext.couleur)
training_data <- subset(training_data, select = -immatriculation_ext.occasion)
training_data <- subset(training_data, select = -immatriculation_ext.prix)
training_data <- subset(training_data, select = -immatriculation.x)
training_data <- subset(training_data, select = -immatriculation.y)
training_data[duplicated(training_data)=="TRUE",]
summary(testing_data)

testing_data <- subset(testing_data, select = -immatriculation_ext.nbportes)
testing_data <- subset(testing_data, select = -immatriculation_ext.longueur)
testing_data <- subset(testing_data, select = -immatriculation_ext.puissance)
testing_data <- subset(testing_data, select = -immatriculation_ext.marque)
testing_data <- subset(testing_data, select = -immatriculation_ext.nom)
testing_data <- subset(testing_data, select = -immatriculation_ext.couleur)
testing_data <- subset(testing_data, select = -immatriculation_ext.occasion)
testing_data <- subset(testing_data, select = -immatriculation_ext.prix)
testing_data <- subset(testing_data, select = -immatriculation.x)
testing_data <- subset(testing_data, select = -immatriculation.y)

names(testing_data)
names(training_data)


#-------------#
# NAIVE BAYES #
#-------------#

# Apprentissage du classifeur de type naive bayes
#se the laplace = 1 argument in the naive_bayes() function to 
#apply Laplace smoothing with a smoothing factor of 1. For example:
#to avoid having zero probabilities for a particular feature value given a certain class

#no missing values 
sum(is.na(testing_data))
sum(is.na(training_data))


nb <- naive_bayes(training_data$categorie~., training_data,laplace = 1)
nb

# Check levels of categorical variables in training data
cat_vars <- c("sexe", "situationFamiliale", "X2eme.voiture", "categorie")
for(var in cat_vars){
  print(paste0("Levels in training_data$", var, ": "))
  print(levels(training_data[, var]))
}

# Check levels of categorical variables in new data
cat_vars <- c("sexe", "situationFamiliale", "X2eme.voiture", "categorie")
for(var in cat_vars){
  print(paste0("Levels in testing_data$", var, ": "))
  print(levels(testing_data[, var]))
}

# Find common columns between client_EA and client_ET
common_cols <- intersect(names(training_data), names(testing_data))

# Only keep common columns in client_ET
testing_data <- testing_data[, common_cols]
length(testing_data$categorie)


# Test du classifieur : classe predite
nb_class <- predict(nb, testing_data, type = "class")

table(nb_class)


# Test du classifieur : probabilites pour chaque prediction
nb_prob <- predict(nb, testing_data, type="prob")
nb_prob

testing_data$categorie_predicted <- nb_class
# Matrice de confusion
table( testing_data$categorie, nb_class)


#-------------#
# C5.0      NOT WORKING  #
#-------------#

training_data$categorie <- as.factor(training_data$categorie)
training_data$X2eme.voiture <- as.factor(training_data$X2eme.voiture)
class(tree_C50)
typeof(tree_C50)

# Apprentissage du classifeur de type arbre de d?cision
unique(training_data$sexe)
unique(training_data$situationFamiliale)
unique(training_data$longueur)
unique(training_data$categorie)
training_data$sexe <- gsub("F�F", "F", training_data$sexe)
training_data$categorie <- gsub("Coupé", "Coupe", training_data$categorie)
any(is.na(training_data))

training_data$categorie <- as.factor(training_data$categorie)

tree_C50 <- C5.0(training_data$categorie ~ ., data = training_data)
tree_C50
summary(tree_C50)
plot(tree_C50, type="simple")

#-----------------#
# NEURAL NETWORKS #
#-----------------#


# Apprentissage du classifeur de type perceptron monocouche
install.packages("nnet")
library(nnet)


classifieur_nn <- nnet(categorie~age + sexe +taux+ situationFamiliale+nbEnfantsAcharge+X2eme.voiture, training_data, size=6)

# Load the caret package
library(caret)

# Define the training control for cross-validation
ctrl <- trainControl(method = "cv", number = 10)

# Train the model using 10-fold cross-validation
model <- train(categorie ~ age + sexe + taux + situationFamiliale + nbEnfantsAcharge + X2eme.voiture, 
               data = training_data, 
               method = "nnet",
               trControl = ctrl,
               tuneLength = 5,
               trace = FALSE)

# Print the model results
print(model)

#---------------------#
# Rpart #
#---------------------#
library(rpart)

# Create the model using rpart
rpart_model <- rpart(categorie ~ ., data = training_data)

# Print the model summary
summary(rpart_model)

# Plot the tree
plot(rpart_model)
text(rpart_model)


#---------------------#
# K-NEAREST NEIGHBORS #
#---------------------#
client_EA <- customers[1:20000,]
client_EA

View(client_EA)
client_ET <- customers[20000:40000,]
client_ET

View(client_ET)
# Apprentissage et test simultanes du classifeur de type k-nearest neighbors
classifieur_knn <- kknn(categorie~., client_EA, client_ET)
# Error in if (response != "continuous") { : 
#     l'argument est de longueur nulle
classifieur_knn <- kknn(categorie~age + sexe +taux+ situationFamiliale+nbEnfantsAcharge+X2eme.voiture, client_EA, client_ET)

# Error in if (response != "continuous") { : 
#     l'argument est de longueur nulle

#------#
#R-PART#
#------#
# Create the model using rpart
rpart_model <-rpart(categorie ~ age + sexe + taux + situationFamiliale + nbEnfantsAcharge + X2eme.voiture,
                    data = training_data)

summary(rpart_model)
# Plot the tree
plot(rpart_model)
text(rpart_model)


#---------------------#
# K-NEAREST NEIGHBORS #
#---------------------#

# Apprentissage et test simultanes du classifeur de type k-nearest neighbors
classifieur_knn <- kknn(categorie~., client_EA, client_ET)
# Error in if (response != "continuous") { : 
#     l'argument est de longueur nulle
classifieur_knn <- kknn(categorie~age + sexe +taux+ situationFamiliale+nbEnfantsAcharge+X2eme.voiture, client_EA, client_ET)
# Error in if (response != "continuous") { : 
#     l'argument est de longueur nulle

#------#
#R-PART#
#------#
# Create the model using rpart
rpart_model <-rpart(categorie ~ age + sexe + taux + situationFamiliale + nbEnfantsAcharge + X2eme.voiture,
                    data = training_data)

summary(rpart_model)
# Plot the tree
plot(rpart_model)
text(rpart_model)

#----#
#TREE#
#----#
classifieur_tree <-tree(categorie~age + sexe +taux+nbEnfantsAcharge+X2eme.voiture,training_data)
plot(classifieur_tree)
text(classifieur_tree)


#----#
#RANDOM FOREST#
#----#
library(randomForest)
# Train random forest model
rf_model <- randomForest(categorie~., training_data, ntree = 500)
# Predict on test data
rf_pred <- predict(rf_model, testing_data)

# Evaluate model performance
conf_mat <- table(rf_pred, testing_data$categorie)
# Evaluate the accuracy of the model
accuracy <- sum(diag(conf_mat))/sum(conf_mat)
cat("Accuracy:", round(accuracy, 3))
# Print the confusion matrix
table(rf_pred, testing_data$categorie)
testing_data