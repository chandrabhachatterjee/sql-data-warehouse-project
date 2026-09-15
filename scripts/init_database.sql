
/*=============================================================================
    PROJECT      : Data Warehouse & Analytics
    SCRIPT       : Database Initialization
    DATABASE     : DataWarehouse
    PURPOSE      : 
        1. Switch to the master database
        2. Check whether DataWarehouse already exists
        3. Drop the existing database if it exists
        4. Create a fresh DataWarehouse database
        5. Create Bronze, Silver, and Gold schemas

    ARCHITECTURE :
        Bronze → Raw / Staging Data
        Silver → Cleaned / Transformed Data
        Gold   → Business-Ready / Analytical Data

    WARNING:
        ⚠️ THIS SCRIPT IS DESTRUCTIVE.
        If DataWarehouse already exists, it will be PERMANENTLY DROPPED
        along with all tables, data, views, procedures, and other objects.

        DO NOT RUN THIS SCRIPT ON A PRODUCTION DATABASE unless you are
        absolutely sure that the database can be deleted and you have
        an appropriate backup.
=============================================================================*/


/*=============================================================================
    STEP 1: SWITCH TO MASTER DATABASE
=============================================================================*/

USE master;
GO

-- We use the master database because we cannot safely drop a database
-- while our current session is connected to that database.


/*=============================================================================
    STEP 2: CHECK IF DataWarehouse DATABASE ALREADY EXISTS
=============================================================================*/

IF EXISTS
(
    SELECT 1
    FROM sys.databases
    WHERE name = 'DataWarehouse'
)
BEGIN

    -- ⚠️ WARNING:
    -- The following command forces the database into SINGLE_USER mode.
    -- This means only one connection can access the database.

    ALTER DATABASE DataWarehouse
    SET SINGLE_USER
    WITH ROLLBACK IMMEDIATE;


    -- ⚠️ WARNING:
    -- DROP DATABASE permanently deletes the DataWarehouse database
    -- and all objects/data inside it.
    --
    -- ROLLBACK IMMEDIATE also terminates existing connections and
    -- rolls back their active/uncommitted transactions.

    DROP DATABASE DataWarehouse;

END;
GO


/*=============================================================================
    STEP 3: CREATE A FRESH DataWarehouse DATABASE
=============================================================================*/

CREATE DATABASE DataWarehouse;
GO


/*=============================================================================
    STEP 4: SWITCH TO DataWarehouse
=============================================================================*/

USE DataWarehouse;
GO


/*=============================================================================
    STEP 5: CREATE DATA WAREHOUSE SCHEMAS
=============================================================================

    BRONZE:
        Stores raw/source data.
        Data is generally kept close to its original source format.

    SILVER:
        Stores cleaned, validated, standardized, and transformed data.

    GOLD:
        Stores business-ready data used for reporting, dashboards,
        analytics, and decision-making.

    DATA FLOW:

        Source Systems
              ↓
           BRONZE
              ↓
           SILVER
              ↓
            GOLD
              ↓
        Reports / BI / Analytics
=============================================================================*/


-- Bronze Layer: Raw / Staging Data
CREATE SCHEMA bronze;
GO


-- Silver Layer: Cleaned and Transformed Data
CREATE SCHEMA silver;
GO


-- Gold Layer: Business-Ready Analytical Data
CREATE SCHEMA gold;
GO


/*=============================================================================
    DATABASE INITIALIZATION COMPLETED
=============================================================================

    Database : DataWarehouse

    Schemas:
        ✓ bronze
        ✓ silver
        ✓ gold

    Next Step:
        Create tables and load data into the Bronze layer.

=============================================================================*/
