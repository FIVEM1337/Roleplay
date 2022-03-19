ALTER TABLE `users` ADD COLUMN `jail_data` LONGTEXT NOT NULL DEFAULT '{"cell":0,"chest":[],"jailtime":0,"items":[],"clothes":[],"job":0,"breaks":0,"soli":0,"jobo":"nil","grade":0}';

INSERT INTO `jobs` (name, label) VALUES
	('prisoner', 'Prison')	
;

INSERT INTO `job_grades` (job_name, grade, name, label, salary, skin_male, skin_female) VALUES
	('prisoner',0,'inmate','Inmate',10,'{}','{}')
;


INSERT INTO `items` (`name`, `label`, `weight`, `rare`, `can_remove`) VALUES 
('jail_jspoon', 'Broken Spoon', 1, 0, 1),
('jail_spoon', 'jail_spoon', 1, 0, 1),
('jail_bcloth', 'Broken Spoon With Wet Cloth', 1, 0, 1),
('jail_wcloth', 'Wet Cloth', 1, 0, 1),
('jail_cloth', 'jail_cloth', 1, 0, 1),
('jail_cleaner', 'jail_cleaner', 1, 0, 1),
('jail_file', 'jail_file', 1, 0, 1),
('jail_smetal', 'Sharp Metal', 1, 0, 1),
('jail_metal', 'jail_metal', 1, 0, 1),
('jail_rock', 'jail_rock', 1, 0, 1),
('jail_ladle', 'jail_ladle', 1, 0, 1),
('jail_bladle', 'Broken Ladle', 1, 0, 1),
('jail_dliquid', 'Dirty Liquid', 1, 0, 1),
('jail_acid', 'jail_acid', 5, 0, 1),
('jail_grease', 'jail_grease', 1, 0, 1),
('jail_bottle', 'jail_bottle', 1, 0, 1),
('jail_schange', 'Spare Change', 1, 0, 1),
('jail_shank', 'jail_shank', 1, 0, 1),
('jail_minihammer', 'Mini Hammer', 5, 0, 1),
('jail_fpacket', 'Flavor Packet', 1, 0, 1),
('jail_ppunch', 'Prison Punch', 1, 0, 1),
('jail_iheat', 'Immersion Heater', 5, 0, 1),
('jail_plug', 'jail_plug', 1, 0, 1),
('jail_booze', 'jail_booze', 1, 0, 1)
;