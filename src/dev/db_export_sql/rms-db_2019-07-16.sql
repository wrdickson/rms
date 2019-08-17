-- Adminer 4.7.2 MySQL dump

SET NAMES utf8;
SET time_zone = '+00:00';
SET foreign_key_checks = 0;
SET sql_mode = 'NO_AUTO_VALUE_ON_ZERO';

DROP TABLE IF EXISTS `customers`;
CREATE TABLE `customers` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `lastName` varchar(48) NOT NULL,
  `firstName` varchar(48) NOT NULL,
  `address1` varchar(64) NOT NULL,
  `address2` varchar(64) NOT NULL,
  `city` varchar(48) NOT NULL,
  `region` varchar(48) NOT NULL,
  `country` varchar(48) NOT NULL,
  `postalCode` varchar(48) NOT NULL,
  `phone` varchar(32) NOT NULL,
  `email` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `customers` (`id`, `lastName`, `firstName`, `address1`, `address2`, `city`, `region`, `country`, `postalCode`, `phone`, `email`) VALUES
(1,	'Schmoe',	'Joe',	'',	'',	'',	'',	'',	'',	'happy jack',	'nopeersa'),
(2,	'Hiker',	'Harry',	'123',	'',	'',	'',	'',	'',	'',	''),
(3,	'Biker',	'Dazedahasalongn',	'123 S Main St',	'Apt 323',	'Moab',	'UT',	'USA',	'84532',	'509 389 2462',	'asdf@something.net'),
(4,	'Climber',	'Carl',	'',	'',	'',	'',	'',	'',	'',	''),
(5,	'Methhead',	'Michael',	'',	'',	'Moab',	'',	'',	'',	'',	''),
(6,	'Biker',	'Bobby',	'tyuiutyit',	'',	'asdfasd',	'6686796',	'tuitiuy',	'vcxnxbcv',	'123412',	'dsfasda'),
(7,	'Biker',	'Carl',	'',	'',	'',	'',	'',	'',	'',	''),
(8,	'Biker',	'Shenanigans',	'',	'',	'',	'',	'',	'',	'',	'');

DROP TABLE IF EXISTS `folios`;
CREATE TABLE `folios` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `customer` int(11) NOT NULL,
  `reservation` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `folios` (`id`, `customer`, `reservation`) VALUES
(2,	2,	12);

DROP TABLE IF EXISTS `payment_types`;
CREATE TABLE `payment_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(24) NOT NULL,
  `is_active` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `payment_types` (`id`, `title`, `is_active`) VALUES
(1,	'Cash',	1),
(2,	'Visa/ Mastercard',	1),
(3,	'Discover',	1),
(4,	'American Express',	0),
(5,	'Dicsover',	1),
(6,	'Check',	1);

DROP TABLE IF EXISTS `payments`;
CREATE TABLE `payments` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `amount` decimal(19,4) NOT NULL,
  `pymt_type` int(11) NOT NULL,
  `by` int(11) NOT NULL,
  `folio` int(11) NOT NULL,
  `shift` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `reservations`;
CREATE TABLE `reservations` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `space_type` int(11) NOT NULL,
  `space_code` text NOT NULL,
  `space_id` int(11) NOT NULL,
  `checkin` date NOT NULL,
  `checkout` date NOT NULL,
  `customer` int(11) NOT NULL,
  `people` int(11) NOT NULL,
  `beds` int(11) NOT NULL,
  `folio` int(11) NOT NULL,
  `history` text NOT NULL,
  `status` int(11) NOT NULL,
  `notes` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `space_type` (`space_type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `reservations` (`id`, `space_type`, `space_code`, `space_id`, `checkin`, `checkout`, `customer`, `people`, `beds`, `folio`, `history`, `status`, `notes`) VALUES
(11,	1,	'4',	4,	'2019-06-24',	'2019-06-29',	3,	1,	1,	0,	'[]',	1,	'[]'),
(12,	2,	'2',	2,	'2019-06-25',	'2019-06-29',	1,	1,	2,	2,	'[]',	1,	'[{\"date\":\"2019-07-19T22:19:56.626Z\",\"by\":\"admin\",\"text\":\"some note for this reservation\"}]'),
(13,	2,	'4',	4,	'2019-06-29',	'2019-06-30',	2,	1,	1,	0,	'[]',	1,	'[]'),
(14,	2,	'200,201,202,203,204',	204,	'2019-06-20',	'2019-06-25',	2,	4,	4,	0,	'[]',	1,	'[]'),
(15,	2,	'5',	5,	'2019-06-24',	'2019-06-25',	3,	1,	1,	0,	'[]',	0,	'[]'),
(16,	0,	'2',	2,	'2019-06-24',	'2019-06-25',	4,	1,	1,	0,	'[]',	1,	'[]');

DROP TABLE IF EXISTS `reshistory`;
CREATE TABLE `reshistory` (
  `resId` int(11) NOT NULL,
  `history` text
) ENGINE=InnoDB DEFAULT CHARSET=utf8;


DROP TABLE IF EXISTS `sales`;
CREATE TABLE `sales` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sale_date` datetime NOT NULL,
  `tax_type` int(11) NOT NULL,
  `sales_item` int(11) NOT NULL,
  `net` decimal(19,4) NOT NULL,
  `tax` decimal(19,4) NOT NULL,
  `total` decimal(19,4) NOT NULL,
  `by` int(11) NOT NULL,
  `folio` int(11) NOT NULL,
  `shift` int(11) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `shift` (`shift`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `sales` (`id`, `sale_date`, `tax_type`, `sales_item`, `net`, `tax`, `total`, `by`, `folio`, `shift`) VALUES
(1,	'2019-07-15 16:42:50',	1,	1,	22.0000,	1.5400,	23.5400,	1,	2,	1),
(2,	'2019-07-15 18:06:55',	2,	2,	22.0000,	1.7600,	23.7600,	1,	2,	1);

DROP TABLE IF EXISTS `sales_item_groups`;
CREATE TABLE `sales_item_groups` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `group_order` int(11) NOT NULL,
  `sales_item_title` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `sales_item_groups` (`id`, `group_order`, `sales_item_title`) VALUES
(1,	10,	'Room Charge'),
(2,	20,	'Merhcandise');

DROP TABLE IF EXISTS `sales_items`;
CREATE TABLE `sales_items` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `sales_group` int(11) NOT NULL,
  `sales_group_order` int(11) NOT NULL,
  `sales_item_title` varchar(48) NOT NULL,
  `is_fixed_price` tinyint(4) NOT NULL,
  `price` decimal(19,4) NOT NULL,
  `tax_type` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `sales_items` (`id`, `sales_group`, `sales_group_order`, `sales_item_title`, `is_fixed_price`, `price`, `tax_type`) VALUES
(1,	1,	10,	'Private Room - 1 Person - Winter',	1,	22.0000,	1),
(2,	2,	10,	'T Shirt, taxes',	1,	12.0000,	2),
(3,	1,	5,	'Room Charge',	0,	0.0000,	1);

DROP TABLE IF EXISTS `select_groups`;
CREATE TABLE `select_groups` (
  `id` int(11) NOT NULL,
  `title` varchar(48) NOT NULL,
  `order` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `select_groups` (`id`, `title`, `order`) VALUES
(1,	'Dorm Beds',	1),
(2,	'Rooms - Hostel',	2),
(3,	'Cabins',	3),
(4,	'Houses',	4),
(5,	'Houses - Rooms',	5),
(6,	'Dorm Overflow',	6);

DROP TABLE IF EXISTS `shifts`;
CREATE TABLE `shifts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `user` int(11) NOT NULL,
  `start_date` datetime NOT NULL,
  `end_date` datetime NOT NULL,
  PRIMARY KEY (`id`),
  KEY `user` (`user`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `shifts` (`id`, `user`, `start_date`, `end_date`) VALUES
(1,	1,	'2019-01-01 07:00:00',	'2019-01-01 15:00:00'),
(8,	1,	'2019-01-10 13:38:50',	'0000-00-00 00:00:00');

DROP TABLE IF EXISTS `space_types`;
CREATE TABLE `space_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `title` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `space_types` (`id`, `title`) VALUES
(1,	'Dorm Bed'),
(2,	'Room'),
(3,	'Cabin'),
(4,	'Camping'),
(5,	'House');

DROP TABLE IF EXISTS `spaces`;
CREATE TABLE `spaces` (
  `description` varchar(244) NOT NULL,
  `child_of` int(11) NOT NULL,
  `show_subspaces` tinyint(4) NOT NULL,
  `show_order` int(11) NOT NULL,
  `space_id` int(11) NOT NULL,
  `space_code` text NOT NULL,
  `subspaces` text NOT NULL,
  `space_type` int(11) NOT NULL,
  `beds` int(11) NOT NULL,
  `people` int(11) NOT NULL,
  `select_group` int(11) NOT NULL,
  `select_order` int(11) NOT NULL,
  UNIQUE KEY `space_id` (`space_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `spaces` (`description`, `child_of`, `show_subspaces`, `show_order`, `space_id`, `space_code`, `subspaces`, `space_type`, `beds`, `people`, `select_group`, `select_order`) VALUES
('Dorm 0 Bed 1',	9,	0,	101,	1,	'1',	'',	1,	1,	1,	1,	1),
('Dorm 0 Bed 2',	9,	0,	102,	2,	'2',	'',	1,	1,	1,	1,	2),
('Dorm 0 Bed 3',	9,	0,	103,	3,	'3',	'',	1,	1,	1,	1,	3),
('Dorm 0 Bed 4',	9,	0,	104,	4,	'4',	'',	1,	1,	1,	1,	4),
('Dorm 0 Bed 5',	9,	0,	105,	5,	'5',	'',	1,	1,	1,	1,	5),
('Dorm 0 Bed 6',	9,	0,	106,	6,	'6',	'',	1,	1,	1,	1,	6),
('Dorm 0 Bed 7',	9,	0,	107,	7,	'7',	'',	1,	1,	1,	1,	7),
('Dorm 0 Bed 8',	9,	0,	108,	8,	'8',	'',	1,	1,	1,	1,	8),
('Dorm 0 All',	0,	1,	100,	9,	'1,2,3,4,5,6,7,8,9',	'1,2,3,4,5,6,7,8',	2,	8,	8,	2,	0),
('Room 2 Bed 1 double',	32,	0,	501,	30,	'30',	'',	1,	1,	2,	0,	0),
('Room 2 Bed 2 single',	32,	0,	502,	31,	'31',	'',	1,	1,	1,	0,	0),
('Room 2 All',	0,	0,	500,	32,	'30,31,32',	'30,31',	2,	2,	3,	2,	1),
('La Casa - All',	0,	1,	1700,	170,	'180,181,182,183,190,191,192,193,200,201,202,203,204,220,221,222,230,231,232,233,234,235,236\r\n230,231,232,233',	'183,193,204,211,222,236',	5,	21,	21,	4,	10),
('Room 18, Bed 1 Single',	183,	0,	1810,	180,	'180',	'',	1,	1,	1,	2,	0),
('Room 18 Bed 2 Single',	183,	0,	1820,	181,	'181',	'',	1,	1,	1,	0,	0),
('Room 18 Bed 3 Double',	183,	0,	1830,	182,	'182',	'',	1,	1,	2,	0,	0),
('Room 18 All',	170,	0,	1800,	183,	'180,181,182,183',	'180,181,182',	2,	3,	4,	2,	18),
('Room 19 Bed 1 Single',	193,	0,	1910,	190,	'190',	'',	1,	1,	1,	0,	0),
('Room 19 Bed 2 Single',	193,	0,	1920,	191,	'191',	'',	1,	1,	1,	0,	0),
('Room 19 Bed 3 Double',	193,	0,	1930,	192,	'192',	'',	1,	1,	2,	0,	0),
('Room 19 All',	170,	0,	1900,	193,	'190,191,192,193',	'190,191,192',	2,	3,	4,	2,	19),
('Room 20 Bed 1 Single',	204,	0,	2010,	200,	'200',	'',	1,	1,	1,	0,	0),
('Room 20 Bed 2 Single',	204,	0,	2020,	201,	'201',	'',	1,	1,	1,	0,	0),
('Room 20 Bed 3 Single',	204,	0,	2030,	202,	'202',	'',	1,	1,	1,	0,	0),
('Room 20 Bed 4 Single',	204,	0,	2040,	203,	'203',	'',	1,	1,	1,	0,	0),
('Room 20 All',	170,	1,	2000,	204,	'200,201,202,203,204',	'200,201,202,203',	2,	4,	4,	2,	20),
('Room 21 Bed 1 Double',	211,	0,	2120,	210,	'210',	'',	1,	1,	2,	0,	0),
('Room 21 All',	170,	0,	2110,	211,	'210,211',	'210',	2,	1,	2,	0,	0),
('Room 22 Bed 1 Single',	222,	0,	2210,	220,	'220',	'',	1,	1,	1,	0,	0),
('Room 22 Bed 2 Double',	222,	0,	2220,	221,	'221',	'',	1,	1,	2,	0,	0),
('Room 22 All',	170,	0,	2200,	222,	'220,221,222',	'220,221',	2,	2,	3,	2,	22),
('Room 23 Bed 1',	236,	0,	2310,	230,	'230',	'',	1,	1,	1,	0,	0),
('Room 23 Bed 2',	236,	0,	2320,	231,	'231',	'',	1,	1,	1,	0,	0),
('Room 23 Bed 3',	236,	0,	2330,	232,	'232',	'',	1,	1,	1,	0,	0),
('Room 23 Bed 4',	236,	0,	2340,	233,	'233',	'',	1,	1,	1,	0,	0),
('Room 23 Bed 5',	236,	0,	2350,	234,	'234',	'',	1,	1,	1,	0,	0),
('Room23 Bed 6',	236,	0,	2360,	235,	'235',	'',	1,	1,	1,	0,	0),
('Room 23 All',	170,	0,	2300,	236,	'230,231,232,233,234,235,236',	'230,231,232,233,234,235',	2,	6,	6,	2,	23),
('Room 24 - All',	0,	1,	2400,	240,	'241,242,243,244,240',	'241,242,243,244',	2,	4,	4,	2,	24),
('Room 24 - Bed 1',	240,	0,	2410,	241,	'241',	'',	1,	1,	1,	1,	41),
('Room 24 - Bed 2',	240,	0,	2420,	242,	'242',	'',	1,	1,	1,	1,	42),
('Room 24 - Bed 3',	240,	0,	2430,	243,	'243',	'',	1,	1,	1,	1,	43),
('Room 24 - Bed 4',	240,	0,	2440,	244,	'244',	'',	1,	1,	1,	1,	44);

DROP TABLE IF EXISTS `tax_types`;
CREATE TABLE `tax_types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `tax_title` varchar(48) NOT NULL,
  `tax_rate` decimal(19,4) NOT NULL,
  `is_current` tinyint(4) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `tax_types` (`id`, `tax_title`, `tax_rate`, `is_current`) VALUES
(1,	'LodgingTax @ .115',	0.1150,	1),
(2,	'Sales Tax @ .073',	0.0730,	1),
(3,	'No Tax',	0.0000,	1);

DROP TABLE IF EXISTS `users`;
CREATE TABLE `users` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `username` varchar(32) NOT NULL,
  `email` varchar(64) NOT NULL,
  `permission` int(11) NOT NULL,
  `registered` datetime NOT NULL,
  `last_activity` datetime NOT NULL,
  `last_login` datetime NOT NULL,
  `user_key` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

INSERT INTO `users` (`id`, `username`, `email`, `permission`, `registered`, `last_activity`, `last_login`, `user_key`, `password`) VALUES
(1,	'admin',	'admin@gmail.com',	10,	'2018-02-14 21:51:48',	'2019-07-19 15:37:01',	'2019-07-19 15:37:01',	'3dfc75955d55c8b990768b7446b7e76965cbde38bede34324ce422ad19a75fc0',	'8c6976e5b5410415bde908bd4dee15dfb167a9c873fc4bb8a81f6f2ab448a918'),
(4,	'schmoe',	'schmoe@whatever.com',	1,	'2018-11-09 21:28:24',	'2018-11-15 19:33:42',	'2018-11-15 19:33:41',	'59c74d157ea07a08aa7f5494c62a78d776a727f8305dd626fa94612440c4e340',	'022c22c21fc47dda38e12228c1e69fbc6a9e18d9d3478927091ca4145d641862');

-- 2019-07-19 23:30:38