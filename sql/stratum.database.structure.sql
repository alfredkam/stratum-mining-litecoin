-- MySQL dump 10.13  Distrib 5.5.31, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: stratum
-- ------------------------------------------------------
-- Server version	5.5.31-0ubuntu0.12.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `pool`
--

DROP TABLE IF EXISTS `pool`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pool` (
  `parameter` varchar(128) CHARACTER SET utf8 NOT NULL,
  `value` varchar(512) CHARACTER SET utf8 DEFAULT NULL,
  PRIMARY KEY (`parameter`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pool`
--

LOCK TABLES `pool` WRITE;
/*!40000 ALTER TABLE `pool` DISABLE KEYS */;
INSERT INTO `pool` VALUES ('bitcoin_balance','0'),('bitcoin_blocks','0'),('bitcoin_connections','0'),('bitcoin_difficulty','0'),('bitcoin_infotime','0'),('DB Version','7'),('pool_hashrate','0'),('pool_total_found','0'),('round_best_share','0'),('round_progress','0'),('round_shares','0'),('round_start','1370341058.99371');
/*!40000 ALTER TABLE `pool` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `pool_worker`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `pool_worker` (
  `id` int(255) unsigned NOT NULL AUTO_INCREMENT,
  `username` varchar(50) CHARACTER SET utf8 NOT NULL,
  `password` char(255) CHARACTER SET utf8 COLLATE utf8_bin NOT NULL,
  `hashrate` int(10) unsigned NOT NULL DEFAULT '0',
  `last_checkin` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `total_shares` int(10) unsigned NOT NULL DEFAULT '0',
  `total_rejects` int(10) unsigned NOT NULL DEFAULT '0',
  `total_found` int(10) unsigned NOT NULL DEFAULT '0',
  `alive` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `difficulty` int(10) unsigned NOT NULL DEFAULT '0',
  `account_id` int(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `pool_worker-username` (`username`),
  KEY `pool_worker-alive` (`alive`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Table structure for table `shares`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `shares` (
  `id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `rem_host` varchar(255) NOT NULL,
  `worker` bigint(20) unsigned NOT NULL DEFAULT '0',
  `username` varchar(120) NOT NULL,
  `our_result` tinyint(1) DEFAULT NULL,
  `upstream_result` tinyint(1) DEFAULT NULL,
  `reason` varchar(50),
  `solution` varchar(256),
  `block_num` int(11) DEFAULT NULL,
  `prev_block_hash` varchar(256),
  `useragent` varchar(256),
  `difficulty` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `shares_upstreamresult` (`upstream_result`),
  KEY `shares_time_worker` (`time`,`worker`),
  KEY `shares_worker` (`worker`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shares`
--

--
-- Table structure for table `shares_archive`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `shares_archive` (
  `id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `rem_host` varchar(255) NOT NULL,
  `username` varchar(120) NOT NULL,
  `our_result` tinyint(1) DEFAULT NULL,
  `upstream_result` tinyint(1) DEFAULT NULL,
  `reason` varchar(50),
  `solution` varchar(256),
  `block_num` int(11) DEFAULT NULL,
  `prev_block_hash` varchar(256),
  `useragent` varchar(256),
  `difficulty` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `shares_archive`
--

--
-- Table structure for table `shares_archive_found`
--

/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE IF NOT EXISTS `shares_archive_found` (
  `id` bigint(30) unsigned NOT NULL AUTO_INCREMENT,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  `rem_host` varchar(255) NOT NULL,
  `username` varchar(120) NOT NULL,
  `our_result` tinyint(1) DEFAULT NULL,
  `upstream_result` tinyint(1) DEFAULT NULL,
  `reason` varchar(50),
  `solution` varchar(256),
  `block_num` int(11) DEFAULT NULL,
  `prev_block_hash` varchar(256),
  `useragent` varchar(256),
  `difficulty` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  UNIQUE KEY `id` (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
