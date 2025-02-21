CREATE DATABASE PROJECT_STAGE;
CREATE DATABASE PROJECT_METADATA;
CREATE DATABASE PROJECT_NDS;
CREATE DATABASE PROJECT_DDS;
GO

--DROP DATABASE PROJECT_STAGE;
--DROP DATABASE PROJECT_METADATA;
--DROP DATABASE PROJECT_NDS;
--DROP DATABASE PROJECT_DDS;

USE PROJECT_STAGE;
GO

DROP TABLE IF EXISTS PROJECT_STAGE.dbo.Stage_USCountyData;
CREATE TABLE PROJECT_STAGE.dbo.Stage_USCountyData (
    county VARCHAR(50),
    county_ascii VARCHAR(50),
    county_full VARCHAR(100),
    county_fips CHAR(5),
    state_id CHAR(2),
    state_name VARCHAR(50),
    lat DECIMAL(8, 5),
    lng DECIMAL(8, 5),
    population INT
);
GO

DROP TABLE IF EXISTS PROJECT_STAGE.dbo.Stage_AirQualityData2021;
CREATE TABLE PROJECT_STAGE.dbo.Stage_AirQualityData2021 (
    State_Name VARCHAR(50),
    County_Name VARCHAR(50),
    State_Code INT,
    County_Code INT,
    Date DATE,
    AQI INT,
    Category VARCHAR(50),
    Defining_Parameter VARCHAR(50),
    Defining_Site VARCHAR(50),
    Number_of_Sites_Reporting INT,
    Created DATETIME,
    Last_Updated DATETIME
);

DROP TABLE IF EXISTS PROJECT_STAGE.dbo.Stage_AirQualityData2022;
CREATE TABLE PROJECT_STAGE.dbo.Stage_AirQualityData2022 (
    State_Name VARCHAR(50),
    County_Name VARCHAR(50),
    State_Code INT,
    County_Code INT,
    Date DATE,
    AQI INT,
    Category VARCHAR(50),
    Defining_Parameter VARCHAR(50),
    Defining_Site VARCHAR(50),
    Number_of_Sites_Reporting INT,
    Created DATETIME,
    Last_Updated DATETIME
);
GO

DROP TABLE IF EXISTS PROJECT_STAGE.dbo.Stage_AirQualityData2023;
CREATE TABLE PROJECT_STAGE.dbo.Stage_AirQualityData2023 (
    State_Name VARCHAR(50),
    County_Name VARCHAR(50),
    State_Code INT,
    County_Code INT,
    Date DATE,
    AQI INT,
    Category VARCHAR(50),
    Defining_Parameter VARCHAR(50),
    Defining_Site VARCHAR(50),
    Number_of_Sites_Reporting INT,
    Created DATETIME,
    Last_Updated DATETIME
);
GO

DROP TABLE IF EXISTS PROJECT_STAGE.dbo.Stage_AirQualityData;
CREATE TABLE PROJECT_STAGE.dbo.Stage_AirQualityData (
	AQI_SK INT IDENTITY(1,1) PRIMARY KEY,
    State_Name VARCHAR(50),
    County_Name VARCHAR(50),
    State_Code INT,
    County_Code INT,
    Date DATE,
    AQI INT,
    Category VARCHAR(50),
    Defining_Parameter VARCHAR(50),
    Defining_Site VARCHAR(50),
    Number_of_Sites_Reporting INT,
    Created DATETIME,
    Last_Updated DATETIME,
	UNIQUE(State_Code,County_Code,Date, Defining_Parameter)
);
GO

--SELECT * FROM PROJECT_STAGE.dbo.Stage_AirQualityData
--SELECT DISTINCT Defining_Parameter , MIN(Created) AS Created, MAX(Last_Updated) AS Last_Updated FROM PROJECT_STAGE.dbo.Stage_AirQualityData GROUP BY Defining_Parameter
--SELECT DISTINCT Defining_Site , MIN(Created) AS Created, MAX(Last_Updated) AS Last_Updated FROM PROJECT_STAGE.dbo.Stage_AirQualityData GROUP BY Defining_Site
--SELECT DISTINCT State_Name , MIN(Created) AS Created, MAX(Last_Updated) AS Last_Updated FROM PROJECT_STAGE.dbo.Stage_AirQualityData GROUP BY State_Name
--SELECT * FROM PROJECT_STAGE.dbo.Stage_USCountyData

--SELECT DISTINCT County_Code, County_Name, State_Name
--FROM PROJECT_STAGE.dbo.Stage_AirQualityData 
--WHERE COUNTY_NAME NOT IN (SELECT COUNTY FROM PROJECT_NDS.dbo.County_NDS)

--SELECT * FROM PROJECT_STAGE.dbo.Stage_USCountyData
--WHERE COUNTY IN (SELECT DISTINCT County_Name
--FROM PROJECT_STAGE.dbo.Stage_AirQualityData 
--WHERE COUNTY_NAME NOT IN (SELECT COUNTY FROM PROJECT_NDS.dbo.County_NDS)
--GROUP BY County_Code,County_Name,State_Name)

USE PROJECT_METADATA
GO

DROP TABLE IF EXISTS PROJECT_metadata.dbo.data_flow;
CREATE TABLE PROJECT_metadata.dbo.data_flow (
    id INT IDENTITY(1,1),
    name VARCHAR(50) NOT NULL UNIQUE,
    LSET DATETIME, -- Thời gian SSIS thành công gần nhất
    CET DATETIME, -- Thời gian SSIS hiện tại
    CONSTRAINT pk_data_flow PRIMARY KEY CLUSTERED (id)
);

--Truncate Table data_flow
INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Stage_AirQualityData2021', '1/1/2020', '1/1/2020');
INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Stage_AirQualityData2022', '1/1/2020', '1/1/2020');
INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Stage_AirQualityData2023', '1/1/2020', '1/1/2020');
INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Stage_AirQualityData', '1/1/2020', '1/1/2020');
INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Stage_USCountyData', '1/1/2020', '1/1/2020');
GO


--DELETE FROM PROJECT_METADATA.dbo.data_flow;
--DBCC CHECKIDENT ('PROJECT_METADATA.dbo.data_flow', RESEED, 0);

--select * from PROJECT_METADATA.dbo.data_flow

-------------------------------------------------------------------
USE [PROJECT_NDS]
GO
---DEBUG - USE WHEN RESET SSIS
--DROP TABLE IF EXISTS PROJECT_NDS.dbo.AQI_NDS;
--DROP TABLE IF EXISTS PROJECT_NDS.dbo.Category_NDS;
--DROP TABLE IF EXISTS PROJECT_NDS.dbo.Parameters_NDS;
--DROP TABLE IF EXISTS PROJECT_NDS.dbo.Sites_NDS;
--DROP TABLE IF EXISTS PROJECT_NDS.dbo.County_NDS;
--DROP TABLE IF EXISTS PROJECT_NDS.dbo.State_NDS;
--DROP TABLE IF EXISTS PROJECT_NDS.dbo.Sources

-- Table: Sources
DROP TABLE IF EXISTS PROJECT_NDS.dbo.Sources
CREATE TABLE PROJECT_NDS.dbo.Sources (
    ID_Source INT IDENTITY(1,1) PRIMARY KEY,
    Source VARCHAR(255),
	Created DATETIME,
    Last_Updated DATETIME
);
GO

INSERT INTO Sources(Source,Created,Last_Updated) Values ('csv',GETDATE(),GETDATE());
GO

-- Table: State_NDS
DROP TABLE IF EXISTS PROJECT_NDS.dbo.State_NDS;
CREATE TABLE PROJECT_NDS.dbo.State_NDS (
    State_SK INT IDENTITY(1,1) PRIMARY KEY,
    State_Code VARCHAR(50) UNIQUE,
    State_Name VARCHAR(50),
    ID_Source INT FOREIGN KEY REFERENCES Sources(ID_Source),
    Created DATETIME,
    Last_Updated DATETIME
);
--SELECT * FROM PROJECT_NDS.dbo.State_NDS;

-- Table: County_NDS
DROP TABLE IF EXISTS PROJECT_NDS.dbo.County_NDS;
CREATE TABLE PROJECT_NDS.dbo.County_NDS (
    County_SK INT IDENTITY(1,1) PRIMARY KEY,
    County VARCHAR(50),
    County_full VARCHAR(100),
    County_fips VARCHAR(50) UNIQUE,
    latitude FLOAT,
    longitude FLOAT,
    population INT,
    State_SK INT FOREIGN KEY REFERENCES State_NDS(State_SK),
    Created DATETIME,
    Last_Updated DATETIME,
    ID_Source INT FOREIGN KEY REFERENCES Sources(ID_Source),
);

--SELECT * FROM PROJECT_NDS.dbo.County_NDS;


-- Table: Category_NDS
DROP TABLE IF EXISTS PROJECT_NDS.dbo.Category_NDS;
CREATE TABLE PROJECT_NDS.dbo.Category_NDS (
    Category_SK INT IDENTITY(1,1) PRIMARY KEY,
    Category VARCHAR(50) NOT NULL,
    Value_From INT NOT NULL,
    Value_To INT NOT NULL,
    Color VARCHAR(20) NOT NULL,
    Description VARCHAR(500),
    ID_Source INT FOREIGN KEY REFERENCES Sources(ID_Source),
	Created DATETIME,
    Last_Updated DATETIME
);

-- Insert AQI categories into Category_NDS
INSERT INTO PROJECT_NDS.dbo.Category_NDS (Category, Value_From, Value_To, Color, Description,ID_Source,Created,Last_Updated)
VALUES
('Good', 0, 50, 'Green', 'Air quality is satisfactory, and air pollution poses little or no risk.',1, '1/1/2020', '1/1/2020'),
('Moderate', 51, 100, 'Yellow', 'Air quality is acceptable. However, there may be a risk for some people, particularly those who are unusually sensitive to air pollution.',1, '1/1/2020', '1/1/2020'),
('Unhealthy for Sensitive Groups', 101, 150, 'Orange', 'Members of sensitive groups may experience health effects. The general public is less likely to be affected.',1, '1/1/2020', '1/1/2020'),
('Unhealthy', 151, 200, 'Red', 'Some members of the general public may experience health effects; members of sensitive groups may experience more serious health effects.',1, '1/1/2020', '1/1/2020'),
('Very Unhealthy', 201, 300, 'Purple', 'Health alert: The risk of health effects is increased for everyone.',1, '1/1/2020', '1/1/2020'),
('Hazardous', 301, 500, 'Maroon', 'Health warning of emergency conditions: everyone is more likely to be affected.',1, '1/1/2020', '1/1/2020');

--SELECT * FROM PROJECT_NDS.dbo.Category_NDS;

-- Table: Parameters_NDS
DROP TABLE IF EXISTS PROJECT_NDS.dbo.Parameters_NDS;
CREATE TABLE PROJECT_NDS.dbo.Parameters_NDS (
    Parameter_SK INT IDENTITY(1,1) PRIMARY KEY,
    Defining_Parameter VARCHAR(50) UNIQUE,
    ID_Source INT FOREIGN KEY REFERENCES Sources(ID_Source),
    Created DATETIME,
    Last_Updated DATETIME
);
--SELECT * FROM [dbo].[Parameters_NDS];

-- Table: Sites_NDS
DROP TABLE IF EXISTS PROJECT_NDS.dbo.Sites_NDS;
CREATE TABLE PROJECT_NDS.dbo.Sites_NDS (
    Site_SK INT IDENTITY(1,1) PRIMARY KEY,
    Defining_Site VARCHAR(50) UNIQUE,
    ID_Source INT FOREIGN KEY REFERENCES Sources(ID_Source),
    Created DATETIME,
    Last_Updated DATETIME
);

--SELECT * FROM [dbo].[Sites_NDS];

-- Table: AQI_NDS
DROP TABLE IF EXISTS PROJECT_NDS.dbo.AQI_NDS;
CREATE TABLE PROJECT_NDS.dbo.AQI_NDS (
    AQI_SK INT IDENTITY(1,1) PRIMARY KEY,
    County_SK INT FOREIGN KEY REFERENCES County_NDS(County_SK),
    Date DATE,
    AQI INT,
    Category_SK INT FOREIGN KEY REFERENCES Category_NDS(Category_SK),
    Parameter_SK INT FOREIGN KEY REFERENCES Parameters_NDS(Parameter_SK),
    Site_SK INT FOREIGN KEY REFERENCES Sites_NDS(Site_SK),
    Number_of_Sites_Reporting INT,
    Created DATETIME,
    Last_Updated DATETIME,
    ID_Source INT FOREIGN KEY REFERENCES Sources(ID_Source),
    UNIQUE (County_SK, Date, Parameter_SK)
);


---------------------------------------
USE PROJECT_DDS
GO

-- DROP TABLE DEBUG ONLY
--DROP TABLE IF EXISTS PROJECT_DDS.dbo.Fact_AQI;
--DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_Site;
--DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_Parameter;
--DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_Category;
--DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_County;
--DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_State;
--DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_Date;
--DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_Sources;

-- Dimension Table: Dim_Source
DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_Sources
CREATE TABLE PROJECT_DDS.dbo.Dim_Sources (
    Source_SK INT PRIMARY KEY,
    Source VARCHAR(255),
    Created DATETIME,
    Last_Updated DATETIME
);
GO

INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Dim_Sources', '1/1/2020', '1/1/2020');

INSERT INTO PROJECT_DDS.dbo.Dim_Sources VALUES (1,'csv',GETDATE(),GETDATE());
GO

-- Dimension Table: Dim_Date
DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_Date
CREATE TABLE PROJECT_DDS.dbo.Dim_Date (
    Date_SK INT PRIMARY KEY,
    Full_Date DATE NOT NULL,
    Year INT NOT NULL,
    Quarter INT NOT NULL,
    Month INT NOT NULL,
    Day INT NOT NULL,
	    Created DATETIME,
    Last_Updated DATETIME,
	Source_SK INT FOREIGN KEY REFERENCES Dim_Sources(Source_SK)
);
GO
--SELECT * FROM PROJECT_DDS.dbo.Dim_Date;
INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Dim_Date', '1/1/2020', '1/1/2020');

GO
-- Tạo procedure thêm một ngày vào Dim_Date
USE PROJECT_DDS
GO
CREATE OR ALTER PROCEDURE Add_Dim_Date
    @InputDate DATE,       -- Ngày cần thêm
    @Source_SK INT,         -- Khóa ngoại nguồn dữ liệu
	@Created DATE,
	@Updated DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem ngày đã tồn tại trong Dim_Date chưa
    IF NOT EXISTS (SELECT 1 FROM PROJECT_DDS.dbo.Dim_Date WHERE Full_Date = @InputDate)
    BEGIN
        INSERT INTO PROJECT_DDS.dbo.Dim_Date (
            Date_SK,
            Full_Date,
            Year,
            Quarter,
            Month,
            Day,
            Created,
            Last_Updated,
            Source_SK
        )
        VALUES (
            CONVERT(INT, FORMAT(@InputDate, 'yyyyMMdd')),  -- Tạo Date_SK từ ngày
            @InputDate,
            YEAR(@InputDate),                               -- Năm
            DATEPART(QUARTER, @InputDate),                  -- Quý
            MONTH(@InputDate),                              -- Tháng
            DAY(@InputDate),                                -- Ngày
            @Created,                                      -- Ngày tạo
            @Updated,                                      -- Ngày cập nhật
            @Source_SK                                      -- Khóa ngoại nguồn
        );
    END
    ELSE
    BEGIN
        PRINT 'Ngày này đã tồn tại trong Dim_Date.';
    END
END;
GO

CREATE OR ALTER PROCEDURE Update_Dim_Date
    @InputDate DATE,       -- Ngày cần cập nhật
    @Source_SK INT,         -- Khóa ngoại nguồn dữ liệu
	@Update_Date DATE
AS
BEGIN
    SET NOCOUNT ON;

    -- Kiểm tra xem ngày đã tồn tại trong Dim_Date chưa
    IF EXISTS (SELECT 1 FROM PROJECT_DDS.dbo.Dim_Date WHERE Full_Date = @InputDate)
    BEGIN
        UPDATE PROJECT_DDS.dbo.Dim_Date
        SET 
            Year = YEAR(@InputDate),                   -- Cập nhật Năm
            Quarter = DATEPART(QUARTER, @InputDate),    -- Cập nhật Quý
            Month = MONTH(@InputDate),                  -- Cập nhật Tháng
            Day = DAY(@InputDate),                      -- Cập nhật Ngày
            Last_Updated = @Update_Date,                   -- Cập nhật Ngày cập nhật
            Source_SK = @Source_SK                      -- Cập nhật Khóa ngoại nguồn
        WHERE Full_Date = @InputDate;
    END
    ELSE
    BEGIN
        PRINT 'Ngày này không tồn tại trong Dim_Date để cập nhật.';
    END
END;
GO

-- Dimension Table: Dim_State
DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_State
CREATE TABLE PROJECT_DDS.dbo.Dim_State (
    State_SK INT PRIMARY KEY,
    State_Code VARCHAR(50) UNIQUE,
    State_Name VARCHAR(50),
    Source_SK INT FOREIGN KEY REFERENCES Dim_Sources(Source_SK),
	Is_Current BIT,
    Created DATETIME,
    Last_Updated DATETIME
);
GO
INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Dim_State', '1/1/2020', '1/1/2020');

GO
-- Dimension Table: Dim_County
DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_County;
CREATE TABLE PROJECT_DDS.dbo.Dim_County (
    County_SK INT PRIMARY KEY,
    County VARCHAR(50),
    County_full VARCHAR(100),
    County_fips VARCHAR(50) UNIQUE,
    Latitude FLOAT,
    Longitude FLOAT,
    Population INT,
    State_SK INT FOREIGN KEY REFERENCES Dim_State(State_SK),
	Is_Current BIT,
    Created DATETIME,
    Last_Updated DATETIME,
	Source_SK INT FOREIGN KEY REFERENCES Dim_Sources(Source_SK)
);

INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Dim_County', '1/1/2020', '1/1/2020');

GO
-- Dimension Table: Dim_Category
DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_Category;
CREATE TABLE PROJECT_DDS.dbo.Dim_Category (
    Category_SK INT PRIMARY KEY,
    Category VARCHAR(50) UNIQUE,
    Source_SK INT FOREIGN KEY REFERENCES Dim_Sources(Source_SK),
	Value_From INT NOT NULL,
    Value_To INT NOT NULL,
    Color VARCHAR(20) NOT NULL,
    Description VARCHAR(500),
	Is_Current BIT,
    Created DATETIME,
    Last_Updated DATETIME
);

INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Dim_Category', '1/1/2020', '1/1/2020');

GO

-- Dimension Table: Dim_Parameter
DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_Parameter;
CREATE TABLE PROJECT_DDS.dbo.Dim_Parameter (
    Parameter_SK INT PRIMARY KEY,
    Defining_Parameter VARCHAR(50) UNIQUE,
    Source_SK INT FOREIGN KEY REFERENCES Dim_Sources(Source_SK),
    Is_Current BIT,
    Created DATETIME,
    Last_Updated DATETIME
);

INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Dim_Parameter', '1/1/2020', '1/1/2020');

GO

-- Dimension Table: Dim_Site
DROP TABLE IF EXISTS PROJECT_DDS.dbo.Dim_Site;
CREATE TABLE PROJECT_DDS.dbo.Dim_Site (
    Site_SK INT PRIMARY KEY,
    Defining_Site VARCHAR(50) UNIQUE,
    Source_SK INT FOREIGN KEY REFERENCES Dim_Sources(Source_SK),
	Is_Current BIT,
    Created DATETIME,
    Last_Updated DATETIME
);
--SELECT * FROM PROJECT_DDS.dbo.Dim_Site;

INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Dim_Site', '1/1/2020', '1/1/2020');

GO
-- Fact Table: Fact_AQI
DROP TABLE IF EXISTS PROJECT_DDS.dbo.Fact_AQI;
CREATE TABLE PROJECT_DDS.dbo.Fact_AQI (
    AQI_SK INT PRIMARY KEY,
    County_SK INT FOREIGN KEY REFERENCES Dim_County(County_SK),
    Category_SK INT FOREIGN KEY REFERENCES Dim_Category(Category_SK),
    Parameter_SK INT FOREIGN KEY REFERENCES Dim_Parameter(Parameter_SK),
    Site_SK INT FOREIGN KEY REFERENCES Dim_Site(Site_SK),
    Source_SK INT FOREIGN KEY REFERENCES Dim_Sources(Source_SK),
    Date_SK INT FOREIGN KEY REFERENCES Dim_Date(Date_SK),
    AQI INT,
    Number_of_Sites_Reporting INT,
	Is_Current BIT,
    Created DATETIME,
    Last_Updated DATETIME
);
GO

INSERT INTO PROJECT_metadata.dbo.data_flow (name, LSET, CET)
VALUES ('Fact_AQI', '1/1/2020', '1/1/2020');

--SELECT COUNT(*) FROM PROJECT_DDS.dbo.Fact_AQI

-- Added for Data Analysis requirements
ALTER TABLE PROJECT_DDS.dbo.Dim_Date 
ADD DayLightSaving AS 
    CASE 
        WHEN Full_Date BETWEEN '2023-03-12' AND '2023-11-05' THEN CAST(1 AS BIT)
        ELSE CAST(0 AS BIT)
    END;

ALTER TABLE PROJECT_DDS.dbo.Fact_AQI ADD AQI_Squared AS (AQI * AQI);
