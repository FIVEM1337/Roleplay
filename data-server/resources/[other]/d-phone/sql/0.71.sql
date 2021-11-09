CREATE TABLE IF NOT EXISTS `phone_advertisement` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL DEFAULT '0',
  `number` varchar(50) NOT NULL DEFAULT '0',
  `message` varchar(500) NOT NULL DEFAULT '0',
  `date` varchar(500) NOT NULL DEFAULT '0',
  `time` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=13 DEFAULT CHARSET=utf8mb4;
