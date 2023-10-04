-- Dropping sakila_star database if already exist
DROP DATABASE IF EXISTS sakila_star;

-- Creating sakila_star database
CREATE DATABASE sakila_star;

-- Using sakila_star database
USE sakila_star;

-- Save old configuration and set new configuration
SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- Create Dimention Customer Tables
-- -----------------------------------------------------
-- Table `sakila_star`.`dim_customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_star`.`dim_customer` (
    `customer_key` INT(8) NOT NULL AUTO_INCREMENT,
    `customer_last_update` DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00',
    `customer_id` INT(8) NULL DEFAULT NULL,
    `customer_first_name` VARCHAR(45) NULL DEFAULT NULL,
    `customer_last_name` VARCHAR(45) NULL DEFAULT NULL,
    `customer_email` VARCHAR(64) NULL DEFAULT NULL,
    `customer_active` CHAR(3) NULL DEFAULT NULL,
    `customer_address_id` INT(8) NULL DEFAULT NULL,
    `customer_address` VARCHAR(64) NULL DEFAULT NULL,
    `customer_district` VARCHAR(20) NULL DEFAULT NULL,
    `customer_city_id` INT(8) NULL DEFAULT NULL,
    `customer_city` VARCHAR(50) NULL DEFAULT NULL,
    `customer_country_id` INT(8) NULL DEFAULT NULL,
    `customer_country` VARCHAR(50) NULL DEFAULT NULL,
    `customer_postal_code` VARCHAR(50) NULL DEFAULT NULL,
    `customer_phone` VARCHAR(20) NULL DEFAULT NULL,
    `customer_location` GEOMETRY NULL DEFAULT NULL,
    `customer_create_date` DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00',
    PRIMARY KEY (`customer_key`),
    KEY idx_customer_id (customer_id),
    KEY idx_address_id (customer_address_id),
    KEY idx_city_id (customer_city_id),
    KEY idx_country_id (customer_country_id),
    INDEX `customer_id` USING BTREE (`customer_id`) VISIBLE)
AUTO_INCREMENT = 1;

-- Insert data from sakila database to sakila_star database with new architecture
INSERT INTO sakila_star.dim_customer(customer_key,customer_last_update,customer_id,
                                     customer_first_name,customer_last_name,customer_email,
                                     customer_active,customer_address_id,customer_address,
                                     customer_district,customer_city_id,
                                     customer_city,customer_country_id,customer_country,
                                     customer_postal_code,customer_phone,
                                     customer_location,customer_create_date)
SELECT NULL, SCUS.last_update, SCUS.customer_id, SCUS.first_name, SCUS.last_name, SCUS.email, SCUS.active, SCUS.address_id,
SADD.address, SADD.district, SADD.city_id, SCI.city, SCI.country_id, SCO.country, SADD.postal_code, SADD.phone, SADD.location,
SCUS.create_date
FROM sakila.customer AS SCUS
INNER JOIN sakila.address AS SADD ON SCUS.address_id = SADD.address_id
INNER JOIN sakila.city AS SCI ON SADD.city_id = SCI.city_id
INNER JOIN sakila.country AS SCO ON SCI.country_id = SCO.country_id;

-- Create Dimention Store Tables
-- -----------------------------------------------------
-- Table `sakila_star`.`dim_store`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_star`.`dim_store` (
    `store_key` INT(8) NOT NULL AUTO_INCREMENT,
    `store_last_update` DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00',
    `store_id` INT(8) NULL DEFAULT NULL,
    `store_address_id` INT(8) NULL DEFAULT NULL,
    `store_address` VARCHAR(64) NULL DEFAULT NULL,
    `store_district` VARCHAR(20) NULL DEFAULT NULL,
    `store_city_id` INT(8) NULL DEFAULT NULL,
    `store_city` VARCHAR(50) NULL DEFAULT NULL,
    `store_country_id` INT(8) NULL DEFAULT NULL,
    `store_country` VARCHAR(50) NULL DEFAULT NULL,
    `store_manager_staff_id` INT(8) NULL DEFAULT NULL,
    `store_manager_first_name` VARCHAR(45) NULL DEFAULT NULL,
    `store_manager_last_name` VARCHAR(45) NULL DEFAULT NULL,
    PRIMARY KEY (`store_key`),
    KEY idx_store_id (store_id),
    KEY idx_address_id (store_address_id),
    KEY idx_city_id (store_city_id),
    KEY idx_country_id (store_country_id),
    KEY idx_manager_id (store_manager_staff_id),
    INDEX `store_id` USING BTREE (`store_id`) VISIBLE);

-- Insert data from sakila database to sakila_star database with new architecture
INSERT INTO sakila_star.dim_store(store_key, store_last_update, store_id, store_address_id, store_address,
                                    store_district, store_city_id, store_city, store_country_id, store_country,
                                    store_manager_staff_id, store_manager_first_name, store_manager_last_name)
SELECT NULL, SSTO.last_update, SSTO.store_id, SSTO.address_id, SADD.address, SADD.district, SADD.city_id, SCI.city,
SCI.country_id, SCO.country, SSTO.manager_staff_id, SSTA.first_name, SSTA.last_name
FROM sakila.store AS SSTO
INNER JOIN sakila.address AS SADD ON SSTO.address_id = SADD.address_id
INNER JOIN sakila.city AS SCI ON SADD.city_id = SCI.city_id
INNER JOIN sakila.country AS SCO ON SCI.country_id = SCO.country_id
INNER JOIN sakila.staff AS SSTA ON SSTO.manager_staff_id = SSTA.staff_id;

-- Create Dimention Staff Tables
-- -----------------------------------------------------
-- Table `sakila_star`.`dim_staff`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_star`.`dim_staff` (
    `staff_key` INT(8) NOT NULL AUTO_INCREMENT,
    `staff_last_update` DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00',
    `staff_id` INT(8) NULL DEFAULT NULL,
    `staff_first_name` VARCHAR(45) NULL DEFAULT NULL,
    `staff_last_name` VARCHAR(45) NULL DEFAULT NULL,
    `staff_address_id` INT(8) NULL DEFAULT NULL,
    `staff_address` VARCHAR(64) NULL DEFAULT NULL,
    `staff_district` VARCHAR(20) NULL DEFAULT NULL,
    `staff_city_id` INT(8) NULL DEFAULT NULL,
    `staff_city` VARCHAR(50) NULL DEFAULT NULL,
    `staff_country_id` INT(8) NULL DEFAULT NULL,
    `staff_country` VARCHAR(50) NULL DEFAULT NULL,
    `staff_picture` BLOB NULL DEFAULT NULL,
    `staff_email` VARCHAR(50) NULL DEFAULT NULL,
    `staff_username` VARCHAR(16) NULL DEFAULT NULL,
    `staff_password` VARCHAR(40) NULL DEFAULT NULL,
    `staff_store_id` INT(8) NULL DEFAULT NULL,
    `staff_active` CHAR(3) NULL DEFAULT NULL,
    PRIMARY KEY (`staff_key`),
    KEY idx_staff_id (staff_id),
    KEY idx_address_id (staff_address_id),
    KEY idx_city_id (staff_city_id),
    KEY idx_country_id (staff_country_id),
    KEY idx_store_id (staff_store_id),
    INDEX `staff_id` USING BTREE (`staff_id`) VISIBLE);

-- Insert data from sakila database to sakila_star database with new architecture
INSERT INTO sakila_star.dim_staff(staff_key, staff_last_update, staff_id, staff_first_name, staff_last_name,
                                 staff_address_id, staff_address, staff_district, staff_city_id, staff_city,
                                 staff_country_id, staff_country, staff_picture, staff_email, staff_username,
                                 staff_password, staff_store_id, staff_active)
SELECT NULL, SSTA.last_update, SSTA.staff_id, SSTA.first_name, SSTA.last_name, SSTA.address_id, SADD.address, SADD.district,
SADD.city_id, SCI.city, SCI.country_id, SCO.country, SSTA.picture, SSTA.email, SSTA.username, SSTA.password,
SSTA.store_id, SSTA.active
FROM sakila.staff AS SSTA
INNER JOIN sakila.address AS SADD ON SSTA.address_id = SADD.address_id
INNER JOIN sakila.city AS SCI ON SADD.city_id = SCI.city_id
INNER JOIN sakila.country AS SCO ON SCI.country_id = SCO.country_id;

-- Create Dimention Film Tables
-- -----------------------------------------------------
-- Table `sakila_star`.`dim_film`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_star`.`dim_film` (
    `film_key` INT(8) NOT NULL AUTO_INCREMENT,
    `film_last_update` DATETIME NOT NULL,
    `film_id` INT(12) NOT NULL,
    `film_title` VARCHAR(64) NOT NULL,
    `film_description` TEXT NOT NULL,
    `film_release_year` SMALLINT(5) NOT NULL,
    `film_language_id` INT(12) NOT NULL,
    `film_language_name` VARCHAR(20) NOT NULL,
    `film_rental_duration` TINYINT(3) NULL DEFAULT NULL,
    `film_rental_rate` DECIMAL(4,2) NULL DEFAULT NULL,
    `film_duration` INT(8) NULL DEFAULT NULL,
    `film_replacement_cost` DECIMAL(5,2) NULL DEFAULT NULL,
    `film_rating_text` VARCHAR(30) NULL DEFAULT NULL,
    `film_special_features` VARCHAR(64) NULL DEFAULT NULL,
    `film_category_id` INT(12) NOT NULL,
    `film_category_name` CHAR(30) NULL DEFAULT NULL,
    PRIMARY KEY (`film_key`),
    KEY idx_film_id (film_id),
    KEY idx_language_id (film_language_id),
    KEY idx_category_id (film_category_id),
    INDEX `film_id` USING BTREE (`film_id`) VISIBLE);

-- Insert data from sakila database to sakila_star database with new architecture
INSERT INTO sakila_star.dim_film(film_key,film_last_update,film_id,film_title,film_description,
                                 film_release_year,film_language_id,film_language_name,
                                 film_rental_duration,film_rental_rate,film_duration,
                                 film_replacement_cost,film_rating_text,film_special_features,
                                 film_category_id,film_category_name)
SELECT NULL, SFIL.last_update, SFIL.film_id, SFIL.title, SFIL.description, SFIL.release_year, SFIL.language_id, SLAN.name,
SFIL.rental_duration, SFIL.rental_rate, SFIL.length, SFIL.replacement_cost, SFIL.rating, SFIL.special_features,
SFCA.category_id, SCAT.name
FROM sakila.film AS SFIL
INNER JOIN sakila.language AS SLAN ON SFIL.language_id = SLAN.language_id
INNER JOIN sakila.film_category AS SFCA ON SFIL.film_id = SFCA.film_id
INNER JOIN sakila.category AS SCAT ON SFCA.category_id = SCAT.category_id;

-- Create Fact Tabel - Rental Transaction
-- -----------------------------------------------------
-- Table `sakila_star`.`fact_transaction`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `sakila_star`.`fact_transaction` (
    `transaction_key` INT(8) NOT NULL AUTO_INCREMENT,
    `rental_id` INT(12) NOT NULL,
    `rental_last_update` DATETIME NOT NULL,
    `customer_key` INT(8) NOT NULL,
    `staff_key` INT(8) NOT NULL,
    `film_key` INT(8) NOT NULL,
    `store_key` INT(8) NOT NULL,
    `inventory_id` INT(8) NOT NULL,
    `rental_date` DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00',
    `return_date` DATETIME NULL DEFAULT '1970-01-01 00:00:00',
    `payment_id` INT(12) NULL DEFAULT NULL,
    `payment_date` DATETIME NOT NULL DEFAULT '1970-01-01 00:00:00',
    `payment_amount` DECIMAL(5,2) NULL DEFAULT NULL,
    INDEX `fk_customer_idx` (`customer_key` ASC) VISIBLE,
    INDEX `fk_store_idx` (`store_key` ASC) VISIBLE,
    INDEX `fk_staff_idx` (`staff_key` ASC) VISIBLE,
    INDEX `fk_film_idx` (`film_key` ASC) VISIBLE,
    PRIMARY KEY (`transaction_key`),
    KEY idx_customer (customer_key),
    KEY idx_staff (staff_key),
    KEY idx_film (film_key),
    KEY idx_store (store_key),
    KEY idx_rental (rental_id),
    KEY idx_inventory (inventory_id),
    KEY idx_payment (payment_id),
    CONSTRAINT `fk_customer`
        FOREIGN KEY (`customer_key`)
        REFERENCES `sakila_star`.`dim_customer` (`customer_key`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_staff`
        FOREIGN KEY (`staff_key`)
        REFERENCES `sakila_star`.`dim_staff` (`staff_key`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_store`
        FOREIGN KEY (`store_key`)
        REFERENCES `sakila_star`.`dim_store` (`store_key`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION,
    CONSTRAINT `fk_film`
        FOREIGN KEY (`film_key`)
        REFERENCES `sakila_star`.`dim_film` (`film_key`)
        ON DELETE CASCADE
        ON UPDATE NO ACTION);

-- Insert data from sakila database to sakila_star database with new architecture
INSERT INTO sakila_star.fact_transaction(transaction_key,rental_id,rental_last_update,customer_key,
                                 staff_key,film_key,store_key,inventory_id,rental_date,return_date,
                                 payment_id,payment_date,payment_amount)

SELECT NULL, SREN.rental_id, SREN.last_update, DCUS.customer_key, DSTA.staff_key, DFIL.film_key, DSTO.store_key,
SREN.inventory_id, SREN.rental_date, SREN.return_date, SPAY.payment_id, SPAY.payment_date, SPAY.amount
FROM sakila.rental AS SREN
INNER JOIN sakila_star.dim_customer AS DCUS ON SREN.customer_id = DCUS.customer_id
INNER JOIN sakila_star.dim_staff AS DSTA ON SREN.staff_id = DSTA.staff_id
INNER JOIN sakila.inventory AS SINV ON SREN.inventory_id = SINV.inventory_id
INNER JOIN sakila_star.dim_film AS DFIL ON SINV.film_id = DFIL.film_id
INNER JOIN sakila_star.dim_store AS DSTO ON SINV.store_id = DSTO.store_id
INNER JOIN sakila.payment AS SPAY ON SREN.rental_id = SPAY.rental_id;