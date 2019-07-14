-- MySQL dump 10.13  Distrib 5.7.18, for Linux (x86_64)
--
-- Host: localhost    Database: tiw
-- ------------------------------------------------------
-- Server version	5.7.18-0ubuntu0.16.04.1

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
-- Current Database: `tiw`
--

CREATE DATABASE /*!32312 IF NOT EXISTS*/ `tiw` /*!40100 DEFAULT CHARACTER SET latin1 */;

USE `tiw`;

--
-- Table structure for table `annotation`
--

DROP TABLE IF EXISTS `annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `annotation` (
  `url` varchar(128) NOT NULL,
  `image` varchar(128) NOT NULL,
  `worker` varchar(64) NOT NULL,
  PRIMARY KEY (`image`,`worker`),
  KEY `image` (`image`),
  KEY `worker` (`worker`),
  CONSTRAINT `annotation_ibfk_2` FOREIGN KEY (`worker`) REFERENCES `user` (`username`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `annotation_ibfk_3` FOREIGN KEY (`image`) REFERENCES `image` (`url`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `annotation`
--

LOCK TABLES `annotation` WRITE;
/*!40000 ALTER TABLE `annotation` DISABLE KEYS */;
INSERT INTO `annotation` VALUES ('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg_link2universe.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg','link2universe'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg_Mashokki.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg','Mashokki'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg_Nelly.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg','Nelly'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg_Raf.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg','Raf'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg_Rene.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg','Rene'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg_link2universe.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg','link2universe'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg_Mashokki.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg','Mashokki'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg_Raf.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg','Raf'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg_Rene.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg','Rene'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg_yuri98.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg','yuri98'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg_link2universe.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg','link2universe'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg_Mashokki.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg','Mashokki'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg_Raf.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg','Raf'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg_Rene.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg','Rene'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg_yuri98.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg','yuri98'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg_link2universe.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg','link2universe'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg_Mashokki.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg','Mashokki'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg_Nelly.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg','Nelly'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg_Rene.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg','Rene'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg_yuri98.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg','yuri98'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg_link2universe.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg','link2universe'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg_Mashokki.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg','Mashokki'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg_Nelly.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg','Nelly'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg_Rene.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg','Rene'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg_Ultra AleM.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg','Ultra AleM'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg_link2universe.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg','link2universe'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg_Mashokki.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg','Mashokki'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg_Nelly.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg','Nelly'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg_Raf.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg','Raf'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg_Ultra AleM.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg','Ultra AleM'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png_Lexy.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png','Lexy'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png_link2universe.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png','link2universe'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png_Mashokki.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png','Mashokki'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png_Raf.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png','Raf'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png_Ultra AleM.json','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png','Ultra AleM');
/*!40000 ALTER TABLE `annotation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `annotation_stats`
--

DROP TABLE IF EXISTS `annotation_stats`;
/*!50001 DROP VIEW IF EXISTS `annotation_stats`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `annotation_stats` AS SELECT 
 1 AS `image`,
 1 AS `number_of_annotations`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `campaign`
--

DROP TABLE IF EXISTS `campaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `campaign` (
  `name` varchar(64) NOT NULL,
  `manager` varchar(64) NOT NULL,
  `users_for_image_selection` int(11) NOT NULL,
  `least_positive_ratings` int(11) NOT NULL,
  `users_for_image_annotation` int(11) NOT NULL,
  `line_pixels` int(11) NOT NULL,
  `active` tinyint(4) NOT NULL,
  PRIMARY KEY (`name`),
  KEY `manager` (`manager`),
  CONSTRAINT `campaign_ibfk_1` FOREIGN KEY (`manager`) REFERENCES `user` (`username`) ON DELETE NO ACTION ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `campaign`
--

LOCK TABLES `campaign` WRITE;
/*!40000 ALTER TABLE `campaign` DISABLE KEYS */;
INSERT INTO `campaign` VALUES ('Esempio','FiorixF1',3,3,3,3,1),('prova','FiorixF1',4,3,3,4,1),('SuperAlg','FiorixF1',5,3,5,8,1);
/*!40000 ALTER TABLE `campaign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `image`
--

DROP TABLE IF EXISTS `image`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `image` (
  `url` varchar(128) NOT NULL,
  `campaign` varchar(64) NOT NULL,
  PRIMARY KEY (`url`),
  KEY `campaign` (`campaign`),
  CONSTRAINT `image_ibfk_1` FOREIGN KEY (`campaign`) REFERENCES `campaign` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `image`
--

LOCK TABLES `image` WRITE;
/*!40000 ALTER TABLE `image` DISABLE KEYS */;
INSERT INTO `image` VALUES ('/home/fiorix/Immagini/Tiw/campaigns/Esempio/105.png','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/5641774-desktop-wallpapers.jpg','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/BASZNI.png','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/Computer-Wallpaper-18.jpg','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1440-900-553248.jpg','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1600-900-589443.jpg','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/iso.png','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/MATE PER LIA.png','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-01-03 15:18:35.png','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-01-31 18:40:19.png','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-05-19 23-43-05.png','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-05-31 12-59-34.png','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/splinter_cell_6-wallpaper-1600x900.jpg','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/Esempio/url.png','Esempio'),('/home/fiorix/Immagini/Tiw/campaigns/prova/Foto0002.jpg','prova'),('/home/fiorix/Immagini/Tiw/campaigns/prova/Foto0003.jpg','prova'),('/home/fiorix/Immagini/Tiw/campaigns/prova/Foto0004.jpg','prova'),('/home/fiorix/Immagini/Tiw/campaigns/prova/Foto0005.jpg','prova'),('/home/fiorix/Immagini/Tiw/campaigns/prova/Foto0006.jpg','prova'),('/home/fiorix/Immagini/Tiw/campaigns/prova/Foto0007.jpg','prova'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/105.png','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/BASZNI.png','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/iso.png','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/MATE PER LIA.png','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-03 15:18:35.png','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-31 18:40:19.png','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-05-19 23-43-05.png','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png','SuperAlg'),('/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/url.png','SuperAlg');
/*!40000 ALTER TABLE `image` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `image_statistics`
--

DROP TABLE IF EXISTS `image_statistics`;
/*!50001 DROP VIEW IF EXISTS `image_statistics`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `image_statistics` AS SELECT 
 1 AS `image`,
 1 AS `positive_ratings`,
 1 AS `negative_ratings`,
 1 AS `approved`,
 1 AS `number_of_ratings`,
 1 AS `number_of_annotations`,
 1 AS `rating_request_counter`,
 1 AS `annotation_request_counter`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pending_annotation`
--

DROP TABLE IF EXISTS `pending_annotation`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pending_annotation` (
  `image` varchar(128) NOT NULL,
  `worker` varchar(64) NOT NULL,
  `timestamp` bigint(20) NOT NULL,
  PRIMARY KEY (`image`,`worker`,`timestamp`),
  KEY `worker` (`worker`),
  CONSTRAINT `pending_annotation_ibfk_1` FOREIGN KEY (`image`) REFERENCES `image` (`url`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pending_annotation_ibfk_2` FOREIGN KEY (`worker`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pending_annotation`
--

LOCK TABLES `pending_annotation` WRITE;
/*!40000 ALTER TABLE `pending_annotation` DISABLE KEYS */;
INSERT INTO `pending_annotation` VALUES ('/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1600-900-589443.jpg','yuri98',1499162550);
/*!40000 ALTER TABLE `pending_annotation` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `pending_annotation_counter`
--

DROP TABLE IF EXISTS `pending_annotation_counter`;
/*!50001 DROP VIEW IF EXISTS `pending_annotation_counter`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `pending_annotation_counter` AS SELECT 
 1 AS `image`,
 1 AS `pending_request_counter`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `pending_rating`
--

DROP TABLE IF EXISTS `pending_rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `pending_rating` (
  `image` varchar(128) NOT NULL,
  `worker` varchar(64) NOT NULL,
  `timestamp` bigint(20) NOT NULL,
  PRIMARY KEY (`image`,`worker`,`timestamp`),
  KEY `worker` (`worker`),
  CONSTRAINT `pending_rating_ibfk_1` FOREIGN KEY (`image`) REFERENCES `image` (`url`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `pending_rating_ibfk_2` FOREIGN KEY (`worker`) REFERENCES `user` (`username`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `pending_rating`
--

LOCK TABLES `pending_rating` WRITE;
/*!40000 ALTER TABLE `pending_rating` DISABLE KEYS */;
/*!40000 ALTER TABLE `pending_rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `pending_rating_counter`
--

DROP TABLE IF EXISTS `pending_rating_counter`;
/*!50001 DROP VIEW IF EXISTS `pending_rating_counter`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `pending_rating_counter` AS SELECT 
 1 AS `image`,
 1 AS `pending_request_counter`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `rating`
--

DROP TABLE IF EXISTS `rating`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `rating` (
  `worker` varchar(64) NOT NULL,
  `image` varchar(128) NOT NULL,
  `rating` tinyint(1) NOT NULL,
  PRIMARY KEY (`worker`,`image`),
  KEY `image` (`image`),
  CONSTRAINT `rating_ibfk_1` FOREIGN KEY (`worker`) REFERENCES `user` (`username`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `rating_ibfk_2` FOREIGN KEY (`image`) REFERENCES `image` (`url`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `rating`
--

LOCK TABLES `rating` WRITE;
/*!40000 ALTER TABLE `rating` DISABLE KEYS */;
INSERT INTO `rating` VALUES ('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/105.png',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/5641774-desktop-wallpapers.jpg',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/BASZNI.png',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Computer-Wallpaper-18.jpg',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1440-900-553248.jpg',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1600-900-589443.jpg',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/iso.png',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/MATE PER LIA.png',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-01-03 15:18:35.png',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-01-31 18:40:19.png',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-05-19 23-43-05.png',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-05-31 12-59-34.png',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/splinter_cell_6-wallpaper-1600x900.jpg',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/Esempio/url.png',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/prova/Foto0002.jpg',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/prova/Foto0004.jpg',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/prova/Foto0007.jpg',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/105.png',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/BASZNI.png',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/iso.png',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/MATE PER LIA.png',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-31 18:40:19.png',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-05-19 23-43-05.png',0),('91frat','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg',1),('91frat','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png',1),('Aresi','/home/fiorix/Immagini/Tiw/campaigns/Esempio/105.png',1),('Aresi','/home/fiorix/Immagini/Tiw/campaigns/Esempio/5641774-desktop-wallpapers.jpg',1),('Aresi','/home/fiorix/Immagini/Tiw/campaigns/Esempio/BASZNI.png',0),('Aresi','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Computer-Wallpaper-18.jpg',0),('Aresi','/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1440-900-553248.jpg',1),('Aresi','/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1600-900-589443.jpg',1),('Aresi','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-01-03 15:18:35.png',0),('Aresi','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-05-19 23-43-05.png',1),('Aresi','/home/fiorix/Immagini/Tiw/campaigns/Esempio/url.png',0),('berenix','/home/fiorix/Immagini/Tiw/campaigns/Esempio/5641774-desktop-wallpapers.jpg',1),('berenix','/home/fiorix/Immagini/Tiw/campaigns/Esempio/BASZNI.png',0),('berenix','/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1440-900-553248.jpg',1),('berenix','/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1600-900-589443.jpg',1),('berenix','/home/fiorix/Immagini/Tiw/campaigns/Esempio/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg',1),('berenix','/home/fiorix/Immagini/Tiw/campaigns/Esempio/iso.png',0),('berenix','/home/fiorix/Immagini/Tiw/campaigns/Esempio/MATE PER LIA.png',0),('berenix','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-01-31 18:40:19.png',0),('berenix','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-05-19 23-43-05.png',0),('berenix','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-05-31 12-59-34.png',1),('berenix','/home/fiorix/Immagini/Tiw/campaigns/Esempio/url.png',0),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/105.png',0),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg',1),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/BASZNI.png',0),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg',1),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg',1),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg',1),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg',1),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/iso.png',0),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/MATE PER LIA.png',0),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-03 15:18:35.png',0),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png',1),('bwoah','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/url.png',0),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/105.png',0),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/5641774-desktop-wallpapers.jpg',1),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/BASZNI.png',0),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Computer-Wallpaper-18.jpg',1),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1440-900-553248.jpg',1),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1600-900-589443.jpg',1),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg',1),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/iso.png',0),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/MATE PER LIA.png',0),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-01-03 15:18:35.png',0),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-01-31 18:40:19.png',0),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-05-19 23-43-05.png',0),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-05-31 12-59-34.png',1),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/splinter_cell_6-wallpaper-1600x900.jpg',1),('CactusFrank','/home/fiorix/Immagini/Tiw/campaigns/Esempio/url.png',0),('Collx','/home/fiorix/Immagini/Tiw/campaigns/Esempio/5641774-desktop-wallpapers.jpg',0),('Collx','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Computer-Wallpaper-18.jpg',1),('Collx','/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1440-900-553248.jpg',1),('Collx','/home/fiorix/Immagini/Tiw/campaigns/Esempio/cropped-1600-900-589443.jpg',0),('Collx','/home/fiorix/Immagini/Tiw/campaigns/Esempio/iso.png',0),('Collx','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-05-19 23-43-05.png',1),('Collx','/home/fiorix/Immagini/Tiw/campaigns/Esempio/Schermata del 2017-05-31 12-59-34.png',1),('Collx','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg',1),('Collx','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg',1),('Collx','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/iso.png',0),('Collx','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/MATE PER LIA.png',0),('Collx','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-03 15:18:35.png',0),('Collx','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-31 18:40:19.png',0),('Collx','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-05-19 23-43-05.png',0),('Collx','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg',1),('Collx','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/TADAAAN.png',1),('Collx','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/url.png',0),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/105.png',0),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/5641774-desktop-wallpapers.jpg',1),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/BASZNI.png',0),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Computer-Wallpaper-18.jpg',1),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1440-900-553248.jpg',1),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/cropped-1600-900-589443.jpg',1),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/grand-theft-auto-v-game-hd-wallpaper-1920x1200-2008.jpg',1),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-03 15:18:35.png',0),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-31 18:40:19.png',0),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-05-19 23-43-05.png',0),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/splinter_cell_6-wallpaper-1600x900.jpg',1),('Roobi','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/url.png',0),('vr46','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/105.png',0),('vr46','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/BASZNI.png',0),('vr46','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/iso.png',0),('vr46','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/MATE PER LIA.png',0),('vr46','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-03 15:18:35.png',0),('vr46','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-31 18:40:19.png',0),('vr46','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-05-19 23-43-05.png',0),('vr46','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/url.png',0),('zeb89','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/105.png',0),('zeb89','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/BASZNI.png',0),('zeb89','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/iso.png',0),('zeb89','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/MATE PER LIA.png',0),('zeb89','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-03 15:18:35.png',0),('zeb89','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-01-31 18:40:19.png',0),('zeb89','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/Schermata del 2017-05-19 23-43-05.png',0),('zeb89','/home/fiorix/Immagini/Tiw/campaigns/SuperAlg/url.png',0);
/*!40000 ALTER TABLE `rating` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Temporary table structure for view `rating_stats`
--

DROP TABLE IF EXISTS `rating_stats`;
/*!50001 DROP VIEW IF EXISTS `rating_stats`*/;
SET @saved_cs_client     = @@character_set_client;
SET character_set_client = utf8;
/*!50001 CREATE VIEW `rating_stats` AS SELECT 
 1 AS `image`,
 1 AS `number_of_ratings`,
 1 AS `positive_ratings`,
 1 AS `negative_ratings`,
 1 AS `approved`*/;
SET character_set_client = @saved_cs_client;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `user` (
  `first_name` varchar(64) NOT NULL,
  `last_name` varchar(64) NOT NULL,
  `username` varchar(64) NOT NULL,
  `email` varchar(64) NOT NULL,
  `password` varchar(64) NOT NULL,
  `role` varchar(16) NOT NULL,
  PRIMARY KEY (`username`),
  UNIQUE KEY `username_UNIQUE` (`username`),
  UNIQUE KEY `email_UNIQUE` (`email`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
INSERT INTO `user` VALUES ('Francesco','Barbagallo','91frat','1','tiw','worker'),('Jessica','Aresi','Aresi','2','tiw','worker'),('Matteo','Radice','aristos','3','tiw','manager'),('Berenice','Chimienti','berenix','4','tiw','worker'),('Kimi','Raikkonen','bwoah','20','tiw','worker'),('Francesco','Magliocca','CactusFrank','5','tiw','worker'),('Giulia','Colace','Collx','6','tiw','worker'),('Filippo','Libero','fil','a@gmail.com','a','manager'),('Alessandro','Fiorillo','FiorixF1','7','tiw','manager'),('Alessandra','Caporaso','Lexy','8','tiw','worker'),('Adrian','Fartade','link2universe','21','tiw','worker'),('Sofia','Masciocchi','Mashokki','9','tiw','worker'),('Nelly','Pinko','Nelly','10','tiw','worker'),('q','w','q','q@q.com','q','worker'),('Raffaele','Scaccianoce','Raf','11','tiw','worker'),('René','Caporaso','Rene','12','tiw','worker'),('Roobi','Roobi','Roobi','13','tiw','worker'),('Gabriele','Stocco','Stoucks','14','tiw','manager'),('Alessandro','Muraca','Ultra AleM','15','tiw','worker'),('Valentino','Rossi','vr46','16','tiw','worker'),('Yuri','Varrella','yuri98','17','tiw','worker'),('Zeb','89','zeb89','18','tiw','worker'),('Marco','Mazzoli','zoo','22','tiw','worker'),('Zsofi','Zimonyi','Zsofi','19','tiw','worker');
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `worker_campaign`
--

DROP TABLE IF EXISTS `worker_campaign`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `worker_campaign` (
  `worker` varchar(64) NOT NULL,
  `campaign` varchar(64) NOT NULL,
  `selection_task` tinyint(1) NOT NULL,
  `annotation_task` tinyint(1) NOT NULL,
  PRIMARY KEY (`worker`,`campaign`),
  KEY `campaign` (`campaign`),
  CONSTRAINT `worker_campaign_ibfk_1` FOREIGN KEY (`worker`) REFERENCES `user` (`username`) ON DELETE NO ACTION ON UPDATE CASCADE,
  CONSTRAINT `worker_campaign_ibfk_2` FOREIGN KEY (`campaign`) REFERENCES `campaign` (`name`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `worker_campaign`
--

LOCK TABLES `worker_campaign` WRITE;
/*!40000 ALTER TABLE `worker_campaign` DISABLE KEYS */;
INSERT INTO `worker_campaign` VALUES ('91frat','Esempio',1,0),('91frat','prova',1,0),('91frat','SuperAlg',1,0),('Aresi','Esempio',1,0),('Aresi','prova',1,0),('Aresi','SuperAlg',1,0),('berenix','Esempio',1,0),('berenix','prova',1,0),('berenix','SuperAlg',1,0),('bwoah','Esempio',1,0),('bwoah','prova',1,0),('bwoah','SuperAlg',1,0),('CactusFrank','Esempio',1,0),('CactusFrank','prova',0,1),('CactusFrank','SuperAlg',1,0),('Collx','Esempio',1,0),('Collx','prova',0,1),('Collx','SuperAlg',1,0),('Lexy','Esempio',1,0),('Lexy','prova',0,1),('Lexy','SuperAlg',0,1),('link2universe','prova',0,1),('link2universe','SuperAlg',0,1),('Mashokki','Esempio',1,0),('Mashokki','SuperAlg',0,1),('Nelly','Esempio',1,0),('Nelly','SuperAlg',0,1),('Raf','Esempio',0,1),('Raf','SuperAlg',0,1),('Rene','Esempio',0,1),('Rene','SuperAlg',0,1),('Roobi','Esempio',0,1),('Roobi','SuperAlg',1,0),('Ultra AleM','Esempio',0,1),('Ultra AleM','SuperAlg',0,1),('vr46','Esempio',0,1),('vr46','SuperAlg',1,0),('yuri98','Esempio',0,1),('yuri98','SuperAlg',0,1),('zeb89','Esempio',0,1),('zeb89','SuperAlg',1,0),('zoo','SuperAlg',0,1),('Zsofi','Esempio',0,1);
/*!40000 ALTER TABLE `worker_campaign` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Current Database: `tiw`
--

USE `tiw`;

--
-- Final view structure for view `annotation_stats`
--

/*!50001 DROP VIEW IF EXISTS `annotation_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `annotation_stats` AS select `i`.`url` AS `image`,ifnull(count(`a`.`image`),0) AS `number_of_annotations` from (`image` `i` left join `annotation` `a` on((`a`.`image` = `i`.`url`))) group by `i`.`url` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `image_statistics`
--

/*!50001 DROP VIEW IF EXISTS `image_statistics`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `image_statistics` AS select `rs`.`image` AS `image`,`rs`.`positive_ratings` AS `positive_ratings`,`rs`.`negative_ratings` AS `negative_ratings`,`rs`.`approved` AS `approved`,`rs`.`number_of_ratings` AS `number_of_ratings`,`as`.`number_of_annotations` AS `number_of_annotations`,(ifnull(`prc`.`pending_request_counter`,0) + ifnull(`rs`.`number_of_ratings`,0)) AS `rating_request_counter`,(ifnull(`pac`.`pending_request_counter`,0) + ifnull(`as`.`number_of_annotations`,0)) AS `annotation_request_counter` from ((((`image` `i` left join `rating_stats` `rs` on((`i`.`url` = `rs`.`image`))) left join `annotation_stats` `as` on((`rs`.`image` = `as`.`image`))) left join `pending_rating_counter` `prc` on((`rs`.`image` = `prc`.`image`))) left join `pending_annotation_counter` `pac` on((`rs`.`image` = `pac`.`image`))) group by `rs`.`image` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pending_annotation_counter`
--

/*!50001 DROP VIEW IF EXISTS `pending_annotation_counter`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `pending_annotation_counter` AS select `i`.`url` AS `image`,count(0) AS `pending_request_counter` from (`pending_annotation` `pa` join `image` `i` on((`i`.`url` = `pa`.`image`))) group by `pa`.`image` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `pending_rating_counter`
--

/*!50001 DROP VIEW IF EXISTS `pending_rating_counter`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `pending_rating_counter` AS select `i`.`url` AS `image`,count(0) AS `pending_request_counter` from (`pending_rating` `pr` join `image` `i` on((`i`.`url` = `pr`.`image`))) group by `pr`.`image` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;

--
-- Final view structure for view `rating_stats`
--

/*!50001 DROP VIEW IF EXISTS `rating_stats`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8 */;
/*!50001 SET character_set_results     = utf8 */;
/*!50001 SET collation_connection      = utf8_general_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`root`@`localhost` SQL SECURITY DEFINER */
/*!50001 VIEW `rating_stats` AS select `i`.`url` AS `image`,ifnull(count(`r`.`rating`),0) AS `number_of_ratings`,ifnull(sum(`r`.`rating`),0) AS `positive_ratings`,ifnull((count(`r`.`rating`) - sum(`r`.`rating`)),0) AS `negative_ratings`,ifnull((sum(`r`.`rating`) >= `c`.`least_positive_ratings`),0) AS `approved` from ((`image` `i` left join `rating` `r` on((`r`.`image` = `i`.`url`))) join `campaign` `c` on((`i`.`campaign` = `c`.`name`))) group by `i`.`url` */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2017-07-04 12:20:47
