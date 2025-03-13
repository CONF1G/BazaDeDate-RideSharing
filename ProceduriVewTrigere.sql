-- Functie pentru validarea existentei unei companii
CREATE FUNCTION fnc_ValidareCompanie(@company_name VARCHAR(30))
RETURNS INT
AS
BEGIN
    DECLARE @exists INT;
    SELECT @exists = COUNT(*) FROM Companies WHERE company_name = @company_name;
    RETURN @exists;
END;

GO

-- Procedura pentru inserarea unei companii
CREATE PROCEDURE sp_InsertCompany
    @company_name VARCHAR(30),
    @collaboration_id INT
AS
BEGIN
    -- Verificăm dacă compania există deja
    IF dbo.fnc_ValidareCompanie(@company_name) > 0
    BEGIN
        RAISERROR ('Compania cu acest nume există deja.', 16, 1);
        RETURN;
    END
    
    INSERT INTO Companies (company_name, collaboration_id)
    VALUES (@company_name, @collaboration_id);
END;

GO

-- Inserăm o companie în baza de date
EXEC sp_InsertCompany @company_name = 'TRANS.FAST', @collaboration_id = 104;
select *From Companies;
GO
		
-------------------------------------------
-- Procedura pentru inserarea unui șofer
CREATE PROCEDURE sp_InsertDriver
    @last_name VARCHAR(30),
    @first_name VARCHAR(30),
    @rating INT,
    @company_id INT,
    @trip_id INT
AS
BEGIN
    -- Verificăm dacă compania există
    IF NOT EXISTS (SELECT 1 FROM Companies WHERE company_id = @company_id)
    BEGIN
        RAISERROR ('Compania nu există.', 16, 1);
        RETURN;
    END

    -- Verificăm dacă călătoria există
    IF NOT EXISTS (SELECT 1 FROM Trips WHERE trip_id = @trip_id)
    BEGIN
        RAISERROR ('Călătoria nu există.', 16, 1);
        RETURN;
    END

    INSERT INTO Drivers (last_name, first_name, rating, company_id, trip_id)
    VALUES (@last_name, @first_name, @rating, @company_id, @trip_id);
END;

GO

-- Inserăm un șofer în baza de date
EXEC sp_InsertDriver @last_name = 'Popescu', @first_name = 'Ion', @rating = 5, @company_id = 1, @trip_id = 1;
SELECT * from Drivers;
GO

-------------------------------------------------------


-- Procedura pentru inserarea unei relații many-to-many între client și șofer
CREATE PROCEDURE sp_InsertCustomerDriver
    @customer_id INT,
    @driver_id INT
AS
BEGIN
    -- Verificăm dacă clientul există
    IF NOT EXISTS (SELECT 1 FROM Customers WHERE customer_id = @customer_id)
    BEGIN
        RAISERROR ('Clientul nu există.', 16, 1);
        RETURN;
    END

    -- Verificăm dacă șoferul există
    IF NOT EXISTS (SELECT 1 FROM Drivers WHERE driver_id = @driver_id)
    BEGIN
        RAISERROR ('Șoferul nu există.', 16, 1);
        RETURN;
    END

    -- Inserăm în tabela de legătură
    INSERT INTO CustomerDriver (customer_id, driver_id)
    VALUES (@customer_id, @driver_id);
END;

GO
-- Inserăm o relație între un client și un șofer
EXEC sp_InsertCustomerDriver @customer_id =4 , @driver_id = 1;
SELECT*FROM CustomerDriver;
GO
------------------------------------------------------------------

CREATE VIEW vw_CustomerDriverTripDetails AS
SELECT 
    c.customer_id,
    c.first_name AS customer_first_name,
    c.last_name AS customer_last_name,
    d.driver_id,
    d.first_name AS driver_first_name,
    d.last_name AS driver_last_name,
    t.trip_id,
    t.distance,
    p.payment_method,
    p.amount
FROM 
    Customers c
JOIN 
    CustomerDriver cd ON c.customer_id = cd.customer_id
JOIN 
    Drivers d ON cd.driver_id = d.driver_id
JOIN 
    Trips t ON d.trip_id = t.trip_id
JOIN 
    Payments p ON t.payment_id = p.payment_id;

SELECT * FROM vw_CustomerDriverTripDetails;
GO




-----------------------------------------------


CREATE TRIGGER trg_InsertCar
ON Cars
FOR INSERT
AS
BEGIN
    DECLARE @table_name NVARCHAR(128) = 'Cars';
    DECLARE @operation NVARCHAR(10) = 'INSERT';
    DECLARE @current_time DATETIME = GETDATE();
    
    PRINT 'Operatie: ' + @operation + ' in tabela: ' + @table_name + ' la data: ' + CAST(@current_time AS NVARCHAR);
END;
GO



----------------------------------------------------------

CREATE TRIGGER trg_DeleteCar
ON Cars
FOR DELETE
AS
BEGIN
    DECLARE @table_name NVARCHAR(128) = 'Cars';
    DECLARE @operation NVARCHAR(10) = 'DELETE';
    DECLARE @current_time DATETIME = GETDATE();
    
    PRINT 'Operatie: ' + @operation + ' in tabela: ' + @table_name + ' la data: ' + CAST(@current_time AS NVARCHAR);
END;
GO

-- Insert a car into the Cars table
INSERT INTO Cars (brand, model, company_id, driver_id)
VALUES ('BMW', 'X5', 1, 1);
GO



DELETE FROM Cars
WHERE brand = 'BMW' AND model = 'X5';
SELECT * FROM Cars;
GO
