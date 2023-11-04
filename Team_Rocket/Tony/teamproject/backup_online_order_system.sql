-- MySQL dump 10.13  Distrib 8.0.35, for Linux (x86_64)
--
-- Host: localhost    Database: online_order_system
-- ------------------------------------------------------
-- Server version	8.0.35-0ubuntu0.20.04.1

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `Address`
--

DROP TABLE IF EXISTS `Address`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Address` (
  `addressID` int NOT NULL AUTO_INCREMENT,
  `customerID` int DEFAULT NULL,
  `addressType` enum('Shipping','Billing') NOT NULL,
  `addressLine1` varchar(255) NOT NULL,
  `addressLine2` varchar(255) DEFAULT NULL,
  `city` varchar(100) DEFAULT NULL,
  `state` varchar(100) DEFAULT NULL,
  `zipCode` varchar(10) DEFAULT NULL,
  `country` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`addressID`),
  KEY `customerID` (`customerID`),
  CONSTRAINT `Address_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `Customer` (`customerID`)
) ENGINE=InnoDB AUTO_INCREMENT=17 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Address`
--

LOCK TABLES `Address` WRITE;
/*!40000 ALTER TABLE `Address` DISABLE KEYS */;
INSERT INTO `Address` VALUES (1,1,'Shipping','123 Main St',NULL,'Springfield','IL','62701','USA'),(2,1,'Billing','456 Elm St',NULL,'Springfield','IL','62701','USA'),(5,1,'Shipping','3004 19th Street','','Eureka','California','95501','United States'),(6,1,'Shipping','3004 19th Street','','Eureka','California','95501','United States'),(7,1,'Shipping','3004 19th Street','','Eureka','California','95501','United States'),(8,1,'Shipping','3004 19th Street','','Eureka','California','95501','United States'),(9,1,'Shipping','3004 19th Street','','Eureka','California','95501','United States'),(10,1,'Shipping','3009 20th Street   ','Space D','Eureka','California','95501','United States'),(12,17,'Shipping','2679 Homeboy Way','','Jackson','CA','95678','United States'),(13,17,'Shipping','2679 Homeboy Way','','Jackson','CA','95678','USA'),(14,19,'Shipping','1000 Super Way','Space #S','Arcata','CA','95505','USA'),(15,20,'Shipping','1234 Pokestreet','','Lavender Town','Kanto ','123123','Pokeworld'),(16,1,'Shipping','3004 19th Street','','Eureka','California','95501','United States');
/*!40000 ALTER TABLE `Address` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Catalog`
--

DROP TABLE IF EXISTS `Catalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Catalog` (
  `SKU` int NOT NULL AUTO_INCREMENT,
  `itemName` varchar(255) NOT NULL,
  `itemDescription` text,
  `price` decimal(10,2) NOT NULL,
  `availableQuantity` int NOT NULL,
  `imageUrl` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Catalog`
--

LOCK TABLES `Catalog` WRITE;
/*!40000 ALTER TABLE `Catalog` DISABLE KEYS */;
INSERT INTO `Catalog` VALUES (1,'Laptop','Dell Inspiron 15-inch',800.00,7,'https://storage.googleapis.com/projstorage/ImageCache/Laptop_Trans.png'),(2,'Smartphone','PokePhone',700.00,11,'https://storage.googleapis.com/projstorage/ImageCache/PokemonPhone_Trans.png'),(3,'Headphones','PokeBalls',300.00,15,'https://storage.googleapis.com/projstorage/ImageCache/PokemonHeadPhone_Trans.png'),(4,'Pokemon','Cubone',15200.00,3,'https://storage.googleapis.com/projstorage/ImageCache/Cubone_Trans.png');
/*!40000 ALTER TABLE `Catalog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Customer`
--

DROP TABLE IF EXISTS `Customer`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Customer` (
  `customerID` int NOT NULL AUTO_INCREMENT,
  `userID` int DEFAULT NULL,
  `name` varchar(255) NOT NULL,
  `creditCard` varchar(19) DEFAULT NULL,
  `city` varchar(255) NOT NULL DEFAULT '',
  `state` varchar(255) NOT NULL DEFAULT '',
  `address` varchar(255) NOT NULL DEFAULT '',
  `zipCode` varchar(10) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customerID`),
  UNIQUE KEY `email` (`email`),
  KEY `userID` (`userID`),
  CONSTRAINT `Customer_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `User` (`userID`)
) ENGINE=InnoDB AUTO_INCREMENT=21 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customer`
--

LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */;
INSERT INTO `Customer` VALUES (1,1,'Tony','4111111111111122','','','',NULL,NULL),(11,19,'Goat','6666666666666666','Goaterton','Ca','666 Goat Way',NULL,'bahhh@gmail.com'),(12,20,'Cheyenne','1234123412341234','Eureka','California','123 Main Street',NULL,'fakemail@gmail.com'),(13,21,'Jonathan Thang','1234 5678 9101 1213','Oakland','CA','1234 Rocket Street',NULL,'jt346@humboldt.edu'),(14,23,'Kiddo','1234123412341234','Arcata','Ca','2002 20th Street',NULL,'kid@gmail.com'),(15,24,'abigail j','1101111010101101','goat town','goat state','1111 goat street',NULL,'abigail@goatemail.com'),(16,25,'Plane Jane','1234123412341234','Eureka','California','3030 26th Street',NULL,'PJane@gmail.com'),(17,26,'John Wick','1234123412341234','Eureka','California','3070 27th Street',NULL,'JW@gmail.com'),(18,27,'Slut Muffin','1234123412341234','Eureka','California','3069 69th Street','95501','HotSauce@gmail.com'),(19,28,'Super Man','1234123412341234','Arcata','CA','1000 Super Way','95505','CKent@mymail.com'),(20,29,'I love pokemon','123412341234','Pallet Town.','Kanto','1234 Pokestreet','10293','pallettown@gmail.com');
/*!40000 ALTER TABLE `Customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `CustomerSubscriptions`
--

DROP TABLE IF EXISTS `CustomerSubscriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CustomerSubscriptions` (
  `subscriptionID` int NOT NULL AUTO_INCREMENT,
  `customerID` int NOT NULL,
  `templateID` int DEFAULT NULL,
  `startDate` date NOT NULL,
  `endDate` date NOT NULL,
  PRIMARY KEY (`subscriptionID`),
  KEY `customerID` (`customerID`),
  KEY `templateID` (`templateID`),
  CONSTRAINT `CustomerSubscriptions_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `Customer` (`customerID`),
  CONSTRAINT `CustomerSubscriptions_ibfk_2` FOREIGN KEY (`templateID`) REFERENCES `SubscriptionTemplate` (`templateID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CustomerSubscriptions`
--

LOCK TABLES `CustomerSubscriptions` WRITE;
/*!40000 ALTER TABLE `CustomerSubscriptions` DISABLE KEYS */;
/*!40000 ALTER TABLE `CustomerSubscriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LineItems`
--

DROP TABLE IF EXISTS `LineItems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LineItems` (
  `lineItemID` int NOT NULL AUTO_INCREMENT,
  `orderID` int DEFAULT NULL,
  `SKU` int DEFAULT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`lineItemID`),
  KEY `orderID` (`orderID`),
  KEY `SKU` (`SKU`),
  CONSTRAINT `LineItems_ibfk_2` FOREIGN KEY (`SKU`) REFERENCES `Catalog` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LineItems`
--

LOCK TABLES `LineItems` WRITE;
/*!40000 ALTER TABLE `LineItems` DISABLE KEYS */;
INSERT INTO `LineItems` VALUES (1,19,1,1),(2,28,3,1),(3,31,3,1),(4,32,2,1),(5,37,3,2);
/*!40000 ALTER TABLE `LineItems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OrderDetails`
--

DROP TABLE IF EXISTS `OrderDetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OrderDetails` (
  `lineItemID` int NOT NULL AUTO_INCREMENT,
  `orderID` int DEFAULT NULL,
  `SKU` int DEFAULT NULL,
  `quantity` int NOT NULL,
  `priceAtTimeOfOrder` decimal(10,2) NOT NULL,
  PRIMARY KEY (`lineItemID`),
  KEY `orderID` (`orderID`),
  KEY `SKU` (`SKU`),
  CONSTRAINT `OrderDetails_ibfk_1` FOREIGN KEY (`orderID`) REFERENCES `Orders` (`orderID`),
  CONSTRAINT `OrderDetails_ibfk_2` FOREIGN KEY (`SKU`) REFERENCES `Catalog` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OrderDetails`
--

LOCK TABLES `OrderDetails` WRITE;
/*!40000 ALTER TABLE `OrderDetails` DISABLE KEYS */;
INSERT INTO `OrderDetails` VALUES (1,42,2,1,700.00);
/*!40000 ALTER TABLE `OrderDetails` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Orders`
--

DROP TABLE IF EXISTS `Orders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Orders` (
  `orderID` int NOT NULL AUTO_INCREMENT,
  `customerID` int DEFAULT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `tax` decimal(10,2) DEFAULT NULL,
  `orderStatus` enum('PENDING','SHIPPED','INVOICED','RETURNED','SUBSCRIBED') DEFAULT NULL,
  PRIMARY KEY (`orderID`),
  KEY `customerID` (`customerID`),
  CONSTRAINT `Orders_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `Customer` (`customerID`)
) ENGINE=InnoDB AUTO_INCREMENT=43 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Orders`
--

LOCK TABLES `Orders` WRITE;
/*!40000 ALTER TABLE `Orders` DISABLE KEYS */;
INSERT INTO `Orders` VALUES (1,1,880.00,80.00,'PENDING'),(8,1,300.00,30.00,'PENDING'),(9,1,1400.00,140.00,'PENDING'),(10,1,1600.00,160.00,'PENDING'),(11,1,15200.00,1520.00,'PENDING'),(17,1,300.00,30.00,'PENDING'),(18,1,27.99,2.80,'PENDING'),(19,1,800.00,80.00,'PENDING'),(20,1,35.99,3.60,'PENDING'),(21,1,9.99,1.00,'SUBSCRIBED'),(22,1,35.99,3.60,'SUBSCRIBED'),(28,17,300.00,30.00,'PENDING'),(30,17,35.99,3.60,'SUBSCRIBED'),(31,17,300.00,30.00,'PENDING'),(32,19,700.00,70.00,'PENDING'),(33,19,18.99,1.90,'SUBSCRIBED'),(34,1,9.99,1.00,'SUBSCRIBED'),(35,1,9.99,1.00,'SUBSCRIBED'),(36,17,9.99,1.00,'SUBSCRIBED'),(37,20,600.00,60.00,'PENDING'),(38,20,35.99,3.60,'SUBSCRIBED'),(39,20,35.99,3.60,'SUBSCRIBED'),(42,1,700.00,70.00,'PENDING');
/*!40000 ALTER TABLE `Orders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `Shipment`
--

DROP TABLE IF EXISTS `Shipment`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `Shipment` (
  `shipmentID` int NOT NULL AUTO_INCREMENT,
  `lineItemID` int DEFAULT NULL,
  `status` enum('PICK','PACK','SHIP') DEFAULT NULL,
  PRIMARY KEY (`shipmentID`),
  KEY `Shipment_ibfk_1` (`lineItemID`),
  CONSTRAINT `Shipment_ibfk_1` FOREIGN KEY (`lineItemID`) REFERENCES `LineItems` (`lineItemID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Shipment`
--

LOCK TABLES `Shipment` WRITE;
/*!40000 ALTER TABLE `Shipment` DISABLE KEYS */;
/*!40000 ALTER TABLE `Shipment` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SubscriptionOrders`
--

DROP TABLE IF EXISTS `SubscriptionOrders`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SubscriptionOrders` (
  `subscriptionOrderID` int NOT NULL AUTO_INCREMENT,
  `templateID` int DEFAULT NULL,
  `orderID` int DEFAULT NULL,
  `status` varchar(100) DEFAULT 'Active',
  `start_time` datetime DEFAULT CURRENT_TIMESTAMP,
  `end_time` datetime DEFAULT NULL,
  `planName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`subscriptionOrderID`),
  KEY `templateID` (`templateID`),
  KEY `SubscriptionOrders_ibfk_2` (`orderID`),
  CONSTRAINT `SubscriptionOrders_ibfk_2` FOREIGN KEY (`orderID`) REFERENCES `Orders` (`orderID`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SubscriptionOrders`
--

LOCK TABLES `SubscriptionOrders` WRITE;
/*!40000 ALTER TABLE `SubscriptionOrders` DISABLE KEYS */;
INSERT INTO `SubscriptionOrders` VALUES (1,6,20,'Active','2023-10-28 22:43:13','2024-10-22 22:43:13','Gold Plan'),(2,3,21,'Active','2023-10-28 22:54:19','2024-01-26 22:54:19','Red Plan'),(3,6,22,'Active','2023-10-28 23:25:19','2024-10-22 23:25:19','Gold Plan'),(4,6,30,'Active','2023-10-30 13:47:13','2024-10-24 13:47:13','Gold Plan'),(5,4,33,'Active','2023-10-30 13:56:17','2024-04-27 13:56:17','Blue Plan'),(6,3,34,'Active','2023-10-30 23:54:38','2024-01-28 23:54:38','Red Plan'),(7,3,35,'Active','2023-10-30 23:55:03','2024-01-28 23:55:03','Red Plan'),(8,3,36,'Active','2023-10-31 01:25:11','2024-01-29 01:25:11','Red Plan'),(9,6,38,'Active','2023-10-31 02:53:23','2024-10-25 02:53:23','Gold Plan'),(10,6,39,'Active','2023-10-31 02:53:30','2024-10-25 02:53:30','Gold Plan');
/*!40000 ALTER TABLE `SubscriptionOrders` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SubscriptionTemplate`
--

DROP TABLE IF EXISTS `SubscriptionTemplate`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SubscriptionTemplate` (
  `templateID` int NOT NULL AUTO_INCREMENT,
  `SKU` int DEFAULT NULL,
  `frequencyInMonths` int NOT NULL,
  `duration` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `planName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`templateID`),
  KEY `SKU` (`SKU`),
  CONSTRAINT `SubscriptionTemplate_ibfk_1` FOREIGN KEY (`SKU`) REFERENCES `Catalog` (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SubscriptionTemplate`
--

LOCK TABLES `SubscriptionTemplate` WRITE;
/*!40000 ALTER TABLE `SubscriptionTemplate` DISABLE KEYS */;
INSERT INTO `SubscriptionTemplate` VALUES (3,NULL,3,3,9.99,'Red Plan'),(4,NULL,6,6,18.99,'Blue Plan'),(5,NULL,9,9,27.99,'Purple Plan'),(6,NULL,12,12,35.99,'Gold Plan');
/*!40000 ALTER TABLE `SubscriptionTemplate` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `User`
--

DROP TABLE IF EXISTS `User`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `User` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `role` enum('standard','admin','employee') NOT NULL DEFAULT 'standard',
  PRIMARY KEY (`userID`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=30 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (1,'Tony','pbkdf2:sha256:600000$UzLpvLjG4Hpj9BVu$3875971eb63c9001fbdabec6464ae3d3bc1e89c8c6942d15180b26f6be3b4b20','admin'),(19,'Goat','pbkdf2:sha256:600000$bTK4h6O8Mx6LoJfZ$b9048d2d584c6ad036c8fd44b75a823d5fd8cda113c1e22e4ca40e9eef5aa60c','standard'),(20,'cheyenne1','pbkdf2:sha256:600000$6eYdlcZn0hCKeGq6$b156ab028e222e997d2357f59e0df10f20c2772b7f723d23453e7835d005a197','standard'),(21,'jt346@humboldt.edu','pbkdf2:sha256:600000$jJHNV4mSsj2wnN0F$f83bfab6fd5ae15c39a77f0bc4074c50a7532cb674a7d2dc026f03bb06c338d4','standard'),(22,'Test','pbkdf2:sha256:600000$QzFzp0DWrkvgZnxN$98bafb9349467e8875f17894b7a854f00e606ce94cf63c96c8f66a505582b15e','standard'),(23,'Kid','pbkdf2:sha256:600000$Mp1Wqmr5buJhiJyo$6cc2371264e1ffbef64e55c8f6572182e154c488968b60582bb8aca2cc1d3c7d','standard'),(24,'abigail.j','pbkdf2:sha256:600000$QkHx3Wf9104AEFG7$5e3cd7a671b566458eaa2aa0e3258585db83e381355759f365dd366ddc0613ba','standard'),(25,'Test1','pbkdf2:sha256:600000$DZK6m5PcHP6AlVLp$738fe6c58597bf6b8b25ef6c0f7727532f5f3bc28523e4f6912c5c8a2d993ebb','standard'),(26,'Test2','pbkdf2:sha256:600000$hWnklpokc0xsFWsQ$6fc450df683ba3b65204ef3df13f0fd3547035314e1d0796f1f218972c5f564f','standard'),(27,'Test3','pbkdf2:sha256:600000$UzOQP2PzvteQ4Wed$1dea1420cf292d5b8821303f47eca8024f1742bcd9797abbf75898ad7e710d7f','standard'),(28,'Xotic96','pbkdf2:sha256:600000$a81RUdju4VgMvWXE$0bbe6f87619e7ca2b3911abf7c922abdd26a4845105254aac08ae07265a6d27a','standard'),(29,'12345','pbkdf2:sha256:600000$zjjeon2x6yUOK09Z$2dd27a72d06bf23fdf5ea42eb3ca7be00520ed0e667bc620a685e27244dcde6f','admin');
/*!40000 ALTER TABLE `User` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `alembic_version`
--

DROP TABLE IF EXISTS `alembic_version`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `alembic_version` (
  `version_num` varchar(32) NOT NULL,
  PRIMARY KEY (`version_num`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `alembic_version`
--

LOCK TABLES `alembic_version` WRITE;
/*!40000 ALTER TABLE `alembic_version` DISABLE KEYS */;
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `catalog`
--

DROP TABLE IF EXISTS `catalog`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `catalog` (
  `SKU` int NOT NULL AUTO_INCREMENT,
  `itemName` varchar(255) NOT NULL,
  `itemDescription` text,
  `price` decimal(10,2) NOT NULL,
  `availableQuantity` int NOT NULL,
  PRIMARY KEY (`SKU`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `catalog`
--

LOCK TABLES `catalog` WRITE;
/*!40000 ALTER TABLE `catalog` DISABLE KEYS */;
/*!40000 ALTER TABLE `catalog` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `user`
--

DROP TABLE IF EXISTS `user`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `user` (
  `userID` int NOT NULL AUTO_INCREMENT,
  `username` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `user`
--

LOCK TABLES `user` WRITE;
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-10-31 15:37:13
