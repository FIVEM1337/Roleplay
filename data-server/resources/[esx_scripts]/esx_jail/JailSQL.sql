ALTER TABLE `users` ADD COLUMN `jail_data` LONGTEXT NOT NULL DEFAULT '{"cell":0,"chest":[],"jailtime":0,"items":[],"clothes":[],"job":0,"breaks":0,"soli":0,"jobo":"nil","grade":0}';

INSERT INTO `jobs` (name, label) VALUES
	('prisoner', 'Prison')	
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('prisoner',0,'inmate','Inmate',10,'{}','{}')
;


INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES 
('jspoon', 'Broken Spoon', 1, 0, 1),
('spoon', 'Spoon', 1, 0, 1),
('bCloth', 'Broken Spoon With Wet Cloth', 1, 0, 1),
('wCloth', 'Wet Cloth', 1, 0, 1),
('cloth', 'Cloth', 1, 0, 1),
('cleaner', 'Cleaner', 1, 0, 1),
('file', 'File', 1, 0, 1),
('sMetal', 'Sharp Metal', 1, 0, 1),
('metal', 'Metal', 1, 0, 1),
('rock', 'Rock', 1, 0, 1),
('ladle', 'Ladle', 1, 0, 1),
('bLadle', 'Broken Ladle', 1, 0, 1),
('dLiquid', 'Dirty Liquid', 1, 0, 1),
('acid', 'Acid', 5, 0, 1),
('grease', 'Grease', 1, 0, 1),
('bottle', 'Bottle', 1, 0, 1),
('sChange', 'Spare Change', 1, 0, 1),
('Shank', 'Shank', 1, 0, 1),
('miniH', 'Mini Hammer', 5, 0, 1),
('fPacket', 'Flavor Packet', 1, 0, 1),
('pPunch', 'Prison Punch', 1, 0, 1),
('iHeat', 'Immersion Heater', 5, 0, 1),
('plug', 'Plug', 1, 0, 1),
('booze', 'Booze', 1, 0, 1)
;