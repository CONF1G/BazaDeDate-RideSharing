CREATE DATABASE RideSharingDB;
USE RideSharingDB;

-- Updated Table: Companies
CREATE TABLE Companies (
    company_id INT NOT NULL PRIMARY KEY IDENTITY(1,1),  -- Auto-increment ID
    company_name VARCHAR(30),
    collaboration_id INT
);

-- Updated Table: Payments
CREATE TABLE Payments (
    payment_id INT NOT NULL PRIMARY KEY IDENTITY(1,1),  -- Auto-increment ID
    payment_method VARCHAR(30),
    amount INT
);

-- Updated Table: Trips
CREATE TABLE Trips (
    trip_id INT NOT NULL PRIMARY KEY IDENTITY(1,1),  -- Auto-increment ID
    distance INT,
    payment_id INT,
    FOREIGN KEY (payment_id) REFERENCES Payments(payment_id)
);

-- Updated Table: Drivers
CREATE TABLE Drivers (
    driver_id INT NOT NULL PRIMARY KEY IDENTITY(1,1),  -- Auto-increment ID
    last_name VARCHAR(30),
    first_name VARCHAR(30),
    rating INT,
    company_id INT,
    trip_id INT,
    FOREIGN KEY (company_id) REFERENCES Companies(company_id),
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);

-- Updated Table: Customers
CREATE TABLE Customers (
    customer_id INT NOT NULL PRIMARY KEY IDENTITY(1,1),  -- Auto-increment ID
    last_name VARCHAR(30),
    first_name VARCHAR(30),
    trip_id INT,
    company_id INT,
    FOREIGN KEY (company_id) REFERENCES Companies(company_id),
    FOREIGN KEY (trip_id) REFERENCES Trips(trip_id)
);

-- Updated Table: Cars
CREATE TABLE Cars (
    car_id INT NOT NULL PRIMARY KEY IDENTITY(1,1),  -- Auto-increment ID
    brand VARCHAR(30),
    model VARCHAR(30),
    company_id INT,
    driver_id INT,
    FOREIGN KEY (company_id) REFERENCES Companies(company_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);

-- Updated Table: CustomerDriver (many-to-many relationship)
CREATE TABLE CustomerDriver (
    customer_id INT,
    driver_id INT,
    PRIMARY KEY (customer_id, driver_id),
    FOREIGN KEY (customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY (driver_id) REFERENCES Drivers(driver_id)
);

USE RideSharingDB;

-- Inserting into Companies
INSERT INTO Companies (company_name, collaboration_id) VALUES 
('Bolt', 101),
('Uber', 102),
('Lyft', 103);

-- Inserting into Payments
INSERT INTO Payments (payment_method, amount) VALUES 
('Credit Card', 50),
('Cash', 30),
('Debit Card', 20),
('Digital Wallet', 40);

-- Inserting into Trips
-- Note: Make sure payment_id matches those from Payments table
INSERT INTO Trips (distance, payment_id) VALUES 
(12, 1),  -- Payment: Credit Card
(8, 2),   -- Payment: Cash
(15, 3),  -- Payment: Debit Card
(25, 4);  -- Payment: Digital Wallet

-- Inserting into Drivers
-- Note: Ensure company_id matches those in Companies and trip_id in Trips
INSERT INTO Drivers (last_name, first_name, rating, company_id, trip_id) VALUES 
('Popescu', 'Ion', 5, 1, 1),  -- Company: Bolt, Trip: 1
('Ionescu', 'Andrei', 4, 2, 2),  -- Company: Uber, Trip: 2
('Marin', 'Elena', 3, 1, 3),  -- Company: Bolt, Trip: 3
('Dumitru', 'Ana', 5, 3, 4);  -- Company: Lyft, Trip: 4

-- Inserting into Customers
-- Note: Make sure company_id and trip_id match those in Companies and Trips
INSERT INTO Customers (last_name, first_name, trip_id, company_id) VALUES 
('Stoica', 'Maria', 1, 1),  -- Trip: 1, Company: Bolt
('Vasilescu', 'George', 2, 2),  -- Trip: 2, Company: Uber
('Iordache', 'Radu', 3, 1),  -- Trip: 3, Company: Bolt
('Constantin', 'Irina', 4, 3);  -- Trip: 4, Company: Lyft

-- Inserting into Cars
-- Note: Ensure company_id and driver_id match Companies and Drivers
INSERT INTO Cars (brand, model, company_id, driver_id) VALUES 
('Dacia', 'Logan', 1, 1),  -- Company: Bolt, Driver: Ion Popescu
('Toyota', 'Prius', 2, 2),  -- Company: Uber, Driver: Andrei Ionescu
('Ford', 'Focus', 1, 3),    -- Company: Bolt, Driver: Elena Marin
('Tesla', 'Model 3', 3, 4); -- Company: Lyft, Driver: Ana Dumitru

-- Inserting into CustomerDriver (many-to-many relationships)
-- Note: Ensure customer_id and driver_id match those in Customers and Drivers
INSERT INTO CustomerDriver (customer_id, driver_id) VALUES 
(1, 1),  -- Maria Stoica with Ion Popescu
(2, 2),  -- George Vasilescu with Andrei Ionescu
(3, 3),  -- Radu Iordache with Elena Marin
(4, 4),  -- Irina Constantin with Ana Dumitru
(1, 2);  -- Maria Stoica with Andrei Ionescu (demonstrating many-to-many relationship)


select * from Cars;