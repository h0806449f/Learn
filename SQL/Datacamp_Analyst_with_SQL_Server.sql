--
-- Introduction to SQL Server   ### FINISHED ###
--
-- 1 複習基本Query
SELECT TOP(5) column_1
  FROM table_1;

SELECT TOP(5) PERCENT column_1   -- 5%
  FROM table_1;

SELECT LEN(column_1) AS length_of_column_1   -- length
  FROM table_1;

SELECT LEFT(column_1, 20) AS first_20_left_of_column_1   -- 選取特定字串
  FROM table_1;

SELECT RIGHT(column_1, 20) AS last_20_left_of_column_1   -- 選取特定字串
  FROM table_1;

SELECT CHARINDEX('想找的字',column_1) AS char_location   -- 特定字串的 index
  FROM table_1;
/*
SELECT description, 
       CHARINDEX('Weather', description) 
  FROM grid
 WHERE description LIKE '%Weather%';
*/

SELECT SUBSTRING(column_1, 從第幾個字開始, 選取幾個字) AS target_section   -- substring
  FROM table_1;
/*
SELECT TOP (10) description, 
       CHARINDEX('Weather', description) AS start_of_string,                    -- 找到weather起點
       LEN ('Weather') AS length_of_string,                                     -- 算出weather長度
       SUBSTRING(description, 15, LEN(description)) AS additional_description   -- 篩選weather 後的資料
  FROM grid
 WHERE description LIKE '%Weather%';
*/

SELECT REPLACE(column_1, 想換掉的資料, 新資料) AS replace_with
  FROM table_1;

SELECT column_1
  FROM table_1

UNION               -- 將兩 table 加在一起，不會有重複的值
UNION ALL           -- 將兩 table 加在一起

SELECT column_2
  FROM table_2;

 -- create table / insert / update / delete
CREATE TABLE table_3(
    column_1 datatype_1,
    column_2 datatype_2,
    column_3 datatype_3
)

INSERT INTO table_3 (column_1, column_2, column_3)
VALUES ('value_1', 'value_2', value_3)

-- 也可以從其他 table 中，插入資料 (從table_1 篩選資料後，放置到 table_3)
INSERT INTO table_3 (column_1, column_2, column_3)
SELECT column_1,
       column_2,
       column_3
  FROM table_1
 WHERE condition_1;

UPDATE table_3
   SET column_1 = value_1
 WHERE condition_1               -- UPDATE 必須指定條件，否則會 update 全部資料

DELETE
  FROM table_3
 WHERE condition_1               -- DELETE 也必須指定條件，否則會刪除所有資料

-- Variable 在SQL中設置變數，避免重複輸入SLEECT ... FROM ... WHERE ... 

DECLARE @test_int INT   -- 指定 變數  該變數的資料型態
SET @test_int = 5       -- 設定變數為 : 5

DECLARE @my_artist VARCHAR(100)   -- 指定 變數 資料型態 : VARCHAR(100)
SET @my_artist = 'Henry Lee'      -- 設定變數為 : Henry Lee

--
DECLARE @my_artist VARCHAR(100)
DECLARE @my_album VARCHAR(100);

SET @my_artist = 'Henry Lee'          
SET @my_album = 'Fate Grand Order'

SELECT --
  FROM --
 WHERE artist = @my_artist AND album = @my_album;

-- 從其他 table 中篩選資料，至 temporary table
SELECT column_1,
       column_2,
       column_3 INTO #my_temp_table
  FROM table_1
 WHERE condition_1;

DROP TABLE #my_temp_table

--
-- Declare your variables
DECLARE @start DATE
DECLARE @stop DATE
DECLARE @affected INT;

SET @start = '2014-01-24'
SET @stop  = '2014-07-02'
SET @affected =  5000 ;

SELECT description, nerc_region, demand_loss_mw, affected_customers
  FROM grid
 WHERE event_date BETWEEN @start AND @stop
   AND affected_customers >= @affected;          -- 使用自行設置的變數

-- TEMP table
SELECT album.title AS album_title,
       artist.name as artist,
       MAX(track.milliseconds / (1000 * 60) % 60 ) AS max_track_length_mins
       INTO #maxtracks
  FROM album
 INNER JOIN artist ON album.artist_id = artist.artist_id
 INNER JOIN track ON album.album_id = track.album_id
 GROUP BY artist.artist_id, album.title, artist.name,album.album_id

SELECT album_title, artist, max_track_length_mins
FROM  #maxtracks
ORDER BY max_track_length_mins DESC, artist;

--
-- Introduction to Relational Databases in SQL   ### FINISHED ###
--
-- 1 檢視資料庫資訊   (default in PostgreSQL)
SELECT *                           -- 固定
  FROM information_schema.tables   -- 檢視tables 如要檢視column -> information_schema.columns
 WHERE     -- 想要尋找的條件

-- 1.1 練習
CREATE TABLE professors (
 firstname text,
 lastname text
);

ALTER TABLE professors                     -- 事後增加欄位
ADD COLUMN university_shortname TEXT;

ALTER TABLE professors                     -- 事後變更欄位名稱
RENAME COLUMN 'old_name' TO 'new_name';

ALTER TABLE professors                     -- 事後刪除欄位
DROP COLUMN column_name;

-- 1.2 練習
-- 從 university_professors 中，篩選不重複的資料，更新至 affiliations 中
INSERT INTO affiliations 
SELECT DISTINCT firstname, lastname, function, organization 
  FROM university_professors;

-- 2 CAST
SELECT transaction_date,
       amount + CAST(fee AS INT) AS net_amount   -- CAST 更改資料型態
  FROM transactions;

-- NUMERIC(3.2)    此浮點數，一共 3 位數，小數點後面 2 位數

-- 3 更改欄位的資料限制
ALTER TABLE table_1
ALTER COLUMN column_1
TYPE '想要變更成什麼資料型態';

ALTER TABLE professors
ALTER COLUMN university_shortname
TYPE CHAR(3);

ALTER TABLE professors 
ALTER COLUMN firstname 
TYPE varchar(16)                              -- 如有些 firstname 大於16，會出現錯誤
USING SUBSTRING(firstname FROM 1 FOR 16)      -- SUBSTRING，擷取 從 1-16 單字

-- 3.1 更改欄位的資料限制 (NOT NULL / UNIQUE)
CREATE TABLE table_3(
    column_1 INT NOT NULL,
    column_2 VARCHAR(64) NOT NULL,
    column_3 ...   
);

ALTER TABLE table_3
ALTER COLUMN column_3
SET NOT NULL;

ALTER TABLE table_3
ALTER COLUMN column_3
DROP NOT NULL;                  -- 移除 NOT NULL的限制

CREATE TABLE table_3(
    column_1 UNIQUE,            -- UPIQUE constraints
    column_2 ...
);

ALTER TABLE table_3
ADD CONSTRAINT some_name UNIQUE(column_1);   -- some_name : 是設置方自己給該 CONSTRAINT 一個名字

-- 3.2 練習
ALTER TABLE professors
ALTER COLUMN lastname SET NOT NULL;

ALTER TABLE universities
ADD CONSTRAINT university_shortname_unq UNIQUE(university_shortname);

ALTER TABLE organizations
ADD CONSTRAINT organization_unq UNIQUE(organization);

-- 3.3 練習
ALTER TABLE organizations
RENAME COLUMN organization TO id;                    -- RENAME 更改欄位名稱

ALTER TABLE organizations
ADD CONSTRAINT organization_pk PRIMARY KEY (id);     -- 設置 PRIMARY KEY

--
ALTER TABLE universities
RENAME university_shortname TO id;

ALTER TABLE universities
ADD CONSTRAINT university_pk PRIMARY KEY(id);

-- 4 SURROGATE   當無法使用單一 column 為PK時，可以設置SURROGATE KEY as PK
ALTER TABLE table_3
ADD COLUMN id SERIAL PRIMARY KEY;          -- 2. 增加一個欄位，as PK

INSERT INTO table_3                        -- 1. table_3 中，僅有三個欄位
VALUES ('test_1','test_2','test_3');

-- 4.1 練習
ALTER TABLE professors 
ADD COLUMN id serial;

ALTER TABLE professors 
ADD CONSTRAINT professors_pkey PRIMARY KEY (id);

--
SELECT COUNT(DISTINCT(make, model)) 
FROM cars;

ALTER TABLE cars                      -- 新增欄位
ADD COLUMN id varchar(128);           -- 設置新增欄位的資料屬性(須小寫)

UPDATE cars                           -- 新增欄位內資料
SET id = CONCAT(make, model);         -- SET column_1 = CONCAT

ALTER TABLE cars                      -- 將該欄位設置成為PK
ADD CONSTRAINT id_pk PRIMARY KEY(id); -- add constraint

-- 4.2 複習
CREATE TABLE students (
  last_name VARCHAR(128) NOT NULL,
  ssn INTEGER PRIMARY KEY,
  phone_no CHAR(12)
);

-- 4.3 練習
ALTER TABLE professors
RENAME COLUMN university_shortname TO university_id;

ALTER TABLE  professors
ADD CONSTRAINT professors_fkey FOREIGN KEY (university_id)       -- 設置 PK
                               REFERENCES universities (id);     -- 設置 FK

-- 5 FOREIGN KEY
ALTER TABLE table_3
ADD CONSTRAINT some_name FOREIGN KEY (column in table_3) REFERENCSE table_1(column_1)


ALTER TABLE affiliations
ADD CONSTRAINT affiliations_organization_fkey FOREIGN KEY (organization_id) REFERENCES organizations(id);

--
-- Intermediate SQL Server   ### FINISHED ###
--
-- 1 處理 NULL 值 (ISNULL function / COALESCE function)
SELECT(ISNULL(column_1,'unknown_value'))   -- 如column_1為NULL，以 unknown_value 取代
SELECT(ISNULL(column_1,column_2))          -- 如column_1為NULL，以 column_2 的值 取代

COALESCE(column, column_1, column_2 ...)   -- 如column為NULL，返還column_1值;column_1為NULL，返還column_2

-- !!! ISNULL 僅能處理兩個值 / COALESCE 可以有多個替代的值

-- 2 DATE (T-SQL)
DATEADD (DATEPART, number, date) -- DAREPART 時間單位 / number 想增加的單位 / date 時間值

DATEADD (DD, -30, '2022-12-24')

DATEDIFF (DATEPART, startdate, enddate)

-- 2.1 練習
SELECT OrderDate, 
       DATEADD(DD,5,ShipDate) AS DeliveryDate
  FROM Shipments;

SELECT OrderDate,
       ShipDate, 
       DATEDIFF(DD, OrderDate, ShipDate) AS Duration
  FROM Shipments

-- 3 運算
SELECT WeightValue, 
       SQUARE(WeightValue) AS WeightSquare,   -- 平方
       SQRT(WeightValue) AS WeightSqrt        -- 開根號
  FROM Shipments

-- 4 WHILE LOOPS IN SQL
Variable in SQL

DECLARE @variable datatype     -- datatype 複習 1 DECIMAL(total_number, point_number) / NUMERIC()
SET @variable = '值'

--
DECLARE @test INT
SET @test = 1

WHILE @test < 10
      BEGIN SET @test = @test + 1
      END 

SELECT @test                        -- 將返還 10

--
DECLARE @test INT
SET @test = 1

WHILE @test < 10
      BEGIN SET @test = @test + 1

      IF @test = 4
      BREAK

      END

SELECT @test                        -- 將返還 4

-- 4.1 練習
DECLARE @counter INT 
SET @counter = 20

WHILE @counter < 30
BEGIN SELECT @counter = @counter + 1
END

SELECT @counter

-- 5 DERIVE TABLE (類似之前的 subquery in FROM clause)
SELECT a.RecordId,
       a.Age,
       a.BloodGlucoseRandom, 
       b.MaxGlucose
  FROM Kidney a
  JOIN (
        SELECT Age,
               MAX(BloodGlucoseRandom) AS MaxGlucose
          FROM Kidney
         GROUP BY Age) b
    ON a.age = b.age

-- 5.1 練習
SELECT *
  FROM Kidney a
  JOIN (SELECT age,
               MAX(BloodPressure) AS MaxBloodPressure
          FROM Kidney
         GROUP BY age) b
    ON a.BloodPressure = b.MaxBloodPressure 
   AND a.age = b.age

-- 6 CTE
WITH CTEtable (column_1, column_2)     -- 從現有 table query 資料，儲存到 CTE table
AS (
  SELECT column_1,
         column_2
    FROM table_1
);

-- 6.1 練習
WITH BloodGlucoseRandom (MaxGlucose) 
AS (
    SELECT MAX(BloodGlucoseRandom) AS MaxGlucose
      FROM Kidney
   )

SELECT a.Age, b.MaxGlucose
  FROM Kidney a
  JOIN BloodGlucoseRandom b ON a.BloodGlucoseRandom = b.MaxGlucose;

-- 7 WINDOW function
-- common WINDOW functions (FIRST_VALUE() / LAST_VALUE() / LEAD() / LAG() )
-- LEAD() : returned next calue / LAG() : returned last value

SELECT TerritoryName,
       OrderDate, 
       LAG(OrderDate) OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS FirstOrder
  FROM Orders;

--
SELECT TerritoryName, OrderDate, 
       LAG(OrderDate) OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS PreviousOrder,
       LEAD(OrderDate) OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS NextOrder
  FROM Orders;

-- 7.1 WINDOW function - ROW_NUMBER()
-- 依照PARTITION BY 標的，給上編號
SELECT TerritoryName,
       OrderDate, 
       ROW_NUMBER() OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS OrderCount
  FROM Orders;

-- 8 計算 standard deviation
SELECT OrderDate,
       TerritoryName, 
	     STDEV(OrderPrice) OVER(PARTITION BY TerritoryName ORDER BY OrderDate) AS StdDevPrice	  
  FROM Orders;

--
-- Time Series Analysis in SQL Server   ### FINISHED ###
--
-- 1 building date
SELECT GETDATE() AS DateTime_LTz,     -- 當地時間
       GETUTCDATE() AS DateTime_UTC   -- 格林威治標準時間

-- 選取特定時間區段
SELECT DATEPART(YEAR, column_1) AS TheYear;
--或
SELECT DATENAME(MONTH, column_1) AS TheMonth;

-- DATEADD
SELECT DATEADD('時間單位', '數量', column_1) AS ...

SELECT DATEADD(DAY, 1, column_1) AS NextDay;

-- DATEDIFF
SELECT DATEDIFF('時間單位', column_1, column_2) AS    -- 計算兩個欄位的時間差

-- 1.1 練習
DECLARE @SomeTime DATETIME2(7) = SYSUTCDATETIME();   -- DATETIME2(7) 為TSQL中的一種時間資料型態

SELECT YEAR(@SomeTime) AS TheYear,
	     MONTH(@SomeTime) AS TheMonth,
	     DAY(@SomeTime) AS TheDay;

-- 1.2 練習 - 多種時間單位
SELECT
	DATEPART(YEAR, @BerlinWallFalls) AS TheYear,
	DATEPART(MONTH, @BerlinWallFalls) AS TheMonth,
	DATEPART(DAY, @BerlinWallFalls) AS TheDay,
	DATEPART(DAYOFYEAR, @BerlinWallFalls) AS TheDayOfYear,
	DATEPART(WEEKDAY, @BerlinWallFalls) AS TheDayOfWeek,
	DATEPART(WEEK, @BerlinWallFalls) AS TheWeek,
	DATEPART(SECOND, @BerlinWallFalls) AS TheSecond,
	DATEPART(NANOSECOND, @BerlinWallFalls) AS TheNanosecond;

-- 2 FORMATTING DATE (CAST)
SELECT CAST(column_1 AS datatype) AS ...

-- 3 DATES FROM PARTS (only for TSQL) 撰寫格式
DATEFROMPARTS(year, month, day)
TIMEFROMPARTS(hour, minute, second, fraction, precision)

DATETIMEFROMPARTS(year, month, day, hour, minute, second, ms)
DATETIME2FROMPARTS(year, month, day, hour, minute, second, fraction, precision)

SELECT DATETIMEFROMPARTS(year, month, day, hour, minute, second, ms) AS '其中一個時區的時間'
       DATETIMEFROMPARTS(year, month, day, hour, minute, second, ms) AT TIME ZONE '時區' AS '時區名'
       -- 轉換至指定時區的時間

-- 3.1 練習
SELECT d.DateText AS String,
       CAST(d.DateText AS DATE) AS StringAsDate,
	     CAST(d.DateText AS DATETIME2(7)) AS StringAsDateTime2
  FROM dbo.Dates d;

-- 3.2 練習
SET LANGUAGE 'GERMAN'

SELECT d.DateText AS String,
	   CONVERT(DATE, d.DateText) AS StringAsDate,
	   CONVERT(DATETIME2(7), d.DateText) AS StringAsDateTime2
  FROM dbo.Dates d;

-- 3.3 練習
SELECT d.DateText AS String,
       PARSE(d.DateText AS DATE USING 'de-de') AS StringAsDate,
	     PARSE(d.DateText AS DATETIME2(7) USING 'de-de') AS StringAsDateTime2
  FROM dbo.Dates d;

-- 4 更改時區 (SWITCHOFFSET)
SELECT SWITCHOFFSET(column_1, 'timezone') AS column_2;

-- 5 CAST() vs. TRY_CAST()
-- 就算 QUERY 部分出錯，使用 TRY_CAST 仍然可以反還可以正確計算的資料；無法計算的資料會呈現 NULL

-- 6 AGGREGATION function & CASE WHEN function 的合併使用
-- 可以計算達成指定條件的資料數量!!!
SELECT it.IncidentType,
       SUM(CASE WHEN ir.NumberOfIncidents > 5 THEN 1 ELSE 0 END) AS NumberOfBigIncidentDays,
       -- 當符合條件，加1。
       SUM(CASE WHEN ir.NumberOfIncidents <= 5 THEN 1 ELSE 0 END) AS NumberOfSmallIncidentDays
       -- 當符合條件，加1。
  FROM dbo.IncidentRollup ir
 INNER JOIN dbo.IncidentType it
		ON ir.IncidentTypeID = it.IncidentTypeID
 WHERE ir.IncidentDate BETWEEN '2019-08-01' AND '2019-10-31'
 GROUP BY it.IncidentType;

-- 7 ROUND TIME
SELECT DATEADD(HOUR, DATEDIFF(HOUR, 0, 'somedate'),0) as 'new_somedate'
  FROM table

-- 理解順序 : DATEDIFF 計算小時差，所以小於小時的單位，會被捨棄
--           DATEADD (DD, -30, '2022-12-24')
--           後用DATEADD ('時間單位須相同', 'DATEDIFF計算出來的時間差', '時間起點'or column)
-- 需複習

-- 8 WITH ROLLUP   滾動加總，但不懂加總邏輯
SELECT c.CalendarYear,
       c.CalendarQuarterName,
	     c.CalendarMonth,
	     SUM(ir.NumberOfIncidents) AS NumberOfIncidents
  FROM dbo.IncidentRollup ir
 INNER JOIN dbo.Calendar c ON ir.IncidentDate = c.Date
 WHERE ir.IncidentTypeID = 2
 GROUP BY c.CalendarYear, c.CalendarQuarterName, c.CalendarMonth
  WITH ROLLUP
 ORDER BY c.CalendarYear, c.CalendarQuarterName, c.CalendarMonth;

SELECT ir.IncidentTypeID,
       c.CalendarQuarterName,
	     c.WeekOfMonth,
	     SUM(ir.NumberOfIncidents) AS NumberOfIncidents
  FROM dbo.IncidentRollup ir
 INNER JOIN dbo.Calendar c ON ir.IncidentDate = c.Date
 WHERE ir.IncidentTypeID IN (3, 4)
 GROUP BY ir.IncidentTypeID, c.CalendarQuarterName, c.WeekOfMonth
  WITH CUBE
 ORDER BY ir.IncidentTypeID, c.CalendarQuarterName, c.WeekOfMonth;

 -- 9 WINDOW function (ROW_NUMBER() / RANK() / DENSE_RANK())
SELECT ir.IncidentDate,
       ir.NumberOfIncidents,
	     ROW_NUMBER() OVER (ORDER BY ir.NumberOfIncidents DESC) AS rownum,
	     RANK() OVER (ORDER BY ir.NumberOfIncidents DESC) AS rk,
	     DENSE_RANK() OVER (ORDER BY ir.NumberOfIncidents DESC) AS dr
  FROM dbo.IncidentRollup ir
 WHERE ir.IncidentTypeID = 3 AND ir.NumberOfIncidents >= 8
 ORDER BY ir.NumberOfIncidents DESC;

--
SELECT ir.IncidentDate,
       ir.NumberOfIncidents,
       SUM(ir.NumberOfIncidents) OVER () AS SumOfIncidents,
       MIN(ir.NumberOfIncidents) OVER () AS LowestNumberOfIncidents,
       MAX(ir.NumberOfIncidents) OVER () AS HighestNumberOfIncidents,
       COUNT(ir.NumberOfIncidents) OVER () AS CountOfIncidents
  FROM dbo.IncidentRollup ir
 WHERE ir.IncidentDate BETWEEN '2019-07-01' AND '2019-07-31'
   AND ir.IncidentTypeID = 3;

-- 9.1 WINDOW function (PARTITION BY)
SELECT ir.IncidentDate,
       ir.IncidentTypeID,
       ir.NumberOfIncidents,
       SUM(ir.NumberOfIncidents) OVER (PARTITION BY ir.IncidentTypeID ORDER BY ir.IncidentDate)
                                   AS NumberOfIncidents
  FROM dbo.IncidentRollup ir
 INNER JOIN dbo.Calendar c ON ir.IncidentDate = c.Date
 WHERE c.CalendarYear = 2019 AND c.CalendarMonth = 7 AND ir.IncidentTypeID IN (1, 2)
 ORDER BY ir.IncidentTypeID, ir.IncidentDate;

-- 10 WINDOW function (lag() / lead())
SELECT ir.IncidentDate,
       ir.IncidentTypeID,
	     LAG(ir.IncidentTypeID, 1) OVER (PARTITION BY ir.NumberOfIncidents ORDER BY ir.IncidentDate)
                                   AS PriorDayIncidents,
	     ir.NumberOfIncidents AS CurrentDayIncidents,
	     LEAD(ir.IncidentTypeID, 1) OVER (PARTITION BY ir.NumberOfIncidents ORDER BY ir.IncidentDate)
                                    AS NextDayIncidents
  FROM dbo.IncidentRollup ir
 WHERE ir.IncidentDate >= '2019-07-02' AND ir.IncidentDate <= '2019-07-31' AND ir.IncidentTypeID IN (1, 2)
 ORDER BY ir.IncidentTypeID, ir.IncidentDate;

-- 10.1 練習
SELECT ir.IncidentDate,
       ir.IncidentTypeID,
       DATEDIFF(DAY, LAG(ir.IncidentDate, 1) OVER (PARTITION BY ir.IncidentTypeID ORDER BY ir.IncidentDate),ir.IncidentDate)
                                               AS DaysSinceLastIncident,
       DATEDIFF(DAY, ir.IncidentDate, LEAD(ir.IncidentDate, 1) OVER (PARTITION BY ir.IncidentTypeIDORDER BY ir.IncidentDate))
                                                                 AS DaysUntilNextIncident
  FROM dbo.IncidentRollup ir
 WHERE ir.IncidentDate >= '2019-07-02' AND ir.IncidentDate <= '2019-07-31' AND ir.IncidentTypeID IN (1, 2)
 ORDER BY ir.IncidentTypeID, ir.IncidentDate;

--
-- Functions for Manipulating Data in SQL Server   ### FINISHED ###
--
-- 1 新增資料欄位
ALTER TABLE 'table_name'
ADD 'column_name' 'data_type';

ALTER TABLE voters
ADD last_vote_date date;

-- 2 轉換資料型態 (CAST() / CONVERT())
CAST('expression' AS 'data_type' [('length')])

CONVERT('datatype' [('length')], 'expression', [('style')]) -- style 用以指定特殊資料型態

--
SELECT first_name + ' ' + last_name + ' was born in ' + 
       CAST(YEAR(birthdate) AS nvarchar) + '.'
       -- 取 birthdate 欄位的年份資料，轉換為 nvarchar
FROM voters;

--
SELECT CAST(total_votes/5.5 AS INT) AS DividedVotes         -- 欄位資料 除5.5，轉換為 integer
FROM voters;
 
--
SELECT email,
       CONVERT(varchar, birthdate, 107) AS birthdate        -- style:107 為特殊資料型態
  FROM voters;

--
SELECT company, bean_origin,
       CONVERT(int,rating) AS rating
FROM ratings;

--
SELECT company, bean_origin, rating
  FROM ratings
 WHERE CONVERT(int,rating) = 3;               -- 也可以用於 where 

-- 3 function of returning system date and system time
SYSDATETIME()
SYSUTCDATETIME()      -- UTC
SYSDATETIMEOFFSET()   -- OFFSET 可以拿到TIME ZONE，以上方式較為精確

GETDATE()
GETUTCDATE()
CURRENT_TIMESTAMP

-- 4 YEAR() / MONTH() / DAY() / DATENAME()
SELECT YEAR(column_1) AS yesr,
       MONTH(column_1) AS month,
       DAY(column_1) AS day,
       DATENAME(YEAR, column_1) AS year_name,
       DATENAME(MONTH, column_1) AS month_name,   -- January ...
       DATENAME(DAY, column_1) AS day_name,
       DATENAME(WEEKDAY, column_1) AS weekday     -- Monday ...
    
-- DATEPART() 寫法與功能，都類似 DATENAME()
-- 差別 DATEPART 將返還 INT 資料型態

--
SELECT DATEFROMPARTS(2022,3,12) AS new_date;       -- 指定日期 ('year','month',day)

--
SELECT first_name,
       last_name,
       first_vote_date,
       DATENAME(MONTH,first_vote_date) AS first_vote_month_name,      --month name
       DATENAME(DAYOFYEAR,first_vote_date) AS first_vote_dayofyear,   --day of year
       DATENAME(WEEKDAY,first_vote_date) AS first_vote_dayofweek      -- day of week
  FROM voters;

-- DATEFROMPARTS
SELECT first_name,
       last_name,
       YEAR(first_vote_date) AS first_vote_year, 
       MONTH(first_vote_date) AS first_vote_month,
       DATEFROMPARTS(YEAR(first_vote_date), MONTH(first_vote_date), 1) AS first_vote_starting_month
FROM voters;

-- DATE OPERATION
SELECT DATEADD('時間單位', '數量', column_1) AS ...;

SELECT DATEDIFF('時間單位', column_1, column_2) AS ...;

-- 5 驗證該欄位的資料型態是否為 DATE
ISDATE(column_1) AS ...;
-- 返還 1 : 資料型態是 DATE ; 返還 0 : 資料型態不是 DATE

DECLARE @date_1 NVARCHAR(20) = '12-30-2019'
DECLARE @date_2 NVARCHAR(20) = '30-12-2019'

--
SET DATEFORMAT dmy;
SELECT ISDATE(@date_1) AS invalid_dmy,   -- -> 0
       ISDATE(@date_2) AS valid_dmy;     -- -> 1

--
SET LANGUAGE XXX;                        -- 時間格式會隨語言地區而改變

-- 5.1 練習
DECLARE @date1 NVARCHAR(20) = '30.03.2019';  -- 設置時間

SET LANGUAGE Dutch;                          -- 設置時區。荷蘭時間表示方法同上。
SELECT
	@date1 AS initial_date,                    -- 選取欄位資料
	ISDATE(@date1) AS is_valid,                -- 驗證是否為時間格式
	DATENAME(MONTH,@date1) AS month_name;      -- print 月份名稱 march = maart

-- 5.2 練習
DECLARE @date1 NVARCHAR(20) = '32/12/13';

SET LANGUAGE Croatian;
SELECT
	@date1 AS initial_date,
	ISDATE(@date1) AS is_valid,
	DATENAME(MONTH,@date1) AS month_name,
	YEAR(@date1) AS year_name,
	DATENAME(YEAR,@date1) AS year_name_1;

-- 5.3 練習
DECLARE @date1 NVARCHAR(20) = '12/18/55';

SET LANGUAGE English;
SELECT
	@date1 AS initial_date,
	ISDATE(@date1) AS is_valid,
	DATENAME(weekday,@date1) AS week_day,
	YEAR(@date1) AS year_name;

-- 5.4 練習
SELECT first_name,
       last_name,
       birthdate,
       first_vote_date,
       DATENAME(weekday, first_vote_date) AS first_vote_weekday,
       -- locate weekday
       YEAR(first_vote_date) AS first_vote_year,
       -- locate year
       DATEDIFF(YEAR, birthdate, first_vote_date) AS age_at_first_vote,	
       -- locate voter's age when first vote
       DATEDIFF(YEAR, birthdate, CURRENT_TIMESTAMP) AS current_age
       -- locate voter's current age
  FROM voters;

-- 6 POSITION function (len() / charindex() / patindex())

select len(column_1) AS column_1_length
       CHARINDEX('expression_to_find', 'expression_to_search' [, start_location]),
       -- 會返還 expression_to_find的起點位子。如無符合資料，將返還 0 。
       PATINDEX('expression_to_find', 'expression_to_search')   -- 將返還資料 index
       -- PATINDEX 可以使用 wildcard like : %, _, [] 。

-- 6.1 練習
SELECT TOP 10
       company,
	     broad_bean_origin,
	     len(broad_bean_origin) AS length
  FROM ratings
 ORDER BY length DESC;

-- 6.2 練習
SELECT first_name,
       last_name,
       email 
  FROM voters
 WHERE CHARINDEX('dan', first_name) > 0    -- 尋找 first_name 中有 dan
   AND CHARINDEX('z', last_name) > 0       -- 尋找 last_name 中有 z
	 AND CHARINDEX('z',last_name) = 0;       -- 尋找 last_name 中沒有z

-- 6.3 練習
SELECT first_name,
       last_name,
       email,
       patindex('%rr%',first_name) AS verify_test
  FROM voters
 WHERE patindex('%rr%',first_name) > 0;
       -- 由於是返還資料 index 需要指定條件 > 0
       -- 如無相符合資料，則需要指定條件 = 0 

-- 6.4 練習
SELECT first_name,
       last_name,
       email 
  FROM voters
 WHERE PATINDEX('C_r%',first_name)>0;

-- 6.5 練習   
SELECT first_name,
       last_name,
       email 
  FROM voters
 WHERE PATINDEX('%[xwq]%',first_name) > 0;
       -- first_name 中包含 x, w, q 任何一個字母

-- 7 STRING transformation function
--   LOWER() / UPPER()
--   LEFT('expression','number_of_characters') / RIGHT() 
--   LTRIM() / RTRIM() / TRIM()
--   REPLACE('expression', 'search', 'replace the sreach')
--   SUBSTRING('expression', 'start', 'how_many_want_to_extract')

-- 8 STRING
--   CONCAT(column_1, column_2)
--   CONCAT_WS('分隔符號', column_1, column_2)

-- STRING_AGG(column_1, '分隔符號') AS ...
-- 將把 column_1 中，所有的資料整合 (垂直向)

SELECT YEAR(first_vote_date) AS voting_year,
       STRING_AGG(first_name, ', ') WITHIN GROUP (ORDER BY first_name ASC) AS voters
       -- 在整合的資料中，將資料按照 first_name 字母順序排列。 注意欄位名稱需一致。
  FROM voters
 GROUP BY YEAR(first_vote_date);

-- STRING_SPLIT(column_1,'分隔符號')

-- 8.1 練習
DECLARE @string1 NVARCHAR(100) = 'Chocolate with beans from';
DECLARE @string2 NVARCHAR(100) = 'has a cocoa percentage of';

SELECT bean_type,
       bean_origin,
	     cocoa_percent,
	     @string1 + ' ' + bean_origin + ' ' + @string2 + ' ' + CAST(cocoa_percent AS nvarchar) AS message1
       -- 可以用 + 把各個資料加在一起，但會比較混亂，如上。
       CONCAT(@string1, ' ', bean_origin, ' ', @string2, ' ', cocoa_percent) AS message2
       -- 使用 CONCAT()，效果同上。
       CONCAT_WS(' ', @string1, bean_origin, @string2, cocoa_percent) AS message3
       -- 使用 CONCAT_WS()，效果同上。
  FROM ratings
 WHERE company = 'Ambrosia' AND bean_type <> 'Unknown';

-- 8.2 練習
SELECT company,
       STRING_AGG(bean_origin, ',') WITHIN GROUP (ORDER BY bean_origin) AS bean_origins
       -- 將以 company 為區別，列出各個公司，全部的咖啡豆產地。並依產地字母排列。
  FROM ratings
 WHERE company IN ('Bar Au Chocolat', 'Chocolate Con Amor', 'East Van Roasters')
 GROUP BY company;

-- 8.3 練習
DECLARE @phrase NVARCHAR(MAX) = 
'In the morning I brush my teeth. In the afternoon I take a nap. In the evening I watch TV.'
-- 宣告變數 @phrase

SELECT value
       -- 思考順序_2 : 將取出的值，儲存到 value 欄位
  FROM STRING_SPLIT(@phrase,'.');
       -- 思考順序_1 : STRING_SPLIT 會將取出的值，儲存為類似 table 的資料型態。

-- 8.4 練習
SELECT CONCAT('***' , first_name, ' ', UPPER(last_name), '***') AS name,
       REPLACE(birthdate, SUBSTRING(CAST(birthdate AS varchar), 3, 2), 'XX') AS birthdate,
       -- 將出生年月日中，年份的末兩碼，改變為：XX。 -> 1991-05-2 -> 19xx-05-02
       -- 思考順序_1 : 轉變 birthdate 欄位資料型態
       -- 思考順序_2 : 抽取出年份末兩碼
       -- 思考順序_3 : 將數字變更為 : XX
       email,
       country
  FROM voters
 WHERE LEN(first_name) < 5 AND PATINDEX('j_a%@yahoo.com', email) > 0;
       -- 指定條件，first_name 小於5個字 and 信箱 ...

-- 9 WINDOW function - FIRST_VALUE()
FIRST_VALUE(numeric_expression) OVER([PARTITION BY column_1] ORDER BY column_1 ROW_or_RANGE frame)
LAST_VALUE(numeric_expression) OVER([PARTITION BY column_1] ORDER BY column_1 ROW_or_RANGE frame)
     
--   PARTITION BY limits
RANGE BETWEEN start_boundary AND end_boundary
ROWS BETWEEN start_boundary AND end_boundary
--   boundary             | description
--------------------------|---------------------------
--   UNBOUNDED PRECEDINIG | first row in the partition
--   UNBOUNDED FOLLOWING  | last row in the partition
--   CURRENT ROW          | crrrent row
--   PRECEDING            | previous row
--   FOLLOWING            | next row

SELECT gender,
       total_votes AS votes,
       FIRST_VALUE(total_votes) OVER (PARTITION BY gender ORDER BY total_votes) AS min_votes,
       -- 依性別分組，計算各性別總投票數，資料範圍：全部(因沒有指定，固取全部)，並取第一行(最小值)。
       LAST_VALUE(total_votes) OVER (PARTITION BY gender ORDER BY total_votes
                                     ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED PRECEDING)
                                     AS max_votes
       -- 邏輯同上，但資料範圍有特別指定 : ROWS BETWEEN 起點 AND 終點 
  FROM voters;

-- 9.1 練習
SELECT first_name + ' ' + last_name AS name,
       country,
       birthdate,
       FIRST_VALUE(birthdate) OVER (PARTITION BY country ORDER BY birthdate) AS oldest_voter,
       LAST_VALUE(birthdate) OVER (PARTITION BY country ORDER BY birthdate
                                   ROWS BETWEEN UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
				                          ) AS youngest_voter
  FROM voters
 WHERE country IN ('Spain', 'USA');

-- 10 MATHEMATICAL functions
ABS('expression')               -- 絕對值
SIGN('expression')              -- +1 : 欄位資料為正數 / 0 : 為0 / -1 : 欄位資料為負數

CEILING('expression')           -- smallest integer >= expression
FLOOR('expression')             -- largest integer <=  expression
ROUND('expression','length')    -- rounded to the length(小數點後的位數)

POWER('expression','指定次方')
SQUARE('expression')            -- 平方
SQRT('expression')              -- 根號

--
-- Database Design   ###  ###
--
-- 1 OLTP / OLAP 基礎知識
-- general speaking : OLTP -> day to day information tracking / OLAP -> business decision making
-- OLTP : write new data into database intensive
-- OLAP : read recorded data from database intensive

-- ETL & ELT  ## 參考圖示

-- 2 創造新table / 從既有 table 擷取資料 / 設置 PK & FK
CREATE TABLE dim_author (
    author varchar(256)  NOT NULL
);

INSERT INTO dim_author
SELECT DISTINCT author FROM dim_book_star;

ALTER TABLE dim_author ADD COLUMN author_id SERIAL PRIMARY KEY;

SELECT * FROM dim_author;

-- VIEW function
CREATE VIEW 'temp_table_name' AS          -- 類似暫時的table

SELECT ...                                -- 想要檢視的資料
  FROM ...
 WHERE ...

SELECT * FROM 'temp_table_name';          -- 可以重複檢視

-- 或 
SELECT * FROM INFORMATION_SCHEMA.views;   -- only for : PostgreSQL

