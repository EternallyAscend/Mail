-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema Mail
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema Mail
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `Mail` DEFAULT CHARACTER SET utf8 ;
USE `Mail` ;

-- -----------------------------------------------------
-- Table `Mail`.`Customer`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Customer` (
  `Customer_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Customer_Name` VARCHAR(45) NOT NULL,
  `Customer_Nick_Name` VARCHAR(45) NOT NULL,
  `Customer_Email` VARCHAR(45) NOT NULL,
  `Customer_Gender` VARCHAR(6) NOT NULL DEFAULT 'Male',
  `Customer_Password` VARCHAR(32) NOT NULL,
  `Customer_Funds` DECIMAL(12,2) UNSIGNED NOT NULL DEFAULT 0,
  `Customer_Register_Time` DATETIME NOT NULL,
  PRIMARY KEY (`Customer_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Goods_Type`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Goods_Type` (
  `Goods_Type` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Goods_Type`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Customer_Interest`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Customer_Interest` (
  `Customer_Interest_Custom_ID` INT UNSIGNED NOT NULL,
  `Customer_Interest_Goods_Type` VARCHAR(45) NOT NULL,
  INDEX `fk_Custom_Interest_Custom_idx` (`Customer_Interest_Custom_ID` ASC) VISIBLE,
  INDEX `fk_Custom_Interest_Goods_Type1_idx` (`Customer_Interest_Goods_Type` ASC) VISIBLE,
  PRIMARY KEY (`Customer_Interest_Custom_ID`, `Customer_Interest_Goods_Type`),
  CONSTRAINT `fk_Custom_Interest_Custom`
    FOREIGN KEY (`Customer_Interest_Custom_ID`)
    REFERENCES `Mail`.`Customer` (`Customer_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Custom_Interest_Goods_Type1`
    FOREIGN KEY (`Customer_Interest_Goods_Type`)
    REFERENCES `Mail`.`Goods_Type` (`Goods_Type`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Customer_Telephone`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Customer_Telephone` (
  `Customer_Telephone` VARCHAR(18) NOT NULL,
  `Customer_Custom_ID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Customer_Telephone`),
  INDEX `fk_Custom_Telephone_Custom1_idx` (`Customer_Custom_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Custom_Telephone_Custom1`
    FOREIGN KEY (`Customer_Custom_ID`)
    REFERENCES `Mail`.`Customer` (`Customer_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Customer_Address`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Customer_Address` (
  `Custom_Address_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Customer_Address_Customer_ID` INT UNSIGNED NOT NULL,
  `Custom_Address_Province` VARCHAR(45) NOT NULL,
  `Custom_Address_City` VARCHAR(45) NOT NULL,
  `Customer_Address_Detial` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Custom_Address_ID`),
  INDEX `fk_Custom_Address_Custom1_idx` (`Customer_Address_Customer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Custom_Address_Custom1`
    FOREIGN KEY (`Customer_Address_Customer_ID`)
    REFERENCES `Mail`.`Customer` (`Customer_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Customer_Order`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Customer_Order` (
  `Customer_Order_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Customer_Order_Customer_ID` INT UNSIGNED NOT NULL,
  `Customer_Order_Status` VARCHAR(1) NOT NULL,
  `Customer_Order_Time` DATETIME NOT NULL,
  PRIMARY KEY (`Customer_Order_ID`),
  INDEX `fk_Custom_Order_Custom1_idx` (`Customer_Order_Customer_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Custom_Order_Custom1`
    FOREIGN KEY (`Customer_Order_Customer_ID`)
    REFERENCES `Mail`.`Customer` (`Customer_ID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Owner`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Owner` (
  `Owner_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Owner_Name` VARCHAR(45) NOT NULL,
  `Owner_Funds` DECIMAL(12,2) UNSIGNED NOT NULL DEFAULT 0,
  PRIMARY KEY (`Owner_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Shop`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Shop` (
  `Shop_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Shop_Name` VARCHAR(45) NOT NULL,
  `Shop_Owner_ID` INT UNSIGNED NOT NULL,
  `Shop_Funds` DECIMAL(12,2) UNSIGNED NOT NULL,
  PRIMARY KEY (`Shop_ID`),
  INDEX `fk_Shop_Owner1_idx` (`Shop_Owner_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Shop_Owner1`
    FOREIGN KEY (`Shop_Owner_ID`)
    REFERENCES `Mail`.`Owner` (`Owner_ID`)
    ON DELETE RESTRICT
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Goods`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Goods` (
  `Goods_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Goods_Type` VARCHAR(45) NOT NULL,
  `Goods_Shop_ID` INT UNSIGNED NOT NULL,
  `Goods_Price` DECIMAL(12,2) UNSIGNED NOT NULL,
  `Goods_Name` VARCHAR(45) NOT NULL,
  `Goods_Information` VARCHAR(45) NOT NULL,
  `Goods_Number` INT UNSIGNED NOT NULL,
  INDEX `fk_Goods_Goods_Type1_idx` (`Goods_Type` ASC) VISIBLE,
  PRIMARY KEY (`Goods_ID`),
  INDEX `fk_Goods_Shop1_idx` (`Goods_Shop_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Goods_Goods_Type1`
    FOREIGN KEY (`Goods_Type`)
    REFERENCES `Mail`.`Goods_Type` (`Goods_Type`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Goods_Shop1`
    FOREIGN KEY (`Goods_Shop_ID`)
    REFERENCES `Mail`.`Shop` (`Shop_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Shopping_Cart`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Shopping_Cart` (
  `Shopping_Cart_Customer_ID` INT UNSIGNED NOT NULL,
  `Shopping_Cart_Goods_ID` INT UNSIGNED NOT NULL,
  `Shopping_Cart_Time` DATETIME NOT NULL,
  `Shopping_Cart_Goods_Number` INT UNSIGNED NOT NULL DEFAULT 1,
  INDEX `fk_Shopping_Cart_Custom1_idx` (`Shopping_Cart_Customer_ID` ASC) VISIBLE,
  INDEX `fk_Shopping_Cart_Goods1_idx` (`Shopping_Cart_Goods_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Shopping_Cart_Custom1`
    FOREIGN KEY (`Shopping_Cart_Customer_ID`)
    REFERENCES `Mail`.`Customer` (`Customer_ID`)
    ON DELETE NO ACTION
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Shopping_Cart_Goods1`
    FOREIGN KEY (`Shopping_Cart_Goods_ID`)
    REFERENCES `Mail`.`Goods` (`Goods_ID`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Purchaser`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Purchaser` (
  `Purchaser_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Purchaser_Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Purchaser_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Shop_Purchase`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Shop_Purchase` (
  `Shop_Purchase_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Shop_Purchase_Shop_ID` INT UNSIGNED NOT NULL,
  `Shop_Purchase_Time` DATETIME NOT NULL,
  `Shop_Purchase_Status` VARCHAR(1) NOT NULL,
  PRIMARY KEY (`Shop_Purchase_ID`),
  INDEX `fk_Shop_Purchase_Shop1_idx` (`Shop_Purchase_Shop_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Shop_Purchase_Shop1`
    FOREIGN KEY (`Shop_Purchase_Shop_ID`)
    REFERENCES `Mail`.`Shop` (`Shop_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Shop_Purchase_Detial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Shop_Purchase_Detial` (
  `Shop_Purchase_Goods_ID` INT UNSIGNED NOT NULL,
  `Shop_Purchase_Purchaser_ID` INT UNSIGNED NOT NULL,
  `Shop_Purchase_Shop_Purchase_ID` INT UNSIGNED NOT NULL,
  `Shop_Purchase_Detial_Number` INT UNSIGNED NOT NULL,
  `Shop_Purchase_Detial_Price` DECIMAL(12,2) UNSIGNED NOT NULL,
  `Shop_Purchase_Detial_Status` VARCHAR(1) NOT NULL,
  `Shop_Purchase_Detial_Time` DATETIME NULL,
  INDEX `fk_Shop_Purchase_Goods1_idx` (`Shop_Purchase_Goods_ID` ASC) VISIBLE,
  INDEX `fk_Shop_Purchase_Purchaser1_idx` (`Shop_Purchase_Purchaser_ID` ASC) VISIBLE,
  INDEX `fk_Shop_Purchase_Detial_Shop_Purchase1_idx` (`Shop_Purchase_Shop_Purchase_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Shop_Purchase_Goods1`
    FOREIGN KEY (`Shop_Purchase_Goods_ID`)
    REFERENCES `Mail`.`Goods` (`Goods_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Shop_Purchase_Purchaser1`
    FOREIGN KEY (`Shop_Purchase_Purchaser_ID`)
    REFERENCES `Mail`.`Purchaser` (`Purchaser_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Shop_Purchase_Detial_Shop_Purchase1`
    FOREIGN KEY (`Shop_Purchase_Shop_Purchase_ID`)
    REFERENCES `Mail`.`Shop_Purchase` (`Shop_Purchase_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Seller`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Seller` (
  `Seller_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Seller_Name` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`Seller_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Order_Detial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Order_Detial` (
  `Order_Detial_Customer_Order_ID` INT UNSIGNED NOT NULL,
  `Order_Detial_Goods_ID` INT UNSIGNED NOT NULL,
  `Order_Deital_Seller_ID` INT UNSIGNED NOT NULL,
  `Order_Detial_Price` DECIMAL(12,2) UNSIGNED NOT NULL,
  `Order_Detial_Number` INT UNSIGNED NOT NULL DEFAULT 1,
  `Order_Detial_Status` VARCHAR(1) NOT NULL,
  `Order_Detial_Time` DATETIME NOT NULL,
  INDEX `fk_Order_Detial_Custom_Order1_idx` (`Order_Detial_Customer_Order_ID` ASC) VISIBLE,
  INDEX `fk_Order_Detial_Goods1_idx` (`Order_Detial_Goods_ID` ASC) VISIBLE,
  PRIMARY KEY (`Order_Detial_Customer_Order_ID`, `Order_Detial_Goods_ID`),
  INDEX `fk_Order_Detial_Seller1_idx` (`Order_Deital_Seller_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Order_Detial_Custom_Order1`
    FOREIGN KEY (`Order_Detial_Customer_Order_ID`)
    REFERENCES `Mail`.`Customer_Order` (`Customer_Order_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Order_Detial_Goods1`
    FOREIGN KEY (`Order_Detial_Goods_ID`)
    REFERENCES `Mail`.`Goods` (`Goods_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Order_Detial_Seller1`
    FOREIGN KEY (`Order_Deital_Seller_ID`)
    REFERENCES `Mail`.`Seller` (`Seller_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Coupon`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Coupon` (
  `Coupon_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Coupon_Number` INT UNSIGNED NOT NULL,
  `Coupon_Price` DECIMAL(8,2) UNSIGNED NOT NULL,
  PRIMARY KEY (`Coupon_ID`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Coupon_Detial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Coupon_Detial` (
  `Coupon_Detial_Coupon_ID` INT UNSIGNED NOT NULL,
  `Custom_Detial_Custom_ID` INT UNSIGNED NOT NULL,
  `Coupon_Detial_status` VARCHAR(1) NOT NULL,
  INDEX `fk_Coupon_Detials_Coupon1_idx` (`Coupon_Detial_Coupon_ID` ASC) VISIBLE,
  INDEX `fk_Coupon_Detials_Custom1_idx` (`Custom_Detial_Custom_ID` ASC) VISIBLE,
  PRIMARY KEY (`Coupon_Detial_Coupon_ID`, `Custom_Detial_Custom_ID`),
  CONSTRAINT `fk_Coupon_Detials_Coupon1`
    FOREIGN KEY (`Coupon_Detial_Coupon_ID`)
    REFERENCES `Mail`.`Coupon` (`Coupon_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Coupon_Detials_Custom1`
    FOREIGN KEY (`Custom_Detial_Custom_ID`)
    REFERENCES `Mail`.`Customer` (`Customer_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Mail`.`Remark`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `Mail`.`Remark` (
  `Remark_ID` INT UNSIGNED NOT NULL AUTO_INCREMENT,
  `Remark_Goods_ID` INT UNSIGNED NOT NULL,
  `Remark_Status` VARCHAR(1) NOT NULL,
  `Remark_Anonymous` VARCHAR(1) NOT NULL,
  `Order_Detial_Order_Detial_Customer_Order_ID` INT UNSIGNED NOT NULL,
  `Order_Detial_Order_Detial_Goods_ID` INT UNSIGNED NOT NULL,
  PRIMARY KEY (`Remark_ID`),
  INDEX `fk_Remark_Goods1_idx` (`Remark_Goods_ID` ASC) VISIBLE,
  INDEX `fk_Remark_Order_Detial1_idx` (`Order_Detial_Order_Detial_Customer_Order_ID` ASC, `Order_Detial_Order_Detial_Goods_ID` ASC) VISIBLE,
  CONSTRAINT `fk_Remark_Goods1`
    FOREIGN KEY (`Remark_Goods_ID`)
    REFERENCES `Mail`.`Goods` (`Goods_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_Remark_Order_Detial1`
    FOREIGN KEY (`Order_Detial_Order_Detial_Customer_Order_ID` , `Order_Detial_Order_Detial_Goods_ID`)
    REFERENCES `Mail`.`Order_Detial` (`Order_Detial_Customer_Order_ID` , `Order_Detial_Goods_ID`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
