
CREATE DATABASE Manufacturer;


CREATE TABLE Product
(
	prod_id INT NOT NULL,
	prod_name VARCHAR(50) NULL,
	quantity INT NULL
	PRIMARY KEY (prod_id)
 ) ;


CREATE TABLE Component
(
	comp_id INT NOT NULL,
	comp_name VARCHAR(50) NULL,
	[description] VARCHAR(50) NULL,
	quantity_comp INT NULL
	PRIMARY KEY (comp_id)
 ) ;


CREATE TABLE Supplier
(
	supp_id INT NOT NULL,
	supp_name VARCHAR(50) NULL,
	sup_location VARCHAR(50) NULL,
	sup_country VARCHAR(50) NULL,
	Is_active BIT NULL
	PRIMARY KEY (supp_id)
 ) ;




CREATE TABLE Prod_Comp
(
	prod_id INT NOT NULL,
	comp_id INT NOT NULL,
	quantity_comp INT NULL
	PRIMARY KEY (prod_id,comp_id), 
	FOREIGN KEY (prod_id) REFERENCES Product(prod_id),
	FOREIGN KEY (comp_id) REFERENCES Component(comp_id)
 ) ;



CREATE TABLE Comp_Supp
(
	supp_id INT NOT NULL,
	comp_id INT NOT NULL,
	order_date DATE NULL,
	quantity INT NULL
	PRIMARY KEY (supp_id,comp_id),
	FOREIGN KEY (supp_id) REFERENCES Supplier(supp_id),
	FOREIGN KEY (comp_id) REFERENCES Component(comp_id)
 ) ;

