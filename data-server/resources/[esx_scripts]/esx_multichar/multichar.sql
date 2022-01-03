
CREATE TABLE IF NOT EXISTS `user_lastcharacter` (
  `steamid` varchar(255) NOT NULL,
  `charid` int(11) NOT NULL,
  `maxChars` int(11) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

ALTER TABLE `users` ADD COLUMN `pedModeAllowed` TINYINT(4) NULL DEFAULT NULL;
ALTER TABLE `users` ADD COLUMN `pedModel` VARCHAR(255) NULL DEFAULT NULL;

ALTER TABLE `users`
  ADD COLUMN `firstname` VARCHAR(50) NULL DEFAULT '',
  ADD COLUMN `lastname` VARCHAR(50) NULL DEFAULT '',
  ADD COLUMN `dateofbirth` VARCHAR(25) NULL DEFAULT '',
  ADD COLUMN `sex` VARCHAR(10) NULL DEFAULT '',
  ADD COLUMN `height` VARCHAR(5) NULL DEFAULT ''
;

ALTER TABLE `user_lastcharacter` ADD COLUMN `maxChars` INT(11) NOT NULL DEFAULT 1;