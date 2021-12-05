USE `essentialmode`;

INSERT INTO `addon_account` (name, label, shared) VALUES
	('society_liberty', 'Grove', 1)
;

INSERT INTO `datastore` (name, label, shared) VALUES
	('society_grove', 'Grove', 1)
;

INSERT INTO `addon_inventory` (name, label, shared) VALUES
	('society_grove', 'Grove', 1)
;

INSERT INTO `jobs` (name, label) VALUES
	('grove','Grove')
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('grove',0,'recruit','Ticker',1500,'{}','{}'),
	('grove',1,'officer','Homie',1500,'{}','{}'),
	('grove',2,'sergeant','Executor',1500,'{}','{}'),
	('grove',3,'lieutenant','Original Gangster',1500,'{}','{}'),
	('grove',4,'boss','Double OG',1500,'{}','{}')
;

