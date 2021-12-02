ALTER TABLE owned_vehicles
ADD garage_id varchar(32) NOT NULL DEFAULT 'A';

ALTER TABLE owned_vehicles
ADD impound int(1) NOT NULL DEFAULT 0;

ALTER TABLE owned_vehicles
ADD `stored` int(1) NOT NULL DEFAULT 0;

ALTER TABLE owned_vehicles
ADD `type` varchar(32) NOT NULL DEFAULT 'car';

ALTER TABLE owned_vehicles
ADD `job` varchar(32) NOT NULL DEFAULT 'civ';

CREATE TABLE IF NOT EXISTS `impound_garage` (
	`garage` VARCHAR(64) NOT NULL DEFAULT '' COLLATE 'utf8mb4_general_ci',
    	`data` LONGTEXT NULL COLLATE 'utf8mb4_general_ci',
	PRIMARY KEY (`garage`) USING BTREE
)
COLLATE='utf8mb4_general_ci'
ENGINE=InnoDB
;
