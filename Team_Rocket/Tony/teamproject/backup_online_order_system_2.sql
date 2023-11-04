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
  `customerID` int NOT NULL,
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
) ENGINE=InnoDB AUTO_INCREMENT=4 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Address`
--

LOCK TABLES `Address` WRITE;
/*!40000 ALTER TABLE `Address` DISABLE KEYS */;
INSERT INTO `Address` VALUES (2,1,'Shipping','3009 20th Street   ','Space D','Eureka','California','95501','United States'),(3,1,'Shipping','3009 21st Street','Space B','Eureka','California','95501','United States');
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
  `imageUrl` varchar(512) DEFAULT NULL,
  PRIMARY KEY (`SKU`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Catalog`
--

LOCK TABLES `Catalog` WRITE;
/*!40000 ALTER TABLE `Catalog` DISABLE KEYS */;
INSERT INTO `Catalog` VALUES (1,'Laptop','Dell Inspiron 15-inch',800.00,20,'https://storage.googleapis.com/projstorage/ImageCache/Laptop_Trans.png'),(2,'Smartphone','PokePhone',700.00,18,'https://storage.googleapis.com/projstorage/ImageCache/PokemonPhone_Trans.png'),(3,'Headphones','PokeBalls',300.00,20,'https://storage.googleapis.com/projstorage/ImageCache/PokemonHeadPhone_Trans.png'),(4,'Pokemon','Cubone',15200.00,19,'https://storage.googleapis.com/projstorage/ImageCache/Cubone_Trans.png');
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
  `userID` int NOT NULL,
  `name` varchar(255) NOT NULL,
  `creditCard` varchar(19) DEFAULT NULL,
  `city` varchar(255) DEFAULT NULL,
  `state` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `zipCode` varchar(10) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`customerID`),
  UNIQUE KEY `email` (`email`),
  KEY `userID` (`userID`),
  CONSTRAINT `Customer_ibfk_1` FOREIGN KEY (`userID`) REFERENCES `User` (`userID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Customer`
--

LOCK TABLES `Customer` WRITE;
/*!40000 ALTER TABLE `Customer` DISABLE KEYS */;
INSERT INTO `Customer` VALUES (1,1,'Tony Ray','1234123412341234','Eureka','California','3069 20th Street','95508','centralvalleydonk@gmail.com');
/*!40000 ALTER TABLE `Customer` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `LineItems`
--

DROP TABLE IF EXISTS `LineItems`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `LineItems` (
  `lineItemID` int NOT NULL AUTO_INCREMENT,
  `orderID` int NOT NULL,
  `SKU` int NOT NULL,
  `quantity` int NOT NULL,
  PRIMARY KEY (`lineItemID`),
  KEY `SKU` (`SKU`),
  KEY `orderID` (`orderID`),
  CONSTRAINT `LineItems_ibfk_1` FOREIGN KEY (`SKU`) REFERENCES `Catalog` (`SKU`),
  CONSTRAINT `LineItems_ibfk_2` FOREIGN KEY (`orderID`) REFERENCES `Orders` (`orderID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `LineItems`
--

LOCK TABLES `LineItems` WRITE;
/*!40000 ALTER TABLE `LineItems` DISABLE KEYS */;
/*!40000 ALTER TABLE `LineItems` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `OrderDetails`
--

DROP TABLE IF EXISTS `OrderDetails`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `OrderDetails` (
  `orderDetailID` int NOT NULL AUTO_INCREMENT,
  `orderID` int NOT NULL,
  `SKU` int NOT NULL,
  `itemName` varchar(255) NOT NULL,
  `itemDescription` text,
  `quantity` int NOT NULL,
  `priceAtTimeOfOrder` decimal(10,2) NOT NULL,
  PRIMARY KEY (`orderDetailID`),
  KEY `SKU` (`SKU`),
  KEY `orderID` (`orderID`),
  CONSTRAINT `OrderDetails_ibfk_1` FOREIGN KEY (`SKU`) REFERENCES `Catalog` (`SKU`),
  CONSTRAINT `OrderDetails_ibfk_2` FOREIGN KEY (`orderID`) REFERENCES `Orders` (`orderID`)
) ENGINE=InnoDB AUTO_INCREMENT=3 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `OrderDetails`
--

LOCK TABLES `OrderDetails` WRITE;
/*!40000 ALTER TABLE `OrderDetails` DISABLE KEYS */;
INSERT INTO `OrderDetails` VALUES (1,2,4,'Pokemon','Cubone',1,15200.00),(2,4,2,'Smartphone','PokePhone',2,700.00);
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
  `customerID` int NOT NULL,
  `total` decimal(10,2) DEFAULT NULL,
  `tax` decimal(10,2) DEFAULT NULL,
  `orderStatus` enum('PENDING','SHIPPED','INVOICED','RETURNED','SUBSCRIBED') DEFAULT NULL,
  PRIMARY KEY (`orderID`),
  KEY `customerID` (`customerID`),
  CONSTRAINT `Orders_ibfk_1` FOREIGN KEY (`customerID`) REFERENCES `Customer` (`customerID`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `Orders`
--

LOCK TABLES `Orders` WRITE;
/*!40000 ALTER TABLE `Orders` DISABLE KEYS */;
INSERT INTO `Orders` VALUES (2,1,15200.00,1520.00,'PENDING'),(3,1,35.99,3.60,'SUBSCRIBED'),(4,1,1400.00,140.00,'PENDING');
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
  `lineItemID` int NOT NULL,
  `status` enum('PICK','PACK','SHIP') DEFAULT NULL,
  PRIMARY KEY (`shipmentID`),
  KEY `lineItemID` (`lineItemID`),
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
  `status` varchar(100) DEFAULT NULL,
  `start_time` datetime DEFAULT NULL,
  `end_time` datetime DEFAULT NULL,
  `planName` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`subscriptionOrderID`),
  KEY `orderID` (`orderID`),
  KEY `templateID` (`templateID`),
  CONSTRAINT `SubscriptionOrders_ibfk_1` FOREIGN KEY (`orderID`) REFERENCES `Orders` (`orderID`),
  CONSTRAINT `SubscriptionOrders_ibfk_2` FOREIGN KEY (`templateID`) REFERENCES `SubscriptionTemplate` (`templateID`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SubscriptionOrders`
--

LOCK TABLES `SubscriptionOrders` WRITE;
/*!40000 ALTER TABLE `SubscriptionOrders` DISABLE KEYS */;
INSERT INTO `SubscriptionOrders` VALUES (1,6,3,'Active','2023-10-31 16:34:42','2024-10-25 16:34:42','Gold Plan');
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
  `planName` varchar(255) NOT NULL,
  `SKU` int NOT NULL,
  `frequencyInMonths` int NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `duration` int NOT NULL,
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
INSERT INTO `SubscriptionTemplate` VALUES (3,'Red Plan',1,3,9.99,3),(4,'Blue Plan',2,6,18.99,6),(5,'Purple Plan',3,9,27.99,9),(6,'Gold Plan',4,12,35.99,12);
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
  `role` varchar(10) DEFAULT NULL,
  PRIMARY KEY (`userID`),
  UNIQUE KEY `username` (`username`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `User`
--

LOCK TABLES `User` WRITE;
/*!40000 ALTER TABLE `User` DISABLE KEYS */;
INSERT INTO `User` VALUES (1,'Admin','pbkdf2:sha256:600000$rrntcsCrhAtuU5bL$59d9e63b9645323619b50e4051fbdcf59c5bc0961f75f9dd7762247c96897f54','admin');
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
INSERT INTO `alembic_version` VALUES ('ac32c7328a2f');
/*!40000 ALTER TABLE `alembic_version` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-11-04 16:37:08
