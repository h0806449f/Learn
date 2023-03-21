--
-- Understanding Data Visualization   ##FINISHED##
--

--
-- Introduction to Statistics   ##FINISHED##
--

--
-- Introduction to SQL   ##FINISHED##
--
-- 1. 創立暫時的table
CREATE VIEW table_name AS
SELECT id, 
       name, 
       year_hired
  FROM employees;

--
-- Intermediate SQL   ##FINISHED##
--
-- 1. COUNT() with DISTINCT
SELECT COUNT(DISTINCT birthdate) AS count_distinct_birthdates
  FROM people;

-- 2. <> not equal to 

-- 3. ROUND
-- 小數點後兩位
SELECT ROUND(AVG(column_1),2)
  FROM table_name;

-- 千
SELECT ROUND(AVG(column_1),-3)
  FROM table_name;

-- 4. HAVING   用於設置 aggregation 的條件
SELECT release_year, AVG(duration)
  FROM films
 GROUP BY release_year
HAVING AVG(duration) > 120;

--
-- Joining Data in SQL   ##FINISHED##
--
-- 1. SET OPERATION (UNION, INTERSECT, EXCEPT)
SELECT *
  FROM left_table

UNION -- UNION 全部 / INTERSECT 交集 / EXCEPT 僅 left table

SELECT *
  FROM right_table;

-- 2. SUB query
SELECT president,
       country,
       contient
  FROM presidents
 WHERE country IN -- 也可以使用 NOT IN (anti sub query)
       (
       SELECT country
         FROM states
        WHERE indep_year < 1800
       );

--
-- Data Manipulation in SQL   ##FINISHED##
--
-- 1. CASE statement
SELECT column_1,
       CASE WHEN x = 1 THEN 'a'
            WHEN x = 2 THEN 'b'
            ELSE 'c'
        END AS 'column_2'
  FROM table_name;

-- 2. 於 WHERE 中使用時，不需要使用 AS 命名
SELECT season,
       date,
       home_goal,
       away_goal
  FROM matches_italy
 WHERE CASE WHEN hometeam_id = 9857 AND home_goal > away_goal THEN 'Bologna Win'
		        WHEN awayteam_id = 9857 AND away_goal > home_goal THEN 'Bologna Win' 
	      END IS NOT NULL);

-- 3. 於 CASE 中使用 aggregate function
SELECT season,
       COUNT(CASE WHEN hometeam_id = 8650 AND home_goal > away_goal
             THEN id   -- 符合上述條件，並返還id
             END) AS home_wins   -- 將 COUNT(id) 結果，放入home_wins 欄位中
  FROM match
 GROUP BY season;

-- 4. AVG (計算百分比) ###需重新理解邏輯
SELECT c.name AS country,
       ROUND(AVG(CASE WHEN m.season='2013/2014' AND m.home_goal = m.away_goal THEN 1
			                WHEN m.season='2013/2014' AND m.home_goal != m.away_goal THEN 0
			                END),2) AS pct_ties_2013_2014,
	     ROUND(AVG(CASE WHEN m.season='2014/2015' AND m.home_goal = m.away_goal THEN 1
			                WHEN m.season='2014/2015' AND m.home_goal != m.away_goal THEN 0
			                END),2) AS pct_ties_2014_2015
  FROM country AS c
  LEFT JOIN matches AS m
    ON c.id = m.country_id
 GROUP BY country;

-- 5. Subquery in WHERE
SELECT team_long_name,
       team_short_name
  FROM team
 WHERE team_api_id IN
	     (SELECT hometeam_id
          FROM match
         WHERE home_goal >= 8);

-- 6. Subquery in FROM
SELECT country,       -- main query 是從subqyery形成的table搜尋資料，column name 需同subquery table
       date,
       home_goal,
       away_goal
  FROM (
       SELECT c.name AS country, 
     	        m.date,
              m.home_goal,
              m.away_goal,
              (m.home_goal + m.away_goal) AS total_goals
         FROM match AS m
         LEFT JOIN country AS c
           ON m.country_id = c.id
       ) AS subquery
 WHERE total_goals >= 10;

-- 7. 註解
/* 此方法可以用於多行註解
   此方法可以用於多行註解 */

-- 8. Nested subquery
SELECT
  EXTRACT (MONTH from date) AS month,   -- EXTRACT
  SUM (home_goal + away_goal) AS goals 
FROM match 
GROUP BY month;

SELECT AVG(goals)
FROM (SELECT
        EXTRACT (MONTH FROM date) AS month,   -- EXTRACT
        AVG (home_goal + away_goal) AS goals
      FROM match
      GROUP BY month
      ) AS s;

-- 9. Common Table Expressions (CTE)
WITH new_table_name AS (
  SELECT column_1, column_2
    FROM original_table
   WHERE condition
)

-- 10. WINDOW function (WINDOW function 在SQL中會最後執行)
-- 原
SELECT date,
       (home_goal + away_goal) AS total_goals,
       (SELECT AVG(home_goal + away_goal)
          FROM match
         WHERE season = '2011/2012') AS total_gogals_11_12
  FROM match
 WHERE season = '2011/2012';

 -- After WINDOW function
 SELECT date,
        (home_goal + away_goal) AS total_goals,
        AVG(home_goal + away_goal) OVER() AS total_gogals_11_12
  FROM match
 WHERE season = '2011/2012';

-- WINDOW function - RANK()，需搭配 ORDER BY 使用
SELECT date,
       (home_goal + away_goal) AS goals
       RANK() OVER(ORDER BY home_goal + away_goal DESC) AS goals_rank
       -- 執行完所有query後，RANK()開始執行，依序 order : home_goal + away_goal 然後 創立另外一個欄位 goals_rank
  FROM match
 WHERE season = '2011/2012';

-- 10-1. WINDOW 練習
SELECT m.id,
       c.name AS country,
       m.season,
       m.home_goal,
       m.away_goal
  FROM match AS m
  LEFT JOIN country AS c 
    ON m.country_id = c.id;
       -- 如此時需使用 Aggregation function -> 須將所有以選取的欄位都 GROUP BY
       -- 但是此時可以使用 WINDOW function
SELECT m.id,
       c.name AS country,
       m.season,
       m.home_goal,
       m.away_goal,
       AVG(m.home_goal + m.away_goal) OVER() AS overall_avg   -- WINDOW function
  FROM match AS m
  LEFT JOIN country AS c 
    ON m.country_id = c.id;

-- 10-2. WINDOW 練習
SELECT l.name AS league,
       AVG(m.home_goal + m.away_goal) AS avg_goals,
       RANK() OVER(ORDER BY AVG(m.home_goal + m.away_goal)) AS league_rank   --WINDOW function
  FROM league AS l
  LEFT JOIN match AS m 
    ON l.id = m.country_id
 WHERE m.season = '2011/2012'
 GROUP BY l.name
 ORDER BY league_rank;

       RANK() OVER(ORDER BY AVG(m.home_goal + m.away_goal) DESC) AS league_rank
       -- 依照 DESC AVG 的順序來 RANKING

-- WINDOW function -PARTITION BY
SELECT date,
       season,
       home_goal,
       away_goal,
       CASE WHEN hometeam_id = 8673 THEN 'home' 
		        ELSE 'away'
	      END AS warsaw_location,
       AVG(home_goal) OVER(PARTITION BY season) AS season_homeavg,
       AVG(away_goal) OVER(PARTITION BY season) AS season_awayavg
  FROM match
 WHERE hometeam_id = 8673 OR awayteam_id = 8673
 ORDER BY (home_goal + away_goal) DESC;

--
SELECT date,
       season,
       home_goal,
       away_goal,
       CASE WHEN hometeam_id = 8673 THEN 'home' 
            ELSE 'away'
	      END AS warsaw_location,
       AVG(home_goal) OVER(PARTITION BY season, EXTRACT(MONTH FROM date))
	          AS season_mo_home,
       AVG(away_goal) OVER(PARTITION BY season, EXTRACT(MONTH FROM date))
	          AS season_mo_away
  FROM match
 WHERE hometeam_id = 8673 OR awayteam_id = 8673 
 ORDER BY (home_goal + away_goal) DESC;

-- WINDOW function - sliding window  可以用於計算欄位內資料 (FRAME)
-- 語法 : ROWS BETWEEN <start> AND <finish>
/* start / finish 的語法包含 : 
PRECEDING / FOLLOWONG 
UNBOUNDED PRECEDING / UNBOUNDED FOLLOWING
CURRENT ROW */
SELECT date,
       home_goal,
       away_goal,
       SUM(home_goal) OVER(ORDER BY date 
                           ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW) AS running_total
  FROM match
 WHERE hometeam_id = 8456 OR season = '2011/2012';
    
--
SELECT date,
       home_goal,
       away_goal,
       SUM(home_goal) OVER(ORDER BY date 
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                      AS running_total,
       AVG(home_goal) OVER(ORDER BY date 
                      ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW)
                      AS running_avg
  FROM match
 WHERE hometeam_id = 9908 AND season = '2011/2012';

--                        ROWS BETWEEN 順序不太清楚...需複習
SELECT date,
       home_goal,
       away_goal,
       SUM(home_goal) OVER(ORDER BY date DESC
                      ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
                      AS running_total,
       AVG(home_goal) OVER(ORDER BY date DESC
                      ROWS BETWEEN CURRENT ROW AND UNBOUNDED FOLLOWING)
                      AS running_avg
  FROM match
 WHERE awayteam_id = 9908 AND season = '2011/2012';

--
-- PostgreSQL Summary Stats and Window Functions   ##FINISHED##
--
-- 1. WINDOW function
-- 語法 : FUNCTION_NAME() OVER(...)

-- 2. WINDOW function - ROW_NUMBER()

SELECT Year,
       Event,
       Country,
       ROW_NUMBER() OVER() AS ROW_N -- 給你每行的index
  FROM Summer_Medals
 WHERE Medal = 'Gold';

-- 3. WINDOW function - LAG(column,n) OVER (...)
-- returns column's value at the row 'n' before the current row
-- 返還現在行數 n 行前，的值
SELECT Year,
       ROW_NUMBER() OVER (ORDER BY Year DESC) AS Row_N
  FROM (
       SELECT DISTINCT Year
         FROM Summer_Medals
       ) AS Years
 ORDER BY Year;

-- 3-1. 練習 : CTE & WINDOW - LAG
WITH Weightlifting_Gold AS (
  SELECT Year,
         Country AS champion
    FROM Summer_Medals
   WHERE Discipline = 'Weightlifting' AND
         Event = '69KG' AND
         Gender = 'Men' AND
         Medal = 'Gold')

SELECT Year,
       Champion,
       LAG(Champion) OVER(ORDER BY year ASC) AS Last_Champion
  FROM Weightlifting_Gold
 ORDER BY Year ASC;

-- 4. WINDOW function - ORDER BY & PARTITION BY
-- 類似 GROUP BY 的分類邏輯
WITH Tennis_Gold AS (
     SELECT DISTINCT Gender, Year, Country
       FROM Summer_Medals
      WHERE Year >= 2000 AND Event = 'Javelin Throw' AND Medal = 'Gold')

SELECT Gender,
       Year,
       Country AS Champion,
       LAG(Country) OVER(PARTITION BY gender   -- LAG 需要用原本的欄位名稱
                         ORDER BY year ASC) AS Last_Champion
  FROM Tennis_Gold
 ORDER BY Gender ASC, Year ASC;

--
WITH Athletics_Gold AS (SELECT DISTINCT Gender,
                               Year, Event, Country
                          FROM Summer_Medals
                         WHERE Year >= 2000 AND Discipline = 'Athletics' AND Event IN ('100M', '10000M') AND Medal = 'Gold')

SELECT Gender,
       Year,
       Event,
       Country AS Champion,
       LAG(Country) OVER (PARTITION BY gender, event
                          ORDER BY Year ASC) AS Last_Champion
  FROM Athletics_Gold
 ORDER BY Event ASC, Gender ASC, Year ASC;

-- 5. WINDOW function - LEAD(column,n) OVER (...)
-- 比較
-- LAG(column,n) return the row value BEFORE the current row
-- LEAD(column,n) return the row value AFTER the current row
-- 類似function
-- FIRST_VALUE(column) / LAST_VALUE(column)
/*
YEAR | City | First_City | Last_City
-----|------|------------|----------
1896  Taiwan    Taiwan      Japan  
1900  Paris     Taiwan      Japan  
1904  Japan     Taiwan      Japan  
1908  OSAKA     Taiwan      Japan     <- CURRENT ROW，will exclude from the FIRST_VALUE & LAST_VALUE
*/
WITH Discus_Medalists AS (SELECT DISTINCT Year, Athlete
                            FROM Summer_Medals
                           WHERE Medal = 'Gold' AND Event = 'Discus Throw' AND Gender = 'Women'
                             AND Year >= 2000)

SELECT year, athlete,
       LEAD(athlete,3) OVER (ORDER BY year ASC) AS Future_Champion
  FROM Discus_Medalists
 ORDER BY Year ASC;

--
WITH All_Male_Medalists AS (SELECT DISTINCT Athlete
                              FROM Summer_Medals
                             WHERE Medal = 'Gold' AND Gender = 'Men')

SELECT athlete,
       FIRST_VALUE(athlete) OVER (ORDER BY athlete ASC) AS First_Athlete
  FROM All_Male_Medalists;

--
WITH Hosts AS (SELECT DISTINCT Year, City
                 FROM Summer_Medals)

SELECT Year, City,
       LAST_VALUE(City) OVER (ORDER BY year ASC RANGE BETWEEN
                              UNBOUNDED PRECEDING AND UNBOUNDED FOLLOWING
                             ) AS Last_City
  FROM Hosts
 ORDER BY Year ASC;

-- 6. ROW_NUMBER() / RANK() / DENSE_RANK()
/*
Games | Row_number | Rank | Dense_Rank
------|------------|------|-----------
 27         1          1        1    
 26         2          2        2
 26         3          2        2
 25         4          4        3
 24         5          5        4
 24         6          5        4
 23         7          7        5
        完全照順序    跳號      不跳號
*/

--
WITH Athlete_Medals AS (SELECT Athlete,
                               COUNT(*) AS Medals
                          FROM Summer_Medals
                         GROUP BY Athlete)

SELECT Athlete, Medals,
       RANK() OVER (ORDER BY medals DESC) AS Rank_N
  FROM Athlete_Medals
 ORDER BY Medals DESC;

--
WITH Athlete_Medals AS (SELECT Country, Athlete, COUNT(*) AS Medals
                          FROM Summer_Medals
                         WHERE Country IN ('JPN', 'KOR') AND Year >= 2000
                         GROUP BY Country, Athlete
                        HAVING COUNT(*) > 1)

SELECT Country,
       Athlete,
       Dense_RANK() OVER (PARTITION BY Country
                          ORDER BY Medals DESC) AS Rank_N
  FROM Athlete_Medals
 ORDER BY Country ASC, RANK_N ASC;

-- WINDOW function - NTILE()
-- NTILE(n) : split the data into n queal pages / 將資料頻分成 n 等份 / ex: 依風險等級分高，中，低
WITH Events AS (SELECT DISTINCT Event
                  FROM Summer_Medals)

SELECT Event,
       NTILE(111) OVER (ORDER BY Event ASC) AS Page -- 將資料分成約 111 等分
  FROM Events
 ORDER BY Event ASC;

--
SELECT Athlete, Medals,
       NTILE(3) OVER (ORDER BY Medals DESC) AS Third
  FROM Athlete_Medals
 ORDER BY Medals DESC, Athlete ASC;

-- 計算出各分組的平均 / table_Third 依獎牌數分成三組 / main query: 依分組，算出各組平均獎牌數
-- 此功能常用
WITH Athlete_Medals AS (SELECT Athlete, COUNT(*) AS Medals
                          FROM Summer_Medals
                         GROUP BY Athlete
                        HAVING COUNT(*) > 1),
  
     Thirds AS (SELECT Athlete,Medals,
                       NTILE(3) OVER (ORDER BY Medals DESC) AS Third
                  FROM Athlete_Medals)

SELECT Third,
       AVG(medals) AS Avg_Medals
  FROM Thirds
 GROUP BY Third
 ORDER BY Third ASC;

--
WITH Athlete_Medals AS (SELECT Athlete, COUNT(*) AS Medals
                          FROM Summer_Medals
                         WHERE Country = 'USA' AND Medal = 'Gold' AND Year >= 2000
                         GROUP BY Athlete)

SELECT athlete, medals,
       SUM(medals) OVER (ORDER BY athlete ASC) AS Max_Medals
  FROM Athlete_Medals
 ORDER BY Athlete ASC;

--
WITH Country_Medals AS (SELECT Year, Country, COUNT(*) AS Medals
                          FROM Summer_Medals
                         WHERE Country IN ('CHN', 'KOR', 'JPN') AND Medal = 'Gold' AND Year >= 2000
                         GROUP BY Year, Country)

-- Return the max medals earned so far per country
SELECT year, country, medals,
       MAX(medals) OVER (PARTITION BY country
                         ORDER BY year ASC) AS Max_Medals
  FROM Country_Medals
 ORDER BY Country ASC, Year ASC;

-- MIN()
WITH France_Medals AS (SELECT Year, COUNT(*) AS Medals
                         FROM Summer_Medals
                        WHERE Country = 'FRA' AND Medal = 'Gold' AND Year >= 2000
                        GROUP BY Year)

SELECT Year, Medals,
       MIN(Medals) OVER (ORDER BY year ASC) AS Min_Medals
  FROM France_Medals
 ORDER BY Year ASC;

-- 7. WINDOW function - FRAME (sliding window)
/*  ROWS BETWEEN
PRECEDING : n before current row
FOLLOWONG : n after current row

UNBOUNDED PRECEDING / UNBOUNDED FOLLOWING
CURRENT ROW */

-- Default, frame 從 table 第一行 到 (最後一行的上一行)，最後一行為 currnet row 不計入

ROW BETWEEN 3 PRECEDING AND 1 FOLLOWING
--Current row 上三行 + Current row 一行 + Current row 下一行，共五行
WITH Scandinavian_Medals AS (SELECT Year, COUNT(*) AS Medals
                               FROM Summer_Medals
                              WHERE Country IN ('DEN', 'NOR', 'FIN', 'SWE', 'ISL') AND Medal = 'Gold'
                              GROUP BY Year)

SELECT Year,Medals,
       MAX(Medals) OVER (ORDER BY Year ASC
                         ROWS BETWEEN CURRENT ROW AND 1 FOLLOWING) AS Max_Medals
  FROM Scandinavian_Medals
 ORDER BY Year ASC;

--
SELECT Athlete,Medals,
       MAX(Medals) OVER (ORDER BY Athlete ASC
                         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Max_Medals
  FROM Chinese_Medals
 ORDER BY Athlete ASC;

-- 8. Moving averages and totals (using frame work)
SELECT Year, Medals,
       AVG(Medals) OVER (ORDER BY Year ASC 
                         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Medals_ave_in_3_years
  FROM US_Medals
 ORDER BY Year ASC;

-- 8-1. ROWS BETWEEN / RANGE BETWEEN
-- 如果計算欄位數值一樣， RANGE BETWEEN 會將兩資料視為一個資料
/* 
SUM(Mdeals) OVER (ORDER BY Year ASC
                  ROWS BETWEEN / RANGE BETWEEN  ...

Year | Medals | Rows_RT | Range_RT
-----|--------|---------|---------
1992    10        10        10
1996    50        60        110
2000    50        110       110         range將兩個50視為同一個，並加總
2004    60        170       230
2008    60        230       230         range將兩個60視為同一個，並加總 */

--
SELECT Year, Medals,
       AVG(Medals) OVER (ORDER BY Year ASC
                         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Medals_MA
  FROM Russian_Medals
 ORDER BY Year ASC;

--
SELECT Year, Country, Medals,
       SUM(Medals) OVER (PARTITION BY Country
                         ORDER BY Year ASC
                         ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS Medals_MA
  FROM Country_Medals
 ORDER BY Country ASC, Year ASC;

-- WINDOW function - pivoting
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB($$
  -- (原本的 main query)
$$) AS ct (Country VARCHAR,
           "2004" INT,
           "2008" INT,
           "2012" INT)   -- 創造一個格式
 GROUP BY Country ASC;

--
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB
($$
SELECT Gender, Year, Country
  FROM Summer_Medals
 WHERE Year IN (2008, 2012) AND Medal = 'Gold' AND Event = 'Pole Vault'
 ORDER By Gender ASC, Year ASC;
$$)
    AS ct (Gender VARCHAR,  -- 注意，創造新表格的格式時，表格名稱須為 String，所以特別將 2008 rounded by ""
           "2008" VARCHAR,
           "2012" VARCHAR)
 ORDER BY Gender ASC;

-- 8-2. EXERCISE of WINDOW function
SELECT country, year,
       COUNT(*) AS Awards
  FROM Summer_Medals
 WHERE Country IN ('FRA', 'GBR', 'GER') AND Year IN (2004, 2008, 2012) AND Medal = 'Gold'
 GROUP BY country, year
 ORDER BY Country ASC, Year ASC;

-- NEXT STEP
WITH Country_Awards AS (SELECT Country, Year, COUNT(*) AS Awards
                          FROM Summer_Medals
                         WHERE Country IN ('FRA', 'GBR', 'GER') AND Year IN (2004, 2008, 2012) AND Medal = 'Gold'
                         GROUP BY Country, Year)


SELECT Country, Year,
       RANK() OVER (PARTITION BY Year
                    ORDER BY Awards DESC) :: INTEGER AS rank  
                    -- :: convert data type to INTERGER and named it AS rank 
  FROM Country_Awards
 ORDER BY Country ASC, Year ASC;

-- NEXT STEP
CREATE EXTENSION IF NOT EXISTS tablefunc;

SELECT * FROM CROSSTAB
($$
  WITH Country_Awards AS (SELECT Country, Year, COUNT(*) AS Awards
                            FROM Summer_Medals
                           WHERE Country IN ('FRA', 'GBR', 'GER') AND Year IN (2004, 2008, 2012) AND Medal = 'Gold'
                           GROUP BY Country, Year)

SELECT Country, Year,
       RANK() OVER (PARTITION BY Year
                    ORDER BY Awards DESC) :: INTEGER AS rank
  FROM Country_Awards
 ORDER BY Country ASC, Year ASC;
$$) AS ct (Country VARCHAR,
           "2004" INTEGER,
           "2008" INTEGER,
           "2012" INTEGER)
 Order by Country ASC;

-- 9. ROLLUP & CUBE    此二者為 GROUP BY 的 sub-query
/* ROLLUP(column_1, column_2)
   將以 column_1 為主，計算 based on column_1 and aggregation of column_2

   CUBE(column_1, column_2)  
   將交叉計算所有可能結果 */
SELECT country, gender, COUNT(*) AS Gold_Awards
  FROM Summer_Medals
 WHERE Year = 2004 AND Medal = 'Gold' AND Country IN ('DEN', 'NOR', 'SWE')
 GROUP BY Country, ROLLUP(gender)
 ORDER BY Country ASC, Gender ASC;
-- 以country 為主，gender 為輔，計算各國各性別獲取獎牌數

-- 
SELECT gender, medal,
       COUNT(*) AS Awards
  FROM Summer_Medals
 WHERE Year = 2012 AND Country = 'RUS'
 GROUP BY CUBE(gender, medal)
 ORDER BY Gender ASC, Medal ASC;
/* ROLLUP(A,B) 可以理解為
先對 A,B进行 GROUP BY，之後對 A 進行 GROUP BY*/

-- 10. COALESCE ，如query後，發現欄位中某些值為 NULL 時，可以使用 
SELECT COALESCE(Country, 'All countries') AS Country,
       COALESCE(Gender, 'All genders') AS Gender,
       COUNT(*) AS Awards
  FROM Summer_Medals
 WHERE Year = 2004 AND Medal = 'Gold' AND Country IN ('DEN', 'NOR', 'SWE')
 GROUP BY ROLLUP(Country, Gender)
 ORDER BY Country ASC, Gender ASC;

-- 11. STRING_AGG 
SELECT STRING_AGG(country,', ')
  FROM Country_Ranks
 WHERE RANK <= 3;

--
--Functions for Manipulating Data in PostgreSQL   ##FINISHED##
--
-- 1. check data type of tables and columns
SELECT * 
  FROM INFORMATION_SCHEMA.TABLES
 WHERE table_schema = 'public';

SELECT * 
  FROM INFORMATION_SCHEMA.COLUMNS
 WHERE table_name = 'actor';

-- 2. INTERVAL (由於資料已經按照格式排序，所以可以直接輸入 '3 days' or '3 years' ...)
SELECT rental_date,
       rental_date + INTERVAL '3 days' AS expected_return_date
  FROM rental;

-- 3. ARRAY IN SQL
TABLE : special_features -- 欄位: special_features 中的資料型態是 array
/*
title	             | special_features
-------------------|------------------------------------------
BEACH HEARTBREAKERS| Deleted Scenes,Behind the Scenes
BEAST HUNCHBACK	   | Deleted Scenes,Behind the Scenes
BEDAZZLED MARRIED	 | Trailers,Deleted Scenes,Behind the Scenes
*/
SELECT title, special_features 
  FROM film
 WHERE special_features[1] = 'Trailers'; --選取 special_features array 中，第一個值為Trailers

-- 3-1.
SELECT title, special_features 
  FROM film 
 WHERE 'Trailers' = ANY (special_features);

OR 

SELECT title, special_features 
  FROM film 
 WHERE special_features @> ARRAY['Deleted Scenes'];

-- 於 special_features 欄位中，找出任何包含 Trailers 的值

-- 
SELECT f.title,
       f.rental_duration,
       r.return_date - r.rental_date AS days_rented   -- 計算時間差
  FROM film AS f
 INNER JOIN inventory AS i
    ON f.film_id = i.film_id
 INNER JOIN rental AS r
    ON i.inventory_id = r.inventory_id
 ORDER BY f.title;

OR 
SELECT AGE(r.return_date, r.rental_date) AS days_rented -- 也是計算時間差，注意順序

-- 
SELECT f.title,
       INTERVAL '1' DAY * f.rental_duration,          -- 將原本欄位的數字資料轉換為時間
       r.return_date - r.rental_date AS days_rented   -- 計算時間差
  FROM film AS f
 INNER JOIN inventory AS i ON f.film_id = i.film_id
 INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
 WHERE r.return_date IS NOT NULL
 ORDER BY f.title;

--
SELECT f.title,
       r.rental_date,
       f.rental_duration,
       ((INTERVAL '1' day * f.rental_duration) + r.rental_date) AS expected_return_date,  -- 計算
       r.return_date
  FROM film AS f
 INNER JOIN inventory AS i ON f.film_id = i.film_id
 INNER JOIN rental AS r ON i.inventory_id = r.inventory_id
 ORDER BY f.title;

-- 4. 更改資料型態
-- 僅適用於 PostgreSQL
SELECT NOW() :: TIMESTAMP; -- 將此欄位的資料型態，更改為: TIMESTAMP

-- 通用 CAST()
SELECT CAST(NOW() AS TIMESTAMP);  -- 效果同上

-- 其他選取時間的方式
SELECT CURRENT_TIMESTAMP(n);   -- 僅取n位數毫秒
SELECT CURRENT_DATE;
SELECT CURRENT_TIME;

--
SELECT CURRENT_TIMESTAMP(0)::timestamp AS right_now,                     --(0) 去除毫秒
       interval '5 days' + CURRENT_TIMESTAMP(0) AS five_days_from_now;

-- 5. Extracting date & time data
SELECT EXTRACT(quarter FROM payment_date) AS quarter,   -- 季度
       EXTRACT(year FROM payment_date) AS year,         -- 年份
       SUM(amount) AS total_payments
  FROM payment 
 GROUP BY 1, 2;                                         -- GROUP BY quarter, year 較不推薦用數字

-- 5-1. DATE_TRUNC()
SELECT DATE_TRUNC('year', TIMESTAMP '2005-05-21 15:30:30')
    -- DATE_TRUNC(欲擷取的時間單位，欄位名稱)
-- RESULT: 2005-01-01 00:00:00   擷取年份，其他值為 default

SELECT rental_date,
       EXTRACT(dow from rental_date) AS dayofweek
       --擷取星期: PostgreSQL 0: Sunday, 1: Monday ... 
  FROM rental 
 LIMIT 100;

-- !!! Better way 
 Select to_char(rental_date, 'Day') as Day_Name   -- 可以直接顯示星期幾
   From rental;

--
SELECT -- Extract the day of week date part from the rental_date
       EXTRACT(dow FROM rental_date) AS dayofweek,
       AGE(return_date, rental_date) AS rental_days
  FROM rental AS r 
 WHERE -- Use an INTERVAL for the upper bound of the rental_date
       rental_date BETWEEN CAST('2005-05-01' AS TIMESTAMP)
       AND CAST('2005-05-01' AS TIMESTAMP) + INTERVAL '90 day';

--
SELECT c.first_name || ' ' || c.last_name AS customer_name,
       f.title,
       r.rental_date,
       -- Extract the day of week date part from the rental_date
       EXTRACT(dow FROM r.rental_date) AS dayofweek,
       AGE(r.return_date, r.rental_date) AS rental_days,
       -- Use DATE_TRUNC to get days from the AGE function
       CASE WHEN DATE_TRUNC('day', AGE(r.return_date, r.rental_date)) > f.rental_duration * INTERVAL '1' day
       -- Calculate number of d
            THEN TRUE 
            ELSE FALSE END AS past_due 
  FROM film AS f 
 INNER JOIN inventory AS i ON f.film_id = i.film_id 
 INNER JOIN rental AS r ON i.inventory_id = r.inventory_id 
 INNER JOIN customer AS c ON c.customer_id = r.customer_id 
 WHERE -- Use an INTERVAL for the upper bound of the rental_date
       r.rental_date BETWEEN CAST('2005-05-01' AS DATE) 
       AND CAST('2005-05-01' AS DATE) + INTERVAL '90 day';

-- 6. Reformatting string and character data
SELECT first_name,
       last_name,
       first_name || ' ' || last_name AS full_name
       -- 兩欄位文字結合
  FROM customer;

OR
SELECT first_name, last_name
       CONCAT(first_name, ' ', last_name) AS full_name
  FROM customer;

-- 7. 大小寫轉換
SELECT UPPER(column_1),   -- 全大寫
       LOWER(column_2),   -- 全小寫
       INITCAP(column_3)  -- 首字大寫，其他小寫
       REPLACE(column_4, 'original_string', 'new_string') AS new_column_name
       REVERSE(column_5);   -- 欄位內文字順序顛倒
  FROM table;

-- 可以 concat 欄位內資訊，也可以 concat 我們新加的字串
SELECT first_name || ' ' || last_name || ' <' || email || '>' AS full_email 
  FROM customer;

OR 
SELECT CONCAT(first_name, ' ', last_name, ' <', email, '>') AS full_email 
  FROM customer

--
SELECT UPPER(c.name)  || ': ' || INITCAP(f.title) AS film_category, 
       LOWER(f.description) AS description
  FROM film AS f 
 INNER JOIN film_category AS fc
    ON f.film_id = fc.film_id 
 INNER JOIN category AS c
    ON fc.category_id = c.category_id;

-- LENGTH & POSITION & STRPOS & LEFT & RIGHT & SUBSTRING
SELECT LENGTH(column_1),
       POSITION('word you want lacate' IN column_2),
       STRPOS(column_3, 'word you want lacate'),
       LEFT(column_4, 50),
       RIGHT(column_5, 50),
       SUBSTRING(column_6, 10, 50),
       SUBSTRING(column_7 FROM 0 FOR POSITION ('@' IN email)) --從欄位七，第一個字擷取到特殊符號前的字串
       
--
SELECT SUBSTRING(address FROM POSITION(' ' IN address)+1 FOR LENGTH (address))
  FROM address;

--
SELECT LEFT(email, POSITION('@' IN email)-1) AS username,
       SUBSTRING(email FROM POSITION('@' IN email)+1 FOR LENGTH(email)) AS domain
FROM customer;

-- 8. 移除 or 新增 字串資訊
TRIM ([leading or trailing or both] [characters] FROM string)
-- 移除字首 or 字尾 or 兩者都移除
-- 移除指定單字
-- 從哪移除

LTRIM (string)   -- 移除左側空白
RTRIM (string)   -- 移除右側空白

SELECT LPAD('TEST',10,'#')
--將TEST欄位內資訊，增加到10個單位，左側，以#填滿，至10個單位
SELECT RPAD('TEST',10,'#')

--
SELECT RPAD(first_name, LENGTH(first_name)+1,' ') || last_name AS full_name
  FROM customer;

OR 
SELECT first_name || LPAD(last_name, LENGTH(last_name)+1,' ') AS full_name
  FROM customer;   -- sam result

--
SELECT CONCAT(UPPER(c.name), ': ', f.title) AS film_category, 
       TRIM(LEFT(f.description, 50)) AS film_desc
  FROM film AS f 
 INNER JOIN film_category AS fc 
  	ON f.film_id = fc.film_id 
 INNER JOIN category AS c 
  	ON fc.category_id = c.category_id;

-- 9. TEXT search
SELECT title
  FROM film
 WHERE title LIKE '%elf%';   -- case sensitive

SELECT title, description
  FROM film 
 WHERE to_tsvector(title) @@ to_tsquery('elf');   -- not case sensitive

-- 兩者效果類似，僅差在有無大小寫區分

--
SELECT title, description
  FROM film
 WHERE TO_TSVECTOR(title) @@ TO_TSQUERY('elf');
-- TO_TSVECTOR 轉換該欄位資料類型，TO_TSQUERY 搜尋需要檢視的字串

-- 10. User-defined data type 自定義的資料類型
CREATE TYPE compass_position AS ENUM (
  	'North', 
  	'South',
  	'East', 
  	'West'
);   -- ENUM 某種資料類型

SELECT *
  FROM pg_type   -- pg_type 可以檢視系統內所有資料型態
 WHERE typname='compass_position';

-- 11. extension of PostgreSQL
PostGIS : Allows location SQL running in SQL
PostPic : Allows image processing in SQL 
fuzzystrmatch : textsearch function
pg_trgm : textsearch function

SELECT extname
  FROM pg_extension;   -- 可以檢視目前資料庫中，有哪些 Extension 已經安裝

SELECT name
  FROM pg_available_extensions;   -- 可以檢視目前隻料庫中，有哪些Extension可以使用

-- 11-1. 新增 Extension
CREATE EXTENSION IF NOT EXISTS fuzzystrmatch;   -- 新增Extension

SELECT extname
  FROM pg_extension;   -- 再次檢視，會發現，新增了 fuzzystrmatch extension

-- 11-2. 
SELECT title,
       description, 
       similarity(title, description)   -- 比較兩個欄位的相似度
  FROM film;

--
-- Exploratory Data Analysis in SQL   ## FINISHED ##  此篇較難，可以複習一次
--
SELECT COUNT(column_1)   -- 僅計算number of non-NULL values 
  FROM table;

-- 1. coalesce()
-- checks arguments in order and returns the first "non-NULL" value, if one exists.

coalesce(NULL, 1, 2) = 1
coalesce(NULL, NULL,'if both NULL') = if both NULL
coalesce(2, 3, NULL) = 2

-- 2. CAST()
-- 暫時改變資料型態
SELECT CAST (column AS new_type) AS new_column_name ...
SELECT column :: new_type AS new_column_name ...

SELECT CAST (3.7 AS integer); -- get 4

-- 3. Numeric types: integer
/*
integer            通常使用此種類型
smallint           samll-range
bigint             large-range 
serial             auto-increment
smallserial        small auto-increment
bigserial          large auto-increment
demical & numeric  user-specificed */

SELECT MIN(profits),
       AVG(profits),
       MAX(profits),
       STDDEV(profits) -- 計算標準偏離。（Standard Deviation）
  FROM fortune500;

-- 4. TRUNC()
SELECT TRUNC(1234.5678 , 2)   -- 1234.56
SELECT TRUNC(1234.5678 , -2)   -- 1200.5678

-- 5. GENERATE_SERIES()
SELECT GENERATE_SERIES(1,10,2)   -- -- 1,3,5,7,9 
-- GENERATE_SERIES(START, END, STEPS)

-- 6. 柱狀圖
-- 先使用TRUNC 創造分類依據，後使用GROUP BY分類
SELECT TRUNC(employees, -5) AS employee_bin,
       COUNT(*)
  FROM fortune500
 GROUP BY employee_bin
 ORDER BY employee_bin;

-- 7. CORR()
-- 判斷兩數據是否有正相關 (負相關)
SELECT CORR(column_1, column_2)
  FROM table

-- 8. 中位數
-- 直接返還數據中的中位數
SELECT PERCENTILE_DISC(percentile) WITHIN GROUP (ORDER BY column_1)
  FROM table

-- 返還經過計算過後的中位數 (數字不一定等同於原始資料)
SELECT PERCENTILE_CONT(percentile) WITHIN GROUP (ORDER BY column_1)
  FROM table

-- 8.1 中位數練習
-- 原始資料 : 1, 3, 4, 5
SELECT PERCENTILE_DISC(.5) WITHIN GROUP (ORDER BY val)
       PERCENTILE_CONT(.5) WITHIN GROUP (ORDER BY val)
  FROM table

-- PERCENTILE_DISC : 3
-- PERCENTILE_CONT : 3.5

-- 9. CREATE / INSERT / DROP : temporary table
-- 暫時創造一個 new_table，其內容為 fortune500 中的資料
CREATE TEMP TABLE new_table AS 
SELECT rank,
       title
  FROM fortune500
 WHERE rank <= 10;

-- 暫時創造的table，也適用 INSERT INTO 來增加資料
INSERT INTO new_table
SELECT rank, title
  FROM fortune500
 WHERE rank BETWEEN 11 AND 20;

-- 刪除暫時創造的table
DROP TABLE new_table;             -- 如 new_table 已經不存在，會產生 ERROR
DROP TABLE IF EXISTS new_table;   -- 較好，會先檢查該 table 是否存在。

-- 9.1 練習
DROP TABLE IF EXISTS profit80;

CREATE TEMP TABLE profit80 AS   -- 創立暫時table

SELECT sector, 
       PERCENTILE_DISC(0.8) WITHIN GROUP (ORDER BY profits) AS pct80   -- 選取profits > 80% 的資料
  FROM fortune500
 GROUP BY sector;

-- 9.2 練習
DROP TABLE IF EXISTS correlations;

CREATE TEMP TABLE correlations AS
SELECT 'profits'::varchar AS measure,
       corr(profits, profits) AS profits,
       corr(profits, profits_change) AS profits_change,
       corr(profits, revenues_change) AS revenues_change
  FROM fortune500;

INSERT INTO correlations
SELECT 'profits_change'::varchar AS measure,
       corr(profits_change, profits) AS profits,
       corr(profits_change, profits_change) AS profits_change,
       corr(profits_change, revenues_change) AS revenues_change
  FROM fortune500;

INSERT INTO correlations
SELECT 'revenues_change'::varchar AS measure,
       corr(revenues_change, profits) AS profits,
       corr(revenues_change, profits_change) AS profits_change,
       corr(revenues_change, revenues_change) AS revenues_change
  FROM fortune500;

-- Select each column, rounding the correlations
SELECT measure, 
       ROUND(profits :: NUMERIC,2) :: NUMERIC AS profits,
       ROUND(profits_change :: NUMERIC,2) :: NUMERIC AS profits_change,
       ROUND(revenues_change :: NUMERIC,2) :: NUMERIC AS revenues_change
  FROM correlations;

-- 10 Data type - Character
CHAR(n)   -- fixed length n
VARCHAR(n)   -- variable length but up to n
TEXT / VARCHAR   -- unlimited length

-- 10.1 練習
SELECT DISTINCT(source), COUNT(*)
  FROM evanston311
 GROUP BY DISTINCT(source)
HAVING COUNT(*) >= 100;

-- 11 Cases and Spaces
全部轉換為小寫 or 大寫
SELECT lower(column),
       upper(column)
  FROM table;

or

SELECT *
  FROM fruit 
 WHERE fav_fruit ILIKE '%apple%'   -- ILIKE 將會涵蓋所有大小寫

-- 但此方法可能會包含 pineapple，所以較好的方法，還是使用移除空白

-- 12 TRIM()
TRIM() / LTRIM() / RTRIM() -- 也可以指定想要移除的資料，不一定是空白

TRIM(column,'@')   -- 移除column 欄位中，所以 @ 符號

TRIM function is case sensitive 可以結合 lower() / upper()

SELECT TRIM(LOWER(column), 'n')   
  FROM table; 

-- 12.1 練習
SELECT distinct street,
       trim(street, '0,1,2,3,4,5,6,7,8,9,#,/,.," "') AS cleaned_street
  FROM evanston311
 ORDER BY street;

SELECT COUNT(*)
  FROM evanston311
 WHERE description ILIKE '%trash%'   -- 多個 ILIKE，也需要使用 AND OR 連接
    OR description ILIKE '%garbage%';

-- 12.2 練習
SELECT category, COUNT(*)
  FROM evanston311 
 WHERE (description ILIKE '%trash%' OR description ILIKE '%garbage%') 
       AND category NOT LIKE '%Trash%'
       AND category NOT LIKE '%Garbage%'
 GROUP BY category
 ORDER BY COUNT(*) DESC
 LIMIT 10;

-- 13 SUBSTRING TEXT & CONCATE TEXT
SELECT SUBSTRING (column FROM start FOR length);
-> 
SELECT SUBSTRING('abcdefg', FROM 2 FOR 3);
-> bcd
SELECT SUBSTR('abcdefg', 2, 3);   -- same result

-- 13.1 SPLIT_PART
SELECT SPLIT_PART(string, delimiter, part)
->
SELECT SPLIT_PART('a,bc,d', ',', 2);
-- 將 a,bc,d 此字串拆分，字串中分隔的符號為 : ，; 擷取第二部分
-> bc 

-- 13.2 練習
SELECT SPLIT_PART(street,' ',1) AS street_name, 
       count(*)
  FROM evanston311
 GROUP BY street_name
 ORDER BY count DESC
 LIMIT 20;

-- 13.3 練習
SELECT CASE WHEN length(description) > 50
            THEN LEFT(description, 50) || '...'
       ELSE description
       END
  FROM evanston311
 WHERE description LIKE 'I %'
 ORDER BY description;

-- 13.4 練習
-- 分隔，並取第一個字串 (方法一)
SELECT CASE WHEN category LIKE '%: %' THEN SPLIT_PART (category, ': ', 1)
            WHEN category LIKE '% - %' THEN SPLIT_PART (category, ' - ', 1)
            ELSE SPLIT_PART (category, ' | ', 1)
        END AS major_category
  FROM table
-- 但此方法必須明確知道所有資料的第二個符號才可行

-- 分隔，並取第一個字串 (方法二)
CREATE TEMP TABLE record AS                    -- 創造暫時table

SELECT DISTINCT fav_fruit AS orginal,          -- 選取要更新的欄位
       fav_fruit AS standardized
  FROM table

UPDATE table                                   -- UPDATE
   SET standardized = TRIM(LOWER(original));

-- 最後使用 JOIN 將資料加回原本 table

-- 13.5 練習
DROP TABLE IF EXISTS record;

CREATE TEMP TABLE recode AS

SELECT DISTINCT category, 
       -- SPLIT_PART(category, '-', 1) AS standardized   取得分隔字串
       RTRIM(SPLIT_PART(category, '-', 1)) AS standardized   -- 去除右方空格
  FROM evanston311;

UPDATE recode                                  -- UPDATE_1
   SET standardized = 'Trash Cart' 
 WHERE standardized LIKE 'Trash%Cart';

UPDATE recode                                  -- UPDATE_2
   SET standardized = 'Snow Removal' 
 WHERE standardized LIKE 'Snow%Removal%';

UPDATE recode                                  -- UPDATE_3
   SET standardized = 'UNUSED' 
 WHERE standardized IN ('THIS REQUEST IS INACTIVE…Trash Cart',
                        '(DO NOT USE) Water Bill',
                        'DO NOT USE Trash', 
                        'NO LONGER IN USE');
    
SELECT DISTINCT standardized                   -- 篩選一些欄位檢查
  FROM recode
 WHERE standardized LIKE 'Trash%Cart'
    OR standardized LIKE 'Snow%Removal%';

-- 13.6 練習
DROP TABLE IF EXISTS indicators;

CREATE TEMP TABLE indicators AS
SELECT id, 
       CAST (description LIKE '%@%' AS integer) AS email,              --計算可能有 email 的欄位數量
       CAST (description LIKE '%___-___-____%' AS integer) AS phone    --計算可能有電話號碼的欄位數量
  FROM evanston311;
  
SELECT priority,
       SUM(email) / COUNT(*) :: numeric AS email_prop,                -- 計算百分比
       SUM(phone) / COUNT(*) :: numeric AS phone_prop                 -- 計算百分比
  FROM evanston311
  LEFT JOIN indicators
    ON evanston311.id = indicators.id
 GROUP BY priority;

-- 14 TIME
-- 標準格式 ISO 8601  -> YYYY-MM-DD HH:MM:SS +HH (最後的 HH : time zone)
SELECT '2018-12-10' :: DATE + '1 YEAR 2 DAYS 3 MINUTES' :: INTERVAL;
-> 2019-12-12 00:03:00

-- 14.1 練習
SELECT count(*) 
  FROM evanston311
 WHERE date_created :: DATE = '2017-01-31';   -- 先將欄位資料轉換為 DATE 再比較

-- 14.2 練習
SELECT count(*)
  FROM evanston311 
 WHERE date_created >= '2016-02-29 00:00:00' 
   AND date_created < '2016-03-01 00:00:00';

-- 14.3 練習
SELECT NOW() + '100 DAYS' :: INTERVAL;   -- 現行時間 + 100 天

-- 14.4 練習
SELECT category, 
       AVG(date_completed - date_created) AS completion_time     -- 計算平均 完成時間 
  FROM evanston311
 GROUP BY category
 ORDER BY completion_time DESC

-- 15 DATE - time fields
century : 2019-01-01 = century 21
decade : 2019-01-01 = decade 201
year / month / day
hour / minute / second
week
dow = day of week

DATE_PART ('time fields we want', timestamp)
or
EXTRACT ('time fields we want' FROM timestamp)

ex. 
SELECT DATE_PART('month', now()),
       EXTRACT(MONTH FROM NOW())   -- 兩者效果相同

-- 15.1 DATE - truncate
SELECT DATE_TRUNC('MONTH', date) AS month,   -- trunc 選取的時間單位，其後的單位會自動調整為最小值
       SUM(amt)
  FROM table
 GROUP BY month
 ORDER BY month;
->   -- 依照月份
       month       |  sum
-------------------|-----
2017-06-01 00:00:00|  xxx
2017-07-01 00:00:00|  xxx
2017-08-01 00:00:00|  xxx
2017-09-01 00:00:00|  xxx
2017-10-01 00:00:00|  xxx

-- 15.2 練習
SELECT EXTRACT(MONTH FROM date_created) AS month, 
       COUNT(*)
  FROM evanston311
 WHERE date_created >= '2016-01-01' AND date_created < '2017-01-01'
 GROUP BY month
 ORDER BY month;

-- 15.3 練習 (此方法，可以直接顯示星期幾)
SELECT to_char(date_created, 'day')  AS day, 
       AVG(date_completed - date_created) AS duration
  FROM evanston311 
 GROUP BY day, to_char(date_created, 'day')
 ORDER BY to_char(date_created, 'day')

-- 15.4 練習 (每日平均，每月平均，較適合用 date_trunc)
SELECT DATE_TRUNC('month',day) AS month,
       AVG(count)
  FROM (SELECT DATE_TRUNC('day',date_created) AS day,
               COUNT(*) AS count
          FROM evanston311
         GROUP BY day) AS daily_count
 GROUP BY month
 ORDER BY month;
->
month	                   |       avg         
-------------------------|-------------------
2016-01-01 00:00:00+01:00	23.4838709677419355
2016-02-01 00:00:00+01:00	30.7586206896551724
2016-03-01 00:00:00+01:00	35.5483870967741935

-- 16 時間序列 GRNERATE_SERIES
SELECT GRNERATE_SERIES(FROM, TO, INTERVAL)

SELECT GRNERATE_SERIES('2018-01-01', '2018-01-09', '2 DAYS' :: INTERVAL)
->
2018-01-01 00:00:00
2018-01-03 00:00:00
2018-01-05 00:00:00
2018-01-07 00:00:00
2018-01-09 00:00:00

-- 16.1 正確的一年份時間
SELECT GRNERATE_SERIES('2018-02-01', '2019-01-01', '1 MONTH' :: INTERVAL) - '1 DAY' :: INTERVAL;

-- 17 LAG() & LEAD()   - WINDOW functions
SELECT date,
       LAG(date) OVER (ORDER BY date),   -- 選取 date 上一行資料
       LEAD(date) OVER (ORDER BY date)   -- 選取 date 下一行資料
  FROM table;

--
-- Data-Driven Decision Making in SQL   ### FINISHED ###
--
-- 複習.1
SELECT column,
       column_1,
       column_2
  FROM table
 WHERE condition_1
 GROUP BY column
HAVING condition_2;

-- 練習.1
SELECT customer_id, 
       AVG(rating),  
       COUNT(rating),  
       COUNT(renting_id)
  FROM renting
 GROUP BY customer_id
HAVING COUNT(renting_id) > 7
 ORDER BY customer_id; 

-- 練習.2
SELECT a.name,  c.gender,
       COUNT(*) AS number_views, 
       AVG(r.rating) AS avg_rating
  FROM renting as r
  LEFT JOIN customers AS c ON r.customer_id = c.customer_id
  LEFT JOIN actsin as ai ON r.movie_id = ai.movie_id
  LEFT JOIN actors as a ON ai.actor_id = a.actor_id

 GROUP BY a.name, c.gender   -- group by 多條件
HAVING AVG(r.rating) IS NOT NULL AND COUNT(*) > 5
 ORDER BY avg_rating DESC, number_views DESC;

-- 1 Nested query (query in where / having)
SELECT m.title, 
       AVG(r.rating)
  FROM renting AS r 
  JOIN movies AS m ON r.movie_id = m.movie_id
 GROUP BY m.title
HAVING AVG(r.rating) >     -- 比較誰的評分大於 '平均 rating' 
	   (SELECT AVG(rating)   -- subquery 計算平均 rating
	    FROM renting);

-- 2 CORRELATED query (關聯子查詢，子查詢的where 連結到主查詢的 table)
SELECT *
FROM movies AS m
WHERE  -- Select all movies with an average rating higher than 8
	(SELECT AVG(rating)
	FROM renting AS r
	WHERE r.movie_id = m.movie_id) > 8;

-- 3 EXIST function (checking correlated nested query 是否為空值)
SELECT *
  FROM movies AS m
 WHERE EXISTS                     -- 2. 有rating 的資料，才會被主query找到 !!
       (
        SELECT *                  -- 1. 檢查沒有rating的資料
          FROM renting AS r
         WHERE rating IS NOT NULL
           AND r.movie_id = m.movie_id
       );

-- 4 NOT EXIST function
SELECT *
  FROM movies AS m
 WHERE NOT EXISTS                     -- 2. 沒有rating 的資料，才會被主query找到 !!
       (
        SELECT *                      -- 1. 檢查沒有rating的資料
          FROM renting AS r
         WHERE rating IS NOT NULL
           AND r.movie_id = m.movie_id
       );

-- 4.1 練習
SELECT *                                        -- 3. EXISTS，以not null為前提，篩選資料
  FROM customers AS c
 WHERE EXISTS
       (SELECT *                                -- 1. SELECT FROM WHERE 篩選出 not null
          FROM renting AS r
         WHERE rating IS NOT NULL
           AND r.customer_id = c.customer_id);  -- 2. 與主table結合

-- 5 UNION / INTERSECT

TABLE_1 : A, B, C, D
TABLE_2 : D, E, F

UNION T_1 AND T_2 -> A, B, C, D, E, F
INTERSECT T_1 AND T_2 -> D

-- 6 OLAP : CUBE operator
-- OLTP : Online Transactional Processing
-- 指系統能夠處理大量的更新以及新增的查詢。重視：數據的正確性以及一致性

-- OLAP : Online Analytical Processing
-- 偏重 : 數據聚合 (Aggregation) / 批次處理 (Batch processing) / BI 圖像化

Pivot table in SQL (cube)
SELECT country,
       genre,
       COUNT(rating)
  FROM renting_extended
 GROUP BY CUBE (country, genre);

-- 6.1 練習
-- Extract information of a pivot table of gender and country for the number of customers
SELECT gender,
	     country,
	     COUNT(customer_id)
  FROM customers
 GROUP BY CUBE (gender, country)
 ORDER BY country;

-- 6.2 練習
SELECT genre,
       year_of_release,
       COUNT(movie_id)
 FROM movies
GROUP BY CUBE (genre, year_of_release)
ORDER BY year_of_release;
-- 此練習發現 NULL 值，複習 IFNULL

IFNULL(變數_1, 變數_2) AS alias
-- 第一：檢查該變數是否為NULL ; 第二：如第一變數為NULL，則顯示第二變數

-- 7 OLAP : ROLLUP operator   !!! 須注意順序 
SELECT country,
       genre,
       COUNT(*)
  FROM renting_extended
 GROUP BY ROLLUP (country, genre) -- 將會以 country 為主，加總 genre

 GROUP BY ROLLUP (genre, country) -- 將會以 genre 為主，加總 country

-- 會在最後，以第一欄位資料為主，進行加總 !!!，因此需額外注意順序

-- 7.1 練習
SELECT c.country, 
       m.genre, 
	     AVG(r.rating), 
	     COUNT(*) 
  FROM renting AS r
  LEFT JOIN movies AS m ON m.movie_id = r.movie_id
  LEFT JOIN customers AS c ON r.customer_id = c.customer_id
 GROUP BY (c.country, m.genre) 
 ORDER BY c.country, m.genre;

-- 8 OLAP : GROUPING SETS operator
SELECT country, genre, COUNT(*)
  FROM renting_extended
 GROUP BY GROUPING SETS ((country,genre), (country), (genre),())

此方法 result 將會等於

SELECT country, genre, COUNT(*)
  FROM renting_extended
 GROUP BY country, genre

UNION                             -- UNION 如果有重複資料，只會顯示一筆，不會重複顯示 

SELECT country, genre, COUNT(*)
  FROM renting_extended
 GROUP BY country

UNION

SELECT country, genre, COUNT(*)
  FROM renting_extended
 GROUP BY genre

UNION

SELECT COUNT(*)
  FROM renting_extended;

-- 8.1 練習
-- REQUEST 1 : Count the number of actors in the table actors from each country
              -> count by nationality
-- REQUEST 2 : Count the number of male and female actors
              -> count by gender
-- REQUEST 3 : Count the total number of actors.
              -> count total
SELECT nationality,
       gender,
       COUNT(*) 
  FROM actors
 GROUP BY GROUPING SETS ((nationality), (gender), ());

-- 8.2 練習
SELECT c.country, 
       c.gender,
       AVG(r.rating)
  FROM renting AS r
  LEFT JOIN customers AS c
    ON r.customer_id = c.customer_id
 GROUP BY GROUPING SETS ((country, gender));   -- GROUPING SETS 不需要alias

-- 9 本章節總複習 - 練習
SELECT genre,
       AVG(rating) AS avg_rating,
       COUNT(rating) AS n_rating,
       COUNT(*) AS n_rentals,
       COUNT(DISTINCT m.movie_id) AS n_movies 
  FROM renting AS r
  LEFT JOIN movies AS m
    ON m.movie_id = r.movie_id
 WHERE r.movie_id IN (
       SELECT movie_id
	       FROM renting
	      GROUP BY movie_id
	     HAVING COUNT(rating) >= 3 ) AND r.date_renting >= '2018-01-01'
 GROUP BY genre
 ORDER BY avg_rating DESC;

-- 9.1 本章節總複習 - 練習
SELECT a.nationality,
       a.gender,
       AVG(r.rating) AS avg_rating,
       COUNT(r.rating) AS n_rating,
       COUNT(*) AS n_rentals,
       COUNT(DISTINCT a.actor_id) AS n_actors
  FROM renting AS r
  LEFT JOIN actsin AS ai ON ai.movie_id = r.movie_id
  LEFT JOIN actors AS a ON ai.actor_id = a.actor_id
 WHERE r.movie_id IN ( 
	     SELECT movie_id
	       FROM renting
	      GROUP BY movie_id
	     HAVING COUNT(rating) >= 4) AND r.date_renting >= '2018-04-01'
 GROUP BY GROUPING SETS ((nationality,gender),(nationality),(gender),());

/*
### FINISHED ON 2022/12/23 ###
*/