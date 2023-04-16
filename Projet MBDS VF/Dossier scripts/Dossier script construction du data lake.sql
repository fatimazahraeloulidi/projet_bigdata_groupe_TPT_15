 ______________Dossier script construction du lac de données_________________

//Importation des données des fichiers .CSV dans la machine Virtuel /home/Vagrant

//fichier CO2.csv
-> scp -P 2222 -i C:\Users\hp\vagrant-projects\OracleDatabase\21.3.0\.vagrant\machines\oracle-21c-vagrant\virtualbox\private_key C:\Users\hp\vagrant-projects\OracleDatabase\21.3.0\CO2.csv vagrant@127.0.0.1:/home/vagrant/CO2.csv 

//fichier Catalogue.csv
-> scp -P 2222 -i C:\Users\hp\vagrant-projects\OracleDatabase\21.3.0\.vagrant\machines\oracle-21c-vagrant\virtualbox\private_key C:\Users\hp\vagrant-projects\OracleDatabase\21.3.0\Catalogue.csv vagrant@127.0.0.1:/home/vagrant/Catalogue.csv

//fichier customers_ext_14.csv
-> scp -P 2222 -i C:\Users\hp\vagrant-projects\OracleDatabase\21.3.0\.vagrant\machines\oracle-21c-vagrant\virtualbox\private_key C:\Users\hp\vagrant-projects\OracleDatabase\21.3.0\customers_ext_14.csv vagrant@127.0.0.1:/home/vagrant/customers_ext_14.csv
//fichier customers_ext_5.csv

-> scp -P 2222 -i C:\Users\hp\vagrant-projects\OracleDatabase\21.3.0\.vagrant\machines\oracle-21c-vagrant\virtualbox\private_key C:\Users\hp\vagrant-projects\OracleDatabase\21.3.0\customers_ext_5.csv vagrant@127.0.0.1:/home/vagrant/customers_ext_5.csv

//fichier Marketing.csv

-> scp -P 2222 -i C:\Users\hp\vagrant-projects\OracleDatabase\21.3.0\.vagrant\machines\oracle-21c-vagrant\virtualbox\private_key C:\Users\hp\vagrant-projects\OracleDatabase\21.3.0\Marketing.csv vagrant@127.0.0.1:/home/vagrant/Marketing.csv

//	Création d'une base de données MongoDB
// commande basic de MongoDB
-> sudo systemctl start mongod
mongo
// List databases
-> show dbs;
// Create or select existing database
-> use my_db;
// List collections
-> show collections;

//Chargement des fichiers "Marketing.csv" dans la base créée dans MONGO

-> mongoimport --db my_db --collection marketing --type csv --headerline --file /home/vagrant/Marketing.csv

//pour afficher les données de la collection marketing

-> db.marketing.find()
//totale des documents dans la collection marketing
-> db.marketing.count()

//Chargement des fichiers "customers_exts.csv" dans la base créée dans MONGO

-> mongoimport --db my_db --collection customers --type csv --headerline --file /home/vagrant/customers_ext_5.csv
-> mongoimport --db my_db --collection customers --type csv --headerline --file /home/vagrant/customers_ext_14.csv

//pour afficher les données de la collection customers

-> db.customers.find()
//totale des documents dans la collection customers
db.marketing.count()

//Paramétrage de l'environnement HDFS
//pour démarrer tous les démons Hadoop en même temps sur un cluster (NameNode,Secondary NameNode,DataNode,JobTracker,TaskTracker)
-> start-all.sh

//vérifier l'état des processus de la machine virtuelle Java (JVM) en cours d'exécution sur un nœud
-> jps

// Creation du directory input ou on va stocker le fichier 
-> hdfs dfs -mkdir /home/vagrant/CO2.CSV /user/hadoop/input

// Transfere du fichier vers le dossier "input"
-> hdfs dfs -put /home/vagrant/CO2.CSV /user/hadoop/input

//pour voir les fichiers uploader 
-> ls 
//Acceder a KVstore (setup)

//Start KVstore using KVLite utility 
nohup java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar kvlite -secure-config disable -root $KVROOT > kvstore.log 2>&1 &

//Ping KVstore
java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar ping -host localhost -port 5000

//Start KVStoreAdmincustomers_ext
java -Xmx256m -Xms256m -jar $KVHOME/lib/kvstore.jar runadmin -host localhost -port 5000

//Start SQL Shell
java -Xmx256m -Xms256m -jar $KVHOME/lib/sql.jar -helper-hosts localhost:5000 -store kvstore

//Creation du table immatriculations dans kvstore :

CREATE TABLE immatrculations (
  immatriculation string,
  marque string,
  nom string ,
  puissance INTEGER,
  longueur string,
  nbplaces INTEGER,
  nbportes INTEGER,
  couleur string, 
  occasion BOOLEAN, 
  prix INTEGER, 
  PRIMARY KEY (immatriculation)
);

//Chargement du fichier "immatriculations.csv" dans la table immatriculation dans Kvstore

Import -table immatriculations -file '/home/vagrant/Immatriculationsave.csv' csv

//Création des tables EXTERNES et INTERNES dans HIVE
// Marketing_ext 
CREATE EXTERNAL TABLE customers_ext (
    id STRING,
    age INT,
    sexe STRING,
    taux INT,
    situationFamiliale STRING,
    nbEnfantsAcharge INT,
    deuxiemeVoiture BOOLEAN,
    immatriculation STRING

) STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler' 
TBLPROPERTIES ('mongo.uri'='mongodb://my-mongo-host/mydb.customers');

//customers_ext

CREATE EXTERNAL TABLE marketing_ext (
    age STRING,
    sexe INT,
    taux INT,
    situationFamiliale STRING,
    nbEnfantsAcharge INT,
    deuxiemeVoiture BOOLEAN,

) STORED BY 'com.mongodb.hadoop.hive.MongoStorageHandler' 
TBLPROPERTIES ('mongo.uri'='mongodb://my-mongo-host/mydb.customers');

//co2_ext

CREATE EXTERNAL TABLE co2_ext (
  marque_modele STRING,
  bonus_malus STRING,
  rejets_co2 FLOAT,
  cout_energie FLOAT
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE
LOCATION '/user/hadoop/input/';

//Catalogue : interne

CREATE LOCAL TABLE Catalogue (
  marque string,
  nom string,
  puissance int,
  longueur string,
  nbPlaces int,
  nbPortes int,
  couleur string,
  occasion string,
  prix double
)
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
STORED AS TEXTFILE;

//immatriculation_ext

CREATE EXTERNAL TABLE immatriculation_ext (
  immatriculation string,
  marque string,
  nom string,
  puissance int,
  longueur string,
  nbPlaces int,
  nbPortes int,
  couleur string,
  occasion boolean,
  prix int
)
STORED BY 'oracle.kv.hadoop.hive.table.TableStorageHandler'
TBLPROPERTIES (
    "oracle.kv.kvstore" = "kvstore",
    "oracle.kv.hosts" = "localhost:5000",
    "oracle.kv.tableName" = "immatriculations"

);