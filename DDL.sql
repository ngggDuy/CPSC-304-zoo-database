-- SQL to drop all tables (pasting here for convenience)
-- select 'drop table '||table_name||' cascade constraints;' from user_tables;

-- TABLES
CREATE TABLE Biomes(
	type CHAR(50) PRIMARY KEY,
	temperature CHAR(50) NOT NULL,
	humidity CHAR(50) NOT NULL
);

CREATE TABLE EnclosureDimensions(
	squareFt INTEGER,
	type CHAR(50),
	capacity INTEGER NOT NULL,
	PRIMARY KEY (squareFt, type),
	FOREIGN KEY (type) REFERENCES Biomes(type) ON DELETE CASCADE
);

CREATE TABLE Enclosures(
	enclosureID INTEGER PRIMARY KEY,
	name CHAR(50) NOT NULL UNIQUE,
	squareFt INTEGER NOT NULL,
	type CHAR(50) NOT NULL,
	FOREIGN KEY (squareFt, type) REFERENCES EnclosureDimensions(squareFt, type) 
);

CREATE TABLE Species(
	species CHAR(100) PRIMARY KEY,
	animalGroup CHAR(100) NOT NULL
);

CREATE TABLE Breeds(
	breedID INTEGER PRIMARY KEY,
	breed CHAR(100) UNIQUE NOT NULL,
	species CHAR(100) NOT NULL,
	facts CHAR(1000),
	status CHAR(50) NOT NULL,
	FOREIGN KEY (species) REFERENCES Species(species)
);

CREATE TABLE Animals(
    animalID INTEGER PRIMARY KEY,
	name CHAR(50) NOT NULL, 
	breedID INTEGER NOT NULL, 
	enclosureID INTEGER NOT NULL, 
	birthDate DATE NOT NULL,
	sex CHAR(2) NOT NULL,
	age INTEGER,
	weight INTEGER,
	arrivalDate DATE,
	deceasedDate DATE,
	bioData VARCHAR(1000),
	FOREIGN KEY (breedID) REFERENCES Breeds(breedID), 
	FOREIGN KEY (enclosureID) REFERENCES Enclosures(enclosureID)
);

CREATE TABLE ParentOF(
	parent_animalID INTEGER,
	child_animalID INTEGER,
	PRIMARY KEY (parent_animalID, child_animalID),
	FOREIGN KEY (parent_animalID) REFERENCES Animals(animalID),
	FOREIGN KEY (child_animalID) REFERENCES Animals(animalID)
);

CREATE TABLE Employees(
	employeeID INTEGER PRIMARY KEY,
	address CHAR(100) NOT NULL,
	firstName CHAR(100) NOT NULL,
	lastName CHAR(100) NOT NULL,
	email CHAR(100) UNIQUE,
	phoneNumber CHAR(100),
	sin INTEGER UNIQUE NOT NULL,
	birthDate DATE);

CREATE TABLE Feeders(
	employeeID INTEGER PRIMARY KEY,
	FOREIGN KEY (employeeID) REFERENCES Employees(employeeID) ON DELETE CASCADE);

CREATE TABLE Trainers(
	employeeID INTEGER PRIMARY KEY, 
	FOREIGN KEY (employeeID) REFERENCES Employees(employeeID) ON DELETE CASCADE);

CREATE TABLE Keepers(
	employeeID INTEGER PRIMARY KEY, 
	FOREIGN KEY (employeeID) REFERENCES Employees(employeeID) ON DELETE CASCADE);

CREATE TABLE Veterinarians(
	employeeID INTEGER PRIMARY KEY, 
	FOREIGN KEY (employeeID) REFERENCES Employees(employeeID) ON DELETE CASCADE);	

CREATE TABLE FoodSupplies(
	supplyID INTEGER PRIMARY KEY,
	name CHAR(100) NOT NULL,
	expiryDate DATE NOT NULL,
	quantity INTEGER NOT NULL,
	unit CHAR(50)
);

CREATE TABLE FeedingSchedules(
	feederID INTEGER,
	animalID INTEGER,
	keeperID INTEGER NOT NULL,
	dateTime DATE,
	PRIMARY KEY (feederID, animalID, dateTime),
	FOREIGN KEY (feederID) REFERENCES Feeders(employeeID)
		ON DELETE CASCADE,
	FOREIGN KEY (animalID) REFERENCES Animals(animalID)
		ON DELETE CASCADE,
	FOREIGN KEY (keeperID) REFERENCES Keepers(employeeID)
);

CREATE TABLE MadeUpOf(
	supplyID INTEGER,
	feederID INTEGER,
	animalID INTEGER,
	dateTime DATE,
	amount INTEGER NOT NULL,
	PRIMARY KEY (supplyID, feederID, animalID, dateTime),
	FOREIGN KEY (supplyID) REFERENCES FoodSupplies(supplyID),
	FOREIGN KEY (feederID, animalID, dateTime)
		REFERENCES FeedingSchedules(feederID, animalID, dateTime)
		ON DELETE CASCADE
);

CREATE TABLE Feed (
	feederID INTEGER,
	animalID INTEGER,
	PRIMARY KEY (feederID, animalID),
	FOREIGN KEY (feederID) REFERENCES Feeders(employeeID)
		ON DELETE CASCADE,
	FOREIGN KEY (animalID) REFERENCES Animals(animalID)
		ON DELETE CASCADE
);

CREATE TABLE Visitors(
	visitorID INTEGER PRIMARY KEY,
	firstName CHAR(100) NOT NULL,
	lastName CHAR(100) NOT NULl,
	birthDate DATE,
	address CHAR(100),
	phoneNumber CHAR(100),
	email CHAR(100) UNIQUE
);

CREATE TABLE VisitorRecords(
	recordID INTEGER PRIMARY KEY,
	visitorID INTEGER,
	visitDate DATE NOT NULL,
	FOREIGN KEY (visitorID) REFERENCES Visitors(visitorID)
		ON DELETE SET NULL
);

CREATE TABLE Events(
	eventID INTEGER PRIMARY KEY,
	enclosureID INTEGER NOT NULL,
	capacity INTEGER,
	description CHAR(1000),
	name CHAR(100) NOT NULL,
	startTime DATE NOT NULL,
	endTime DATE NOT NULL,
	FOREIGN KEY (enclosureID) REFERENCES Enclosures(enclosureID)
		ON DELETE CASCADE
);

CREATE TABLE Reserve(
	eventID INTEGER,
	visitorID INTEGER,
	PRIMARY KEY (eventID, visitorID),
	FOREIGN KEY (eventID) REFERENCES Events(eventID)
		ON DELETE CASCADE,
	FOREIGN KEY (visitorID) REFERENCES Visitors(visitorID)
		ON DELETE CASCADE
);

CREATE TABLE FeaturedIn(
	eventID INTEGER,
	animalID INTEGER,
	PRIMARY KEY (eventID, animalID),
	FOREIGN KEY (eventID) REFERENCES Events(eventID)
		ON DELETE CASCADE,
	FOREIGN KEY (animalID) REFERENCES Animals(animalID)
		ON DELETE CASCADE
);

CREATE TABLE HostedBy(
	eventID INTEGER,
	trainerID INTEGER,
	PRIMARY KEY (eventID, trainerID),
	FOREIGN KEY (eventID) REFERENCES Events(eventID)
		ON DELETE CASCADE,
	FOREIGN KEY (trainerID) REFERENCES Trainers(employeeID)
		ON DELETE CASCADE
);

CREATE TABLE ResponsibleFor(
	keeperID INTEGER, 
	animalID INTEGER, 
	PRIMARY KEY (keeperID, animalID), 
	FOREIGN KEY (keeperID) REFERENCES Keepers(employeeID) ON DELETE CASCADE,
	FOREIGN KEY (animalID) REFERENCES Animals(animalID) ON DELETE CASCADE);

CREATE TABLE TrainedBy(
	trainerID INTEGER, 
	animalID INTEGER, 
	PRIMARY KEY (trainerID, animalID), 
	FOREIGN KEY (trainerID) REFERENCES Trainers(employeeID) ON DELETE CASCADE, 
	FOREIGN KEY (animalID) REFERENCES Animals(animalID) ON DELETE CASCADE);

CREATE TABLE MedicalRecords(
	notes CHAR(1000), 
	purpose CHAR(1000) NOT NULL, 
	dateTime DATE, 
	animalID INTEGER, 
	vetID INTEGER NOT NULL, 
	PRIMARY KEY (dateTime, animalID), 
	FOREIGN KEY (animalID) REFERENCES Animals(animalID) ON DELETE CASCADE, 
	FOREIGN KEY (vetID) REFERENCES Veterinarians(employeeID));

-- INSERT STAMENETS

-- Biomes
-- Water, Savanna, Jungle, Ice, Plains, Grassland, Mountain, Forest
INSERT INTO Biomes (type , temperature , humidity) VALUES ('Water'     , 2.5  , 70.2); 
INSERT INTO Biomes (type , temperature , humidity) VALUES ('Savanna'   , 10.7 , 89.9); 
INSERT INTO Biomes (type , temperature , humidity) VALUES ('Jungle'    , 34.4 , 34.8); 
INSERT INTO Biomes (type , temperature , humidity) VALUES ('Ice'       , 37.9 , 50.0); 
INSERT INTO Biomes (type , temperature , humidity) VALUES ('Plains'    , 18.2 , 69.6); 
INSERT INTO Biomes (type , temperature , humidity) VALUES ('Grassland' , 2.3  , 91.5); 
INSERT INTO Biomes (type , temperature , humidity) VALUES ('Mountain'  , 31.5 , 58.9); 
INSERT INTO Biomes (type , temperature , humidity) VALUES ('Forest'    , 36.5 , 53.4); 

-- EnclosureDimensions
INSERT INTO EnclosureDimensions (squareFt , type , capacity) VALUES (8  , 'Water'     , 2); 
INSERT INTO EnclosureDimensions (squareFt , type , capacity) VALUES (8  , 'Savanna'   , 1); 
INSERT INTO EnclosureDimensions (squareFt , type , capacity) VALUES (7  , 'Jungle'    , 7); 
INSERT INTO EnclosureDimensions (squareFt , type , capacity) VALUES (5  , 'Ice'       , 6); 
INSERT INTO EnclosureDimensions (squareFt , type , capacity) VALUES (5  , 'Plains'    , 9); 
INSERT INTO EnclosureDimensions (squareFt , type , capacity) VALUES (29 , 'Grassland' , 3); 
INSERT INTO EnclosureDimensions (squareFt , type , capacity) VALUES (6  , 'Mountain'  , 7); 
INSERT INTO EnclosureDimensions (squareFt , type , capacity) VALUES (9  , 'Forest'    , 4);

-- Enclosures
INSERT INTO Enclosures (enclosureID , name , squareFt , type) VALUES (1 , 'Marine Animal Exhibit'      , 8  , 'Water');      
INSERT INTO Enclosures (enclosureID , name , squareFt , type) VALUES (2 , 'Lion Enclosure'             , 8  , 'Savanna');    
INSERT INTO Enclosures (enclosureID , name , squareFt , type) VALUES (3 , 'Small Animals ONLY'         , 7  , 'Jungle');     
INSERT INTO Enclosures (enclosureID , name , squareFt , type) VALUES (4 , 'All your favorite insects'  , 5  , 'Ice');        
INSERT INTO Enclosures (enclosureID , name , squareFt , type) VALUES (5 , 'Whales and other cool fish' , 5  , 'Plains');     
INSERT INTO Enclosures (enclosureID , name , squareFt , type) VALUES (6 , 'Definitely tigers'          , 29 , 'Grassland');  
INSERT INTO Enclosures (enclosureID , name , squareFt , type) VALUES (7 , 'Penguins and a LOT of ice'  , 6  , 'Mountain');   
INSERT INTO Enclosures (enclosureID , name , squareFt , type) VALUES (8 , 'Zebras, yep, Zebras'        , 9  , 'Forest');     

-- Species
INSERT INTO Species (species , animalGroup) VALUES ('Bear'                      , 'Mammal'   );              
INSERT INTO Species (species , animalGroup) VALUES ('Canidae'                   , 'Mammal'   );              
INSERT INTO Species (species , animalGroup) VALUES ('Alligatoridae'             , 'Reptile'  );              
INSERT INTO Species (species , animalGroup) VALUES ('Elephantidae'              , 'Mammal'   );              
INSERT INTO Species (species , animalGroup) VALUES ('Alouatta seniculus'        , 'Fish'     );              
INSERT INTO Species (species , animalGroup) VALUES ('Felis concolor'            , 'Fish'     );              
INSERT INTO Species (species , animalGroup) VALUES ('Coluber constrictor foxii' , 'Fish'     );              
INSERT INTO Species (species , animalGroup) VALUES ('Gabianus pacificus'        , 'Fish'     );              
INSERT INTO Species (species , animalGroup) VALUES ('Ramphastidae'              , 'Bird'     );              
INSERT INTO Species (species , animalGroup) VALUES ('Coracias caudata'          , 'Bird'     );              
INSERT INTO Species (species , animalGroup) VALUES ('Columba livia'             , 'Bird'     );              
INSERT INTO Species (species , animalGroup) VALUES ('Bassariscus astutus'       , 'Bird'     );            
INSERT INTO Species (species , animalGroup) VALUES ('Gerbillus sp.'             , 'Reptile'  );            
INSERT INTO Species (species , animalGroup) VALUES ('Tenrec ecaudatus'          , 'Reptile'  );            
INSERT INTO Species (species , animalGroup) VALUES ('Macropus rufogriseus'      , 'Reptile'  );            
INSERT INTO Species (species , animalGroup) VALUES ('Dendrocitta vagabunda'     , 'Reptile'  );         
INSERT INTO Species (species , animalGroup) VALUES ('Tragelaphus strepsiceros'  , 'Amphibian');         
INSERT INTO Species (species , animalGroup) VALUES ('Geococcyx californianus'   , 'Amphibian');         
INSERT INTO Species (species , animalGroup) VALUES ('Trichosurus vulpecula'     , 'Amphibian');         
INSERT INTO Species (species , animalGroup) VALUES ('Panthera pardus'           , 'Amphibian');         

-- Breeds
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (1  , 'Grizzly bear'                , 'Bear'                      , 'Peritoneal abscess'       , 'Vulnerable');              
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (2  , 'Jackal, indian'              , 'Canidae'                   , 'Dislocation sternum-open' , 'Vulnerable');              
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (3  , 'American alligator'          , 'Alligatoridae'             , 'Hit by train-employee'    , 'Vulnerable');              
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (4  , 'Indian elephant'             , 'Elephantidae'              , 'Anal sphincter tear-del'  , 'Vulnerable');              
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (5  , 'Monkey, red howler'          , 'Alouatta seniculus'        , 'Pulmon circulat dis NOS'  , 'Vulnerable');              
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (6  , 'Cougar'                      , 'Felis concolor'            , 'Vertigo'                  , 'Vulnerable');              
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (7  , 'Racer, blue'                 , 'Coluber constrictor foxii' , 'Blood inf dt cen ven cth' , 'Vulnerable');              
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (8  , 'Pacific gull'                , 'Gabianus pacificus'        , 'Neonat jaund in oth dis'  , 'Endangered');              
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (9  , 'Toucan, white-throated'      , 'Ramphastidae'              , 'Postabortion gu infect'   , 'Endangered');              
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (10 , 'Lilac-breasted roller'       , 'Coracias caudata'          , 'Causalgia lower limb'     , 'Endangered');              
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (11 , 'Dove, rock'                  , 'Columba livia'             , 'Pulmon TB NOS-micro dx'   , 'Endangered');              
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (12 , 'Cat, ringtail'               , 'Bassariscus astutus'       , 'War injury:bullet NEC'    , 'Last Concern');            
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (13 , 'Gerbil (unidentified)'       , 'Gerbillus sp.'             , 'Fam hx genet dis carrier' , 'Last Concern');            
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (14 , 'Tailless tenrec'             , 'Tenrec ecaudatus'          , 'Food/vomit pneumonitis'   , 'Last Concern');            
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (15 , 'Wallaby, bennett''s'         , 'Macropus rufogriseus'      , 'Complic labor NOS-deliv'  , 'Last Concern');            
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (16 , 'Pie, rufous tree'            , 'Dendrocitta vagabunda'     , 'Inj mult thoracic vessel' , 'Near Threatened');         
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (17 , 'Greater kudu'                , 'Tragelaphus strepsiceros'  , 'Comb deg cord in oth dis' , 'Near Threatened');         
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (18 , 'Greater roadrunner'          , 'Geococcyx californianus'   , 'Joint symptom NEC-oth jt' , 'Near Threatened');         
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (19 , 'Possum, golden brush-tailed' , 'Trichosurus vulpecula'     , 'Mal neo ureteric orifice' , 'Near Threatened');         
INSERT INTO Breeds (breedID , breed , species , facts , status) VALUES (20 , 'Indian leopard'              , 'Panthera pardus'           , 'Integument tiss symp NEC' , 'Near Threatened');

-- Animals
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (1  , 'Fredelia'   , 1  , 1 , (TO_DATE('2001-10-24'  , 'yyyy/mm/dd HH24:MI')) , 'U'  , 11  , 318 , (TO_DATE('2007-01-05'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (2  , 'Tommy'      , 2  , 2 , (TO_DATE('2003-12-19'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 13  , 472 , (TO_DATE('2001-02-06'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (3  , 'Mattie'     , 3  , 3 , (TO_DATE('2002-09-26'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 70  , 466 , (TO_DATE('2001-11-30'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (4  , 'Stavro'     , 4  , 4 , (TO_DATE('2008-01-08'  , 'yyyy/mm/dd HH24:MI')) , 'U'  , 28  , 42  , (TO_DATE('2001-02-02'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (5  , 'Adelbert'   , 5  , 5 , (TO_DATE('2001-02-23'  , 'yyyy/mm/dd HH24:MI')) , 'M'  , 97  , 352 , (TO_DATE('2007-04-20'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (6  , 'Rochell'    , 6  , 6 , (TO_DATE('2002-03-12'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 8   , 352 , (TO_DATE('2004-12-27'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (7  , 'Odette'     , 7  , 7 , (TO_DATE('2002-09-15'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 17  , 290 , (TO_DATE('2004-04-19'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (8  , 'Tybalt'     , 8  , 8 , (TO_DATE('2005-07-18'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 14  , 223 , (TO_DATE('2002-01-21'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (9  , 'Iris'       , 9  , 8 , (TO_DATE('2009-05-05'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 76  , 434 , (TO_DATE('2001-10-05'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (10 , 'Shepperd'   , 10 , 1 , (TO_DATE('2001-06-07'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 16  , 123 , (TO_DATE('2002-08-04'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (11 , 'Baxter'     , 1  , 2 , (TO_DATE('2001-09-11'  , 'yyyy/mm/dd HH24:MI')) , 'M'  , 18  , 21  , (TO_DATE('2003-10-14'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (12 , 'Daron'      , 2  , 3 , (TO_DATE('2002-11-12'  , 'yyyy/mm/dd HH24:MI')) , 'M'  , 28  , 411 , (TO_DATE('2004-03-29'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (13 , 'Maggy'      , 3  , 4 , (TO_DATE('2007-02-24'  , 'yyyy/mm/dd HH24:MI')) , 'M'  , 21  , 460 , (TO_DATE('2008-10-05'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (14 , 'Regen'      , 4  , 5 , (TO_DATE('2005-11-10'  , 'yyyy/mm/dd HH24:MI')) , 'M'  , 71  , 496 , (TO_DATE('2001-09-11'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (15 , 'Mathias'    , 5  , 6 , (TO_DATE('2007-04-28'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 77  , 479 , (TO_DATE('2005-05-29'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (16 , 'Gusella'    , 6  , 7 , (TO_DATE('2003-02-09'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 78  , 331 , (TO_DATE('2006-09-12'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (17 , 'Corinne'    , 7  , 8 , (TO_DATE('2010-05-18'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 91  , 237 , (TO_DATE('2002-02-05'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (18 , 'Dulcy'      , 8  , 8 , (TO_DATE('2009-04-20'  , 'yyyy/mm/dd HH24:MI')) , 'U'  , 75  , 454 , (TO_DATE('2001-10-02'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (19 , 'Alexandros' , 9  , 1 , (TO_DATE('2003-11-23'  , 'yyyy/mm/dd HH24:MI')) , 'M'  , 48  , 440 , (TO_DATE('2005-08-05'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (20 , 'Hamlen'     , 10 , 2 , (TO_DATE('2005-02-23'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 50  , 386 , (TO_DATE('2010-02-09'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (21 , 'Janis'      , 1  , 3 , (TO_DATE('2009-01-09'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 32  , 281 , (TO_DATE('2001-03-03'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (22 , 'Dora'       , 2  , 4 , (TO_DATE('2006-11-18'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 41  , 14  , (TO_DATE('2009-07-11'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (23 , 'Gran'       , 3  , 5 , (TO_DATE('2001-08-30'  , 'yyyy/mm/dd HH24:MI')) , 'M'  , 33  , 213 , (TO_DATE('2003-03-05'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (24 , 'Charo'      , 4  , 6 , (TO_DATE('2010-04-09'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 61  , 385 , (TO_DATE('2009-03-27'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (25 , 'Arvie'      , 5  , 7 , (TO_DATE('2006-11-01'  , 'yyyy/mm/dd HH24:MI')) , 'U'  , 70  , 158 , (TO_DATE('2004-08-04'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (26 , 'Rochette'   , 6  , 8 , (TO_DATE('2000-05-08'  , 'yyyy/mm/dd HH24:MI')) , 'M'  , 34  , 423 , (TO_DATE('2010-09-01'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (27 , 'Corina'     , 7  , 2 , (TO_DATE('2001-11-13'  , 'yyyy/mm/dd HH24:MI')) , 'M'  , 58  , 266 , (TO_DATE('2009-11-27'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (28 , 'Worthy'     , 8  , 1 , (TO_DATE('2006-02-28'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 18  , 230 , (TO_DATE('2001-05-11'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (29 , 'Kirby'      , 9  , 2 , (TO_DATE('2009-08-25'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 39  , 166 , (TO_DATE('2010-08-02'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (30 , 'Lilith'     , 10 , 3 , (TO_DATE('2003-09-07'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 22  , 386 , (TO_DATE('2003-06-30'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (31 , 'Georgeanna' , 1  , 4 , (TO_DATE('2006-09-23'  , 'yyyy/mm/dd HH24:MI')) , 'M'  , 20  , 434 , (TO_DATE('2005-08-05'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (32 , 'Giles'      , 2  , 5 , (TO_DATE('2001-02-05'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 4   , 154 , (TO_DATE('2005-06-21'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (33 , 'Margie'     , 3  , 6 , (TO_DATE('2001-11-06'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 100 , 194 , (TO_DATE('2000-10-18'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (34 , 'Percival'   , 4  , 7 , (TO_DATE('2009-10-02'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 46  , 385 , (TO_DATE('2010-09-23'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (35 , 'Emili'      , 5  , 8 , (TO_DATE('2009-08-23'  , 'yyyy/mm/dd HH24:MI')) , 'U'  , 15  , 65  , (TO_DATE('2000-12-20'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (36 , 'Purcell'    , 6  , 3 , (TO_DATE('2006-11-30'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 20  , 332 , (TO_DATE('2002-03-23'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (37 , 'Wesley'     , 7  , 1 , (TO_DATE('2010-07-10'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 84  , 293 , (TO_DATE('2006-11-16'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (38 , 'Sayre'      , 8  , 2 , (TO_DATE('2006-11-01'  , 'yyyy/mm/dd HH24:MI')) , 'U'  , 60  , 466 , (TO_DATE('2000-10-31'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (39 , 'Marissa'    , 9  , 3 , (TO_DATE('2009-06-01'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 38  , 496 , (TO_DATE('2007-04-21'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (40 , 'Humbert'    , 10 , 4 , (TO_DATE('2008-05-05'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 47  , 299 , (TO_DATE('2005-06-17'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (41 , 'Salomone'   , 1  , 5 , (TO_DATE('2004-11-25'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 13  , 200 , (TO_DATE('2000-09-05'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (42 , 'Xenia'      , 2  , 6 , (TO_DATE('2008-11-20'  , 'yyyy/mm/dd HH24:MI')) , 'M'  , 87  , 74  , (TO_DATE('2004-11-13'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (43 , 'Teodoor'    , 3  , 7 , (TO_DATE('2005-05-12'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 39  , 183 , (TO_DATE('2006-10-22'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (44 , 'Jerome'     , 4  , 8 , (TO_DATE('2007-08-06'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 85  , 153 , (TO_DATE('2001-02-11'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (45 , 'Arline'     , 5  , 4 , (TO_DATE('2000-02-06'  , 'yyyy/mm/dd HH24:MI')) , 'U'  , 25  , 370 , (TO_DATE('2003-11-09'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (46 , 'Ann-marie'  , 6  , 1 , (TO_DATE('2008-11-24'  , 'yyyy/mm/dd HH24:MI')) , 'NA' , 60  , 52  , (TO_DATE('2000-01-19'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (47 , 'Celestine'  , 7  , 2 , (TO_DATE('2010-05-15'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 63  , 178 , (TO_DATE('2005-09-12'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (48 , 'Staford'    , 8  , 3 , (TO_DATE('2001-07-26'  , 'yyyy/mm/dd HH24:MI')) , 'U'  , 83  , 128 , (TO_DATE('2010-06-16'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (49 , 'Tobit'      , 9  , 4 , (TO_DATE('2000-12-08'  , 'yyyy/mm/dd HH24:MI')) , 'U'  , 31  , 51  , (TO_DATE('2004-09-30'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 
INSERT INTO Animals (animalID , name , breedID , enclosureID , birthDate , sex , age , weight , arrivalDate , deceasedDate , bioData) VALUES (50 , 'Archy'      , 10 , 5 , (TO_DATE('2004-10-30'  , 'yyyy/mm/dd HH24:MI')) , 'F'  , 5   , 6   , (TO_DATE('2004-05-23'  , 'yyyy/mm/dd HH24:MI')) , NULL , NULL); 

-- ParentOf
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (36 , 4);  
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (13 , 8);  
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (46 , 33); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (11 , 22); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (13 , 46); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (41 , 6);  
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (37 , 29); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (11 , 49); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (31 , 32); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (30 , 25); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (45 , 10); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (1  , 18); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (18 , 9);  
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (30 , 9);  
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (49 , 8);  
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (9  , 35); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (13 , 41); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (31 , 13); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (36 , 50); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (24 , 31); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (9  , 13); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (49 , 33); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (26 , 4);  
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (12 , 18); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (35 , 18); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (34 , 3);  
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (24 , 26); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (3  , 46); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (44 , 10); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (3  , 4);  
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (38 , 34); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (33 , 29); 
INSERT INTO ParentOf (parent_animalID , child_animalID) VALUES (13 , 10); 

-- Employees
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(1  , '18853 41st Ave, Vancouver B.C'         , 'Benjamin' , 'Kowalewicz'  , 'benk33@gmail.com'             , '778-996-3324' , 333908767  , (TO_DATE('1979-02-01'  , 'yyyy/mm/dd')));
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(2  , '14456 Acorn Rd., Langley B.C'          , 'Ian'      , 'Dsa'         , 'iandsa@hotmail.com'           , '604-333-1212' , 333444555  , (TO_DATE('1965-03-11'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(3  , '5555 Fern St., Burnaby B.C'            , 'Aaron'    , 'Solowoniuk'  , 'aaronsolowoniuk@gmail.com'    , '778-090-2323' , 767676799  , (TO_DATE('2000-08-14'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(4  , '4661 HollyBerry Rd., Richmond, B.C'    , 'Jonathan' , 'Gallant'     , 'jonnygee222@gmail.com'        , '778-999-5533' , 876456333  , (TO_DATE('1935-07-19'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(5  , '4546 Alexis St., Richmond, B.C'        , 'Jordan'   , 'Hastings'    , 'jhastings23@gmail.com'        , '778-665-8778' , 199298090  , (TO_DATE('1992-11-13'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(6  , '18853 55A Ave., Surrey B.C'            , 'Jessica'  , 'Bator'       , 'jkbator333@gmail.com'         , '778-994-2633' , 197690900  , (TO_DATE('1960-05-19'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(7  , '18894 50th Ave,. Surrey, B.C'          , 'Sara'     , 'Marshall'    , 'saramarshall@student.ubc.ca'  , '778-558-8212' , 197788769  , (TO_DATE('1996-02-03'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(8  , '8494 Pecan St., Vancouver B.C'         , 'Zahra'    , 'Raza'        , 'zahraza@gmail.com'            , '780-881-4131' , 197842425  , (TO_DATE('1993-09-30'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(9  , '18852 52nd Ave., Surrey, B.C'          , 'Alex'     , 'Hawk'        , 'alexhawk@student.ubc.ca'      , '778-847-1469' , 197962350  , (TO_DATE('1993-04-13'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(10 , '18859 55A ave., Surrey, B.C'           , 'Kelly'    , 'Ye'          , 'agoddexx@hotmail.com'         , '778-909-8787' , 198083235  , (TO_DATE('1983-03-16'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(11 , '6545 60th Ave., Surrey, B.C'           , 'Faye'     , 'Marwick'     , 'faye.ay@gmail.com'            , '778-666-2241' , 198165455  , (TO_DATE('1972-04-22'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(12 , '7992 Tribia Lane., Coquitlam, B.C'     , 'John'     , 'Frusciante'  , 'jfguitar@gmail.com'           , '604-789-9494' , 199102020  , (TO_DATE('1968-05-18'  , 'yyyy/mm/dd')));   
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(13 , '6969 Purple St., Vancouver, B.C'       , 'Flea'     , 'Aelf'        , 'fleab@gmail.com'              , '604-574-4577' , 199188887  , (TO_DATE('1960-04-13'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(14 , '7676 Venice St., Langley, B.C'         , 'Chad'     , 'Smith'       , 'thechadsmith@gmail.com'       , '604-989-4576' , 199140404  , (TO_DATE('1952-01-15'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(15 , '19984  California Rd., Vancouver, B.C' , 'Anthony'  , 'Kiedis'      , 'akiedis6969@gmail.com'        , '604-737-4203' , 199133226  , (TO_DATE('1993-01-06'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(16 , '7999 Tribia Lane., Coquitlam, B.C'     , 'Josh'     , 'Klinghoffer' , 'jkling55@gmail.com'           , '778-002-3242' , 199109090  , (TO_DATE('1999-08-20'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(17 , '12001 Sad St., Burnaby, B.C'           , 'Thom'     , 'Yorke'       , 'tyorkeradio@outlook.com'      , '604-604-0000' , 199300120  , (TO_DATE('1989-09-01'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(18 , '7878 Skater St., Surrey, B.C'          , 'Avril'    , 'Lavigne'     , 'avrilavigne@hotmail.com'      , '778-778-7777' , 199412312  , (TO_DATE('1945-03-08'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(19 , '5564 Fever Rd., Surrey, B.C'           , 'Jason'    , 'Butler'      , 'jasonaalonbutler42@gmail.com' , '778-020-3411' , 199509134  , (TO_DATE('1941-07-15'  , 'yyyy/mm/dd')));  
INSERT INTO Employees(employeeID, address , firstName , lastName , email , phoneNumber , sin , birthDate) VALUES(20 , '10098 English Rd., Langley, B.C'       , 'Damon'    , 'Albarn'      , 'damonboy@outlook.com'         , '984-009-2727' , 199612300  , (TO_DATE('1986-10-11'  , 'yyyy/mm/dd')));  

-- Feeders
INSERT INTO Feeders(employeeID) VALUES(1); 
INSERT INTO Feeders(employeeID) VALUES(2); 
INSERT INTO Feeders(employeeID) VALUES(3); 
INSERT INTO Feeders(employeeID) VALUES(4); 
INSERT INTO Feeders(employeeID) VALUES(5); 

-- Trainers
INSERT INTO Trainers(employeeID) VALUES(6); 
INSERT INTO Trainers(employeeID) VALUES(7); 
INSERT INTO Trainers(employeeID) VALUES(8); 
INSERT INTO Trainers(employeeID) VALUES(9); 
INSERT INTO Trainers(employeeID) VALUES(10); 

-- Keepers
INSERT INTO Keepers(employeeId) VALUES(11); 
INSERT INTO Keepers(employeeId) VALUES(12); 
INSERT INTO Keepers(employeeId) VALUES(13); 
INSERT INTO Keepers(employeeId) VALUES(14); 
INSERT INTO Keepers(employeeId) VALUES(15);

INSERT INTO Veterinarians(employeeId) VALUES(16); 
INSERT INTO Veterinarians(employeeId) VALUES(17); 
INSERT INTO Veterinarians(employeeId) VALUES(18); 
INSERT INTO Veterinarians(employeeId) VALUES(19); 
INSERT INTO Veterinarians(employeeId) VALUES(20); 

-- FoodSupplies
INSERT INTO FoodSupplies(supplyID ,name ,expiryDate ,quantity ,unit) VALUES(1 , 'Peanuts'  , (TO_DATE('2025/01/01' , 'yyyy/mm/dd')) , 100  , 'grams');  
INSERT INTO FoodSupplies(supplyID ,name ,expiryDate ,quantity ,unit) VALUES(2 , 'Beef'     , (TO_DATE('2022/05/03' , 'yyyy/mm/dd')) , 1000 , 'pounds'); 
INSERT INTO FoodSupplies(supplyID ,name ,expiryDate ,quantity ,unit) VALUES(3 , 'Milk'     , (TO_DATE('2021/12/31' , 'yyyy/mm/dd')) , 50   , 'litres'); 
INSERT INTO FoodSupplies(supplyID ,name ,expiryDate ,quantity ,unit) VALUES(4 , 'Eggs'     , (TO_DATE('2021/11/20' , 'yyyy/mm/dd')) , 200  , 'eggs');   
INSERT INTO FoodSupplies(supplyID ,name ,expiryDate ,quantity ,unit) VALUES(5 , 'Sardines' , (TO_DATE('2022/02/17' , 'yyyy/mm/dd')) , 1000 , 'grams');  

-- FeedingSchedules
-- Feeder 1, Animal 1, Keeper 12
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(1 , 1 , 12 , (TO_DATE('2021/12/31 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(1 , 1 , 12 , (TO_DATE('2021/10/25 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(1 , 1 , 12 , (TO_DATE('2021/10/25 12:30' , 'yyyy/mm/dd HH24:MI')));  
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(1 , 1 , 12 , (TO_DATE('2021/10/25 18:30' , 'yyyy/mm/dd HH24:MI')));  
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(1 , 1 , 12 , (TO_DATE('2021/11/26 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(1 , 1 , 12 , (TO_DATE('2021/12/06 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(1 , 1 , 12 , (TO_DATE('2021/12/07 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(1 , 1 , 12 , (TO_DATE('2021/12/11 13:30' , 'yyyy/mm/dd HH24:MI')));  
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(1 , 1 , 12 , (TO_DATE('2021/12/11 20:30' , 'yyyy/mm/dd HH24:MI')));  
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(1 , 1 , 12 , (TO_DATE('2021/12/12 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(1 , 1 , 12 , (TO_DATE('2021/12/21 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
-- Feeder 2, Animal 2, Keeper 12
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(2 , 2 , 13 , (TO_DATE('2021/12/31 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(2 , 2 , 13 , (TO_DATE('2021/10/25 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(2 , 2 , 13 , (TO_DATE('2021/10/25 12:30' , 'yyyy/mm/dd HH24:MI')));  
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(2 , 2 , 13 , (TO_DATE('2021/10/25 18:30' , 'yyyy/mm/dd HH24:MI')));  
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(2 , 2 , 13 , (TO_DATE('2021/11/26 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(2 , 2 , 13 , (TO_DATE('2021/12/06 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(2 , 2 , 13 , (TO_DATE('2021/12/07 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(2 , 2 , 13 , (TO_DATE('2021/12/11 13:30' , 'yyyy/mm/dd HH24:MI')));  
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(2 , 2 , 13 , (TO_DATE('2021/12/11 20:30' , 'yyyy/mm/dd HH24:MI')));  
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(2 , 2 , 13 , (TO_DATE('2021/12/12 7:30'  , 'yyyy/mm/dd HH24:MI'))); 
INSERT INTO FeedingSchedules(feederID ,animalID ,keeperID ,dateTime) VALUES(2 , 2 , 13 , (TO_DATE('2021/12/21 7:30'  , 'yyyy/mm/dd HH24:MI'))); 

-- MadeUpOf
-- Feeder 1, Animal 1
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(1 , 1 , 1 , (TO_DATE('2021/12/31 7:30'  , 'yyyy/mm/dd HH24:MI')) , 45); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(2 , 1 , 1 , (TO_DATE('2021/10/25 7:30'  , 'yyyy/mm/dd HH24:MI')) , 46); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(3 , 1 , 1 , (TO_DATE('2021/10/25 12:30' , 'yyyy/mm/dd HH24:MI')) , 83);  
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(4 , 1 , 1 , (TO_DATE('2021/10/25 18:30' , 'yyyy/mm/dd HH24:MI')) , 65);  
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(5 , 1 , 1 , (TO_DATE('2021/11/26 7:30'  , 'yyyy/mm/dd HH24:MI')) , 57); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(1 , 1 , 1 , (TO_DATE('2021/12/06 7:30'  , 'yyyy/mm/dd HH24:MI')) , 50); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(2 , 1 , 1 , (TO_DATE('2021/12/07 7:30'  , 'yyyy/mm/dd HH24:MI')) , 59); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(3 , 1 , 1 , (TO_DATE('2021/12/11 13:30' , 'yyyy/mm/dd HH24:MI')) , 93);  
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(4 , 1 , 1 , (TO_DATE('2021/12/11 20:30' , 'yyyy/mm/dd HH24:MI')) , 16);  
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(5 , 1 , 1 , (TO_DATE('2021/12/12 7:30'  , 'yyyy/mm/dd HH24:MI')) , 20); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(5 , 1 , 1 , (TO_DATE('2021/12/21 7:30'  , 'yyyy/mm/dd HH24:MI')) ,  9); 
-- Feeder 2, Animal 2
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(1 , 2 , 2 , (TO_DATE('2021/12/31 7:30'  , 'yyyy/mm/dd HH24:MI')) , 26); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(2 , 2 , 2 , (TO_DATE('2021/10/25 7:30'  , 'yyyy/mm/dd HH24:MI')) , 32); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(3 , 2 , 2 , (TO_DATE('2021/10/25 12:30' , 'yyyy/mm/dd HH24:MI')) , 97);  
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(4 , 2 , 2 , (TO_DATE('2021/10/25 18:30' , 'yyyy/mm/dd HH24:MI')) , 69);  
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(5 , 2 , 2 , (TO_DATE('2021/11/26 7:30'  , 'yyyy/mm/dd HH24:MI')) , 23); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(1 , 2 , 2 , (TO_DATE('2021/12/06 7:30'  , 'yyyy/mm/dd HH24:MI')) , 45); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(2 , 2 , 2 , (TO_DATE('2021/12/07 7:30'  , 'yyyy/mm/dd HH24:MI')) , 70); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(3 , 2 , 2 , (TO_DATE('2021/12/11 13:30' , 'yyyy/mm/dd HH24:MI')) , 70);  
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(4 , 2 , 2 , (TO_DATE('2021/12/11 20:30' , 'yyyy/mm/dd HH24:MI')) , 28);  
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(5 , 2 , 2 , (TO_DATE('2021/12/12 7:30'  , 'yyyy/mm/dd HH24:MI')) , 94); 
INSERT INTO MadeUpOf(supplyID ,feederID ,animalID ,dateTime ,amount) VALUES(1 , 2 , 2 , (TO_DATE('2021/12/21 7:30'  , 'yyyy/mm/dd HH24:MI')) , 68);

-- Feed
INSERT INTO Feed(feederID ,animalID) VALUES(1 ,1); 
INSERT INTO Feed(feederID ,animalID) VALUES(2 ,1); 
INSERT INTO Feed(feederID ,animalID) VALUES(3 ,1); 
INSERT INTO Feed(feederID ,animalID) VALUES(4 ,2); 
INSERT INTO Feed(feederID ,animalID) VALUES(5 ,3); 
INSERT INTO Feed(feederID ,animalID) VALUES(5 ,4); 
INSERT INTO Feed(feederID ,animalID) VALUES(5 ,5); 

-- Visitors
-- Credits to https://www.mockaroo.com/
INSERT INTO Visitors (visitorID , firstName , lastName , birthDate , address , phoneNumber , email) VALUES (1  , 'Roldan'   , 'Duncanson'  , (TO_DATE('2019/01/21' , 'yyyy/mm/dd')) , '0 Southridge Road'     , '556-225-6688' , 'rduncanson0@etsy.com');        
INSERT INTO Visitors (visitorID , firstName , lastName , birthDate , address , phoneNumber , email) VALUES (2  , 'Lucia'    , 'Pemberton'  , (TO_DATE('2019/09/08' , 'yyyy/mm/dd')) , '6395 Grasskamp Street' , '613-960-9945' , 'lpemberton1@fastcompany.com'); 
INSERT INTO Visitors (visitorID , firstName , lastName , birthDate , address , phoneNumber , email) VALUES (3  , 'Erwin'    , 'Stobbie'    , (TO_DATE('2020/11/03' , 'yyyy/mm/dd')) , '89093 Talmadge Park'   , '821-450-0208' , 'estobbie2@state.tx.us');       
INSERT INTO Visitors (visitorID , firstName , lastName , birthDate , address , phoneNumber , email) VALUES (4  , 'Rebekkah' , 'Sharrocks'  , (TO_DATE('2019/08/14' , 'yyyy/mm/dd')) , '0 Transport Parkway'   , '440-498-9144' , 'rsharrocks3@psu.edu');         
INSERT INTO Visitors (visitorID , firstName , lastName , birthDate , address , phoneNumber , email) VALUES (5  , 'Elsie'    , 'Dannohl'    , (TO_DATE('2020/01/24' , 'yyyy/mm/dd')) , '6140 Anderson Avenue'  , '788-183-8308' , 'edannohl4@discuz.net');        
INSERT INTO Visitors (visitorID , firstName , lastName , birthDate , address , phoneNumber , email) VALUES (6  , 'Chaunce'  , 'Nicholas'   , (TO_DATE('2019/12/28' , 'yyyy/mm/dd')) , '70 Maywood Parkway'    , '699-172-3209' , 'cnicholas5@whitehouse.gov');   
INSERT INTO Visitors (visitorID , firstName , lastName , birthDate , address , phoneNumber , email) VALUES (7  , 'Zonda'    , 'Ruddiforth' , (TO_DATE('2018/05/21' , 'yyyy/mm/dd')) , '24094 Canary Pass'     , '724-737-3986' , 'zruddiforth6@gizmodo.com');    
INSERT INTO Visitors (visitorID , firstName , lastName , birthDate , address , phoneNumber , email) VALUES (8  , 'Edmon'    , 'Osbidston'  , (TO_DATE('2021/01/09' , 'yyyy/mm/dd')) , '83 Duke Alley'         , '792-532-8820' , 'eosbidston7@ihg.com');         
INSERT INTO Visitors (visitorID , firstName , lastName , birthDate , address , phoneNumber , email) VALUES (9  , 'Cozmo'    , 'Snowling'   , (TO_DATE('2020/01/02' , 'yyyy/mm/dd')) , '05 Summit Way'         , '337-796-3645' , 'csnowling8@freewebs.com');     
INSERT INTO Visitors (visitorID , firstName , lastName , birthDate , address , phoneNumber , email) VALUES (10 , 'Elisha'   , 'Goor'       , (TO_DATE('2018/01/15' , 'yyyy/mm/dd')) , '7909 Manitowish Court' , '298-325-3587' , 'egoor9@goodreads.com');        

-- VisitorRecords
INSERT INTO VisitorRecords (recordID , visitorID , visitDate) VALUES (1  , 1  , (TO_DATE('2018/03/25' , 'yyyy/mm/dd'))); 
INSERT INTO VisitorRecords (recordID , visitorID , visitDate) VALUES (2  , 2  , (TO_DATE('2013/06/07' , 'yyyy/mm/dd'))); 
INSERT INTO VisitorRecords (recordID , visitorID , visitDate) VALUES (3  , 3  , (TO_DATE('2020/05/18' , 'yyyy/mm/dd'))); 
INSERT INTO VisitorRecords (recordID , visitorID , visitDate) VALUES (4  , 4  , (TO_DATE('2013/08/03' , 'yyyy/mm/dd'))); 
INSERT INTO VisitorRecords (recordID , visitorID , visitDate) VALUES (5  , 5  , (TO_DATE('2010/03/23' , 'yyyy/mm/dd'))); 
INSERT INTO VisitorRecords (recordID , visitorID , visitDate) VALUES (6  , 6  , (TO_DATE('2011/08/26' , 'yyyy/mm/dd'))); 
INSERT INTO VisitorRecords (recordID , visitorID , visitDate) VALUES (7  , 7  , (TO_DATE('2002/01/04' , 'yyyy/mm/dd'))); 
INSERT INTO VisitorRecords (recordID , visitorID , visitDate) VALUES (8  , 8  , (TO_DATE('2017/11/03' , 'yyyy/mm/dd'))); 
INSERT INTO VisitorRecords (recordID , visitorID , visitDate) VALUES (9  , 9  , (TO_DATE('2012/10/09' , 'yyyy/mm/dd'))); 
INSERT INTO VisitorRecords (recordID , visitorID , visitDate) VALUES (10 , 10 , (TO_DATE('2010/09/08' , 'yyyy/mm/dd'))); 

-- Events
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (1  , 1 , 42 , 'Dolphin show where tricks are guided by a trainer'                                                                              , 'The Greatest Dolphin Show'                   , (TO_DATE ('2021-10-28 00:50' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-10-28 03:25' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (2  , 1 , 27 , 'Free guided tour with lion specialist'                                                                                          , 'Lion-centric Tour'                           , (TO_DATE ('2021-07-19 22:40' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-07-20 00:53' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (3  , 1 , 76 , 'Small, farm-like animals are brought together and visitors are allowed to pet them'                                             , 'Petting Zoo Day'                             , (TO_DATE ('2021-05-12 10:48' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-05-12 11:22' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (4  , 1 , 26 , 'Insect specialist does an interactive event with insects with big screen'                                                       , 'An Interesting Insect Analysis'              , (TO_DATE ('2021-06-23 09:50' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-06-23 10:59' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (5  , 2 , 54 , 'Night-time light show at fish + whale enclosure'                                                                                , 'Glow in the Dark @ The Whale + Fish Exhibit' , (TO_DATE ('2021-10-24 15:45' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-10-24 17:08' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (6  , 2 , 63 , 'Marine biologist comes in to answer any questions visitors and aspiring marine biolgists have about the job and/or the animals' , 'Ask a Marine Biolgist'                       , (TO_DATE ('2021-05-12 05:10' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-05-12 07:00' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (7  , 2 , 94 , 'Visitors see if they can outroar a lion for a prize'                                                                            , 'Can you out-ROAR a lion?'                    , (TO_DATE ('2021-04-17 01:39' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-04-17 04:17' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (8  , 2 , 28 , 'Small animals ar brought into same enclosure and trainer does tricks with some of them'                                         , 'Small Animals are cool too!'                 , (TO_DATE ('2021-05-24 02:03' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-05-24 04:18' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (9  , 3 , 52 , 'Visitors are allowed to touch certain bugs under supervision from trainer'                                                      , 'Touch and Insect Day'                        , (TO_DATE ('2020-12-02 04:29' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2020-12-02 06:20' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (10 , 3 , 53 , 'Trainers prompt whales to splash as much as they can'                                                                           , 'Splash Zone'                                 , (TO_DATE ('2021-11-12 22:33' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-11-12 23:08' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (11 , 3 , 42 , 'Dolphin show where tricks are guided by a trainer'                                                                              , 'The Greatest Dolphin Show'                   , (TO_DATE ('2021-08-30 07:08' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-08-30 08:09' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (12 , 3 , 27 , 'Free guided tour with lion specialist'                                                                                          , 'Lion-centric Tour'                           , (TO_DATE ('2021-06-09 19:34' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-06-09 21:04' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (13 , 4 , 76 , 'Small, farm-like animals are brought together and visitors are allowed to pet them'                                             , 'Petting Zoo Day'                             , (TO_DATE ('2021-07-06 07:48' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-07-06 09:24' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (14 , 4 , 26 , 'Insect specialist does an interactive event with insects with big screen'                                                       , 'An Interesting Insect Analysis'              , (TO_DATE ('2021-08-29 03:55' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-08-29 05:03' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (15 , 4 , 54 , 'Night-time light show at fish + whale enclosure'                                                                                , 'Glow in the Dark @ The Whale + Fish Exhibit' , (TO_DATE ('2021-03-23 00:16' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-03-23 02:15' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (16 , 4 , 63 , 'Marine biologist comes in to answer any questions visitors and aspiring marine biolgists have about the job and/or the animals' , 'Ask a Marine Biolgist'                       , (TO_DATE ('2021-07-17 02:10' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-07-17 03:36' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (17 , 5 , 94 , 'Visitors see if they can outroar a lion for a prize'                                                                            , 'Can you out-ROAR a lion?'                    , (TO_DATE ('2020-12-06 00:41' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2020-12-06 02:44' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (18 , 5 , 28 , 'Small animals ar brought into same enclosure and trainer does tricks with some of them'                                         , 'Small Animals are cool too!'                 , (TO_DATE ('2021-01-07 22:34' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-01-07 23:20' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (19 , 5 , 52 , 'Visitors are allowed to touch certain bugs under supervision from trainer'                                                      , 'Touch and Insect Day'                        , (TO_DATE ('2021-08-28 19:44' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-08-28 20:40' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (20 , 5 , 53 , 'Trainers prompt whales to splash as much as they can'                                                                           , 'Splash Zone'                                 , (TO_DATE ('2021-01-17 14:09' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-01-17 14:48' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (21 , 6 , 42 , 'Dolphin show where tricks are guided by a trainer'                                                                              , 'The Greatest Dolphin Show'                   , (TO_DATE ('2021-01-01 16:54' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-01-01 19:30' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (22 , 6 , 27 , 'Free guided tour with lion specialist'                                                                                          , 'Lion-centric Tour'                           , (TO_DATE ('2021-01-25 08:04' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-01-25 08:36' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (23 , 6 , 76 , 'Small, farm-like animals are brought together and visitors are allowed to pet them'                                             , 'Petting Zoo Day'                             , (TO_DATE ('2021-10-11 02:40' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-10-11 03:37' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (24 , 6 , 26 , 'Insect specialist does an interactive event with insects with big screen'                                                       , 'An Interesting Insect Analysis'              , (TO_DATE ('2021-02-26 09:00' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-02-26 09:37' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (25 , 7 , 54 , 'Night-time light show at fish + whale enclosure'                                                                                , 'Glow in the Dark @ The Whale + Fish Exhibit' , (TO_DATE ('2021-10-10 23:22' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-10-11 01:38' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (26 , 7 , 63 , 'Marine biologist comes in to answer any questions visitors and aspiring marine biolgists have about the job and/or the animals' , 'Ask a Marine Biolgist'                       , (TO_DATE ('2021-01-03 09:57' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-01-03 10:36' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (27 , 7 , 94 , 'Visitors see if they can outroar a lion for a prize'                                                                            , 'Can you out-ROAR a lion?'                    , (TO_DATE ('2021-09-20 22:28' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-09-21 01:01' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (28 , 7 , 28 , 'Small animals ar brought into same enclosure and trainer does tricks with some of them'                                         , 'Small Animals are cool too!'                 , (TO_DATE ('2021-05-14 23:14' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-05-15 00:05' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (29 , 8 , 52 , 'Visitors are allowed to touch certain bugs under supervision from trainer'                                                      , 'Touch and Insect Day'                        , (TO_DATE ('2021-11-09 21:32' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-11-09 22:59' , 'YYYY-MM-DD HH24:MI')));  
INSERT INTO Events (eventID , enclosureID , capacity , description , name , startTime , endTime) VALUES (30 , 8 , 53 , 'Trainers prompt whales to splash as much as they can'                                                                           , 'Splash Zone'                                 , (TO_DATE ('2021-03-26 14:22' , 'YYYY-MM-DD HH24:MI')) , (TO_DATE ('2021-03-26 16:21' , 'YYYY-MM-DD HH24:MI')));  

-- Reserve
INSERT INTO Reserve (eventID , visitorID) VALUES (1 , 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (2 , 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (3 , 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (4 , 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (5 , 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (6 , 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (7 , 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (8 , 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (9 , 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (10, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (11, 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (12, 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (13, 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (14, 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (15, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (16, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (17, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (18, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (19, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (20, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (21, 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (22, 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (23, 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (24, 1); 
INSERT INTO Reserve (eventID , visitorID) VALUES (25, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (26, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (27, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (28, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (29, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (30, 1);
INSERT INTO Reserve (eventID , visitorID) VALUES (1 , 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (2 , 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (3 , 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (4 , 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (5 , 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (6 , 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (7 , 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (8 , 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (9 , 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (10, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (11, 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (12, 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (13, 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (14, 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (15, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (16, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (17, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (18, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (19, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (20, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (21, 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (22, 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (23, 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (24, 3); 
INSERT INTO Reserve (eventID , visitorID) VALUES (25, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (26, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (27, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (28, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (29, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (30, 3);
INSERT INTO Reserve (eventID , visitorID) VALUES (1 , 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (2 , 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (3 , 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (4 , 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (5 , 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (6 , 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (7 , 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (8 , 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (9 , 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (10, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (11, 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (12, 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (13, 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (14, 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (15, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (16, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (17, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (18, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (19, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (20, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (21, 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (22, 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (23, 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (24, 9); 
INSERT INTO Reserve (eventID , visitorID) VALUES (25, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (26, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (27, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (28, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (29, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (30, 9);
INSERT INTO Reserve (eventID , visitorID) VALUES (1 , 5); 
INSERT INTO Reserve (eventID , visitorID) VALUES (2 , 6);
INSERT INTO Reserve (eventID , visitorID) VALUES (3 , 7);
INSERT INTO Reserve (eventID , visitorID) VALUES (4 , 8);
INSERT INTO Reserve (eventID , visitorID) VALUES (5 , 10);

-- FeaturedIn
--- in Enclosure 1
-- INSERT INTO FeaturedIn(eventID , animalID) VALUES (1  , 1);
-- INSERT INTO FeaturedIn(eventID , animalID) VALUES (2  , 10);
-- INSERT INTO FeaturedIn(eventID , animalID) VALUES (3  , 19);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (4  , 28);
--- in Enclosure 2
INSERT INTO FeaturedIn(eventID , animalID) VALUES (5  , 2);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (6  , 11);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (7  , 20);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (8  , 29);
--- in Enclosure 3
INSERT INTO FeaturedIn(eventID , animalID) VALUES (9  , 3);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (10 , 12);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (11 , 21);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (12 , 30);
--- in Enclosure 4
INSERT INTO FeaturedIn(eventID , animalID) VALUES (13 , 4);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (14 , 13);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (15 , 22);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (16 , 31);
--- in Enclosure 5
INSERT INTO FeaturedIn(eventID , animalID) VALUES (17 , 5);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (18 , 14);
-- INSERT INTO FeaturedIn(eventID , animalID) VALUES (19 , 23);
-- INSERT INTO FeaturedIn(eventID , animalID) VALUES (20 , 32);
--- in Enclosure 6
INSERT INTO FeaturedIn(eventID , animalID) VALUES (21 , 6);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (22 , 15);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (23 , 24);
-- INSERT INTO FeaturedIn(eventID , animalID) VALUES (24 , 33);
--- in Enclosure 7
INSERT INTO FeaturedIn(eventID , animalID) VALUES (25 , 7);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (26 , 16);
-- INSERT INTO FeaturedIn(eventID , animalID) VALUES (27 , 25);
-- INSERT INTO FeaturedIn(eventID , animalID) VALUES (28 , 34);
--- in Enclosure 8
INSERT INTO FeaturedIn(eventID , animalID) VALUES (29 , 8);
INSERT INTO FeaturedIn(eventID , animalID) VALUES (30 , 9);

-- HostedBy
INSERT INTO HostedBy(eventID , trainerID) VALUES (1 , 6);
INSERT INTO HostedBy(eventID , trainerID) VALUES (2 , 7);
INSERT INTO HostedBy(eventID , trainerID) VALUES (3 , 8);
INSERT INTO HostedBy(eventID , trainerID) VALUES (4 , 9);
INSERT INTO HostedBy(eventID , trainerID) VALUES (1 , 10);

-- ResponsibleFor
INSERT INTO ResponsibleFor(keeperID , animalID) VALUES(11 , 1); 
INSERT INTO ResponsibleFor(keeperID , animalID) VALUES(12 , 1); 
INSERT INTO ResponsibleFor(keeperID , animalID) VALUES(12 , 2);
INSERT INTO ResponsibleFor(keeperID , animalID) VALUES(12 , 3);
INSERT INTO ResponsibleFor(keeperID , animalID) VALUES(12 , 4);
INSERT INTO ResponsibleFor(keeperID , animalID) VALUES(12 , 5);
INSERT INTO ResponsibleFor(keeperID , animalID) VALUES(13 , 3); 
INSERT INTO ResponsibleFor(keeperID , animalID) VALUES(14 , 4); 
INSERT INTO ResponsibleFor(keeperID , animalID) VALUES(15 , 5); 
INSERT INTO ResponsibleFor(keeperID , animalID) VALUES(11 , 5);

-- TrainedBy
INSERT INTO TrainedBy(trainerID , animalID) VALUES(6  , 1); 
INSERT INTO TrainedBy(trainerID , animalID) VALUES(7  , 3); 
INSERT INTO TrainedBy(trainerID , animalID) VALUES(8  , 4); 
INSERT INTO TrainedBy(trainerID , animalID) VALUES(9  , 2); 
INSERT INTO TrainedBy(trainerID , animalID) VALUES(10 , 5); 
INSERT INTO TrainedBy(trainerID , animalID) VALUES(7  , 1); 
INSERT INTO TrainedBy(trainerID , animalID) VALUES(7  , 4); 
INSERT INTO TrainedBy(trainerID , animalID) VALUES(9  , 4); 
INSERT INTO TrainedBy(trainerID , animalID) VALUES(10 , 2); 
INSERT INTO TrainedBy(trainerID , animalID) VALUES(6  , 5); 

-- MedicalRecords
INSERT INTO MedicalRecords(notes , purpose , dateTime , animalID , vetID) VALUES (NULL                                                                                         , 'give painkillers for left leg'               , (TO_DATE ('21-OCT-2021' , 'YYYY-MM-DD HH24:MI')) , 1 , 16) ; 
INSERT INTO MedicalRecords(notes , purpose , dateTime , animalID , vetID) VALUES ('make sure to check up again next Thursday to see if walking is still off'                   , 'bandage right paw due to a cut'              , (TO_DATE ('17-OCT-2021' , 'YYYY-MM-DD HH24:MI')) , 2 , 17);  
INSERT INTO MedicalRecords(notes , purpose , dateTime , animalID , vetID) VALUES ('Keep animal in vet quarters for another week until 13-OCT-2021'                             , 'Clean up bite mark on upper back'            , (TO_DATE ('06-OCT-2021' , 'YYYY-MM-DD HH24:MI')) , 2 , 18);  
INSERT INTO MedicalRecords(notes , purpose , dateTime , animalID , vetID) VALUES (NULL                                                                                         , 'cleaned up build up behind left ear'         , (TO_DATE ('11-OCT-2021' , 'YYYY-MM-DD HH24:MI')) , 4 , 19);  
INSERT INTO MedicalRecords(notes , purpose , dateTime , animalID , vetID) VALUES ('Make sure dose is taken twice daily: once in the morning before feeding and once after 7pm' , 'Medicine prescribed for virus'               , (TO_DATE ('13-OCT-2021' , 'YYYY-MM-DD HH24:MI')) , 3 , 20);  
INSERT INTO MedicalRecords(notes , purpose , dateTime , animalID , vetID) VALUES ('Keep in private enclosure until walking and eating as normal again'                         , 'bandaged a bone fracture on upper right leg' , (TO_DATE ('17-OCT-2021' , 'YYYY-MM-DD HH24:MI')) , 3 , 18);  

COMMIT WORK;