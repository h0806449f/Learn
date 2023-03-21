-- string functions : concat and concat_ws
SELECT first_name,
       middle_name,
       last_name,
       CONCAT(fitst_name, '-', middle_name, '-'. last_name) AS 'full_name'
       CONCAT_WS(' - ',fitst_name,middle_name,last_name) AS 'same_full_name' -- 功能同上
  FROM table_name
 WHERE condition_name
 ORDER BY order_name


-- string functions : substring

SELECT SUBSTRING ('Hello World', 1, 4); -- Hell   string from 1 to 4
SELECT SUBSTRING ('Hello World', 7);    -- World
SELECT SUBSTRING ('Hello World', -5);   -- World
SELECT SUBSTRING (column_name,1,5)      -- select column's 1-5 character
SELECT SUBSTR (column_name,1,5)         -- 同上

SELECT CONCAT(col_1, col_2, ...)

SELECT REPLACE('words', 'be replaced', 'replacing')

SELECT CHAR_LENGTH('Henry') -> 5

SELECT UPPER('Henry')   -> HENRY
       LOWER('Henry')   -> henry

SELECT DISTINCT first_name, last_name     --DISTINCT 將同時區分兩個欄位資料
  FROM table_name

SELECT column_name
  FROM table_name
 WHERE column_name
  LIKE '%\%%'                             --標題帶有 % 的內容


-- Aggregate Function & GROUP BY


-- Logical operatoe

SELECT column_name
  FROM table_name
 WHERE column_name != condition_name
   AND NOT LIKE condition_name            -- AND = &&, OR = ||

SELECT name,birthdaytime 
  FROM people
 WHERE birthdaytime BETWEEN CAST('1980-01-01' AS DATETIME)   -- CAST 轉變資料形式
                        AND CAST('2000-01-01' AS DATETIME)   -- in this case: string to date

-- "CASE WHEN" conditions END AS columnname

SELECT title,
       released_year,
       CASE WHEN released_year >= 2000 THEN 'year after 2000'  -- 條件之間不需要逗號
            WHEN condition_name THEN 'xxx'
            WHEN condition_name THEN 'xxxx'
            ELSE 'xxxxx'
        END AS YEAR_SORTED
  FROM books;


-- RELATIONSHIP TABLE , JOIN
-- create database -> 
-- create tables (customers and orders)-> 
-- insert infomation in both table -> 
   
CREATE DATABASE customers_and_orders;

CREATE TABLE customers 
(
	id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(100),
	last_name VARCHAR(100),
	email VARCHAR(100)
);

CREATE TABLE orders
(
	id INT PRIMARY KEY AUTO_INCREMENT,
	order_date DATE,
	amount DECIMAL(8,2),
	customer_id INT,
	FOREIGN KEY(customer_id) REFERENCES customers(id) -- setting foreign key
);

INSERT INTO customers (first_name, last_name, email) 
VALUES ('Boy', 'George', 'george@gmail.com'),
       ('George', 'Michael', 'gm@gmail.com'),
       ('David', 'Bowie', 'david@gmail.com'),
       ('Blue', 'Steele', 'blue@gmail.com'),
       ('Bette', 'Davis', 'bette@aol.com');
       
INSERT INTO orders (order_date, amount, customer_id)
VALUES ('2016/02/10', 99.99, 1),
       ('2017/11/11', 35.50, 1),
       ('2014/12/12', 800.67, 2),
       ('2015/01/03', 12.50, 2),
       ('1999/04/11', 450.25, 5);
       
-- JOIN (IMPLICT INNER JOIN)
SELECT *
  FROM orders
  JOIN customers
    ON orders.customer_id = customers.id;

-- 額外練習
SELECT first_name,
       last_name,
       order_date,
       SUM(amount) AS total_spent
  FROM customers
  JOIN orders
    ON customers.id = orders.customer_id
 GROUP BY orders.customer_id
 ORDER BY total_spent;

-- JOIN (LEFT JOIN) AND replace NULL to other data type
SELECT first_name,
       last_name,
       IFNULL(SUM(amount), 0) AS total_spent
       -- 第一：檢查該變數是否為NULL ; 第二：如第一變數為NULL，則顯示第二變數
  FROM customers
  LEFT JOIN orders
    ON customer.id = orders.customer_id
 GROUP BY customer.id
 ORDER BY total_spent;

-- EXERCISE

CREATE TABLE students (
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100)
);

CREATE TABLE papers (
  title VARCHAR (100),
  grade INT,
  student_id INT,
  FOREIGN KEY (student_id) REFERENCES students(id)
);

-- 1 (CORRECT)
SELECT first_name, title, grade
  FROM students
  JOIN papers
    ON srudents.id = papers.student_id;

-- 2 (CORRECT)
SELECT first_name, title, grade
  FROM students
  LEFT JOIN papers
    ON student.id = papers.student_id;

-- 3 (missing ,)
SELECT first_name,
       IFNULL (title, 'MISSING'),
       IFNULL (grade, 0)
  FROM students
  LEFT JOIN papers
    ON student.id = papers.student_id;

-- 4 (IFNULL 順序)
SELECT first_name,
       IFNULL (AVG(grade), 0) AS average
  FROM students
  JOIN papers
    ON student.id = papers.student_id
 GROUP BY first_name
 ORDER BY grade;

--5 (IFNULL 順序, CASE WHEN 不完整, ORDER BY DESC)
SELECT first_name,
       IFNULL (AVG(grade), 0) AS average,
       CASE WHEN AVG(grade) IS NULL THEN 'FAILING' --此行避免出現 NULL 錯誤
            WHEN AVG(grade) >= 75 THEN 'PASSING'
            WHEN AVG(grade) < 75 THEN 'FAILING'
        END AS passing_status
  FROM students
  JOIN papers
    ON student.id = papers.student_id
 GROUP BY first_name
 ORDER BY grade DESC;


-- MANY TO MANY TABLES
CREATE TABLE reviewers(
  id INT AUTO_INCREMENT PRIMARY KEY,
  first_name VARCHAR(100),
  last_name VARCHAR(100)
);

CREATE TABLE series(
  id INT AUTO_INCREMENT PRIMARY KEY,
  title VARCHAR(100),
  released_year YEAR(4), -- DATA-TYPE YEAR 四位數
  genre VARCHAR(100)
);

CREATE TABLE reviews(
  id INT AUTO_INCREMENT PRIMARY KEY,
  rating DECIMAL (2,1), -- DATA TYPE (一共幾位數 EX 2 -> 9.5 ; 小數點後有幾位數)
  series_id INT,
  reviewer_id INT,
  FOREIGN KEY series_id REFERENCES series(id),           -- 注意資料架構
  FOREIGN KEY reviewer_id REFERENCES reviewers(id)       -- 設置完欄位後，再一次設置FOREIGN KEY
);

-- EXERCISE_1
SELECT title,
       rating
  FROM series
  JOIN reviews
    ON series.id = reviews.series_id;

-- EXERCISE_2
SELECT title,
       AVG(rating) AS avg_rating
  FROM series
  JOIN reviews
    ON series.id = reviews.series_id
 GROUP BY title                     --此案 GROUP series.id 較好，避免有重複的series title
 ORDER BY avg_rating;

-- EXERCISE_3
SELECT first_name,
       last_name,
       rating
  FROM reviewers
  JOIN reviews
    ON reviewers.id = reviewers.reviewer_id;

-- EXERCISE_4
SELECT title
  FROM series
  LEFT JOIN reviews
    ON series.id = reviews.series_id
 WHERE reviews.rating IS NULL;               --LEFT JOIN會顯示沒有rating的series，需再設立條件

-- EXERCISE_5
SELECT genre,
       ROUND(AVG(rating),2) AS avg_rating    -- ROUND (欄位,小數點後的位數)
  FROM series
  JOIN reviews
    ON series.id = reviews.series_id
 GROUP BY series.genre
 ORDER BY series.genr;

-- EXERCISE_6
SELECT first_name,
       last_name,
       COUNT(rating) AS COUNT,
       IFNULL(MIN(rating), 0) AS MIN,
       IFNULL(MAX(rating), 0) AS MAX,
       IFNULL(AVG(rating), 0) AS AVG,           -- 未評分，會顯示NULL
       CASE WHEN COUNT(rating) > 0 THEN 'ACTIVE' -- 注意CASE WHEN 使用的是 AS 之前的欄位名稱
            ELSE 'INACTIVE'
        END AS STATUS
       -- CASE WHEN 可以用下面此行取代
       IF (COUNT(rating) > 0, 'ACTIVE', 'INACTIVE') AS 'STATUS'
  FROM reviewers
  LEFT JOIN reviews                             -- LEFT JOIN 顯示有些作者未評分，於reviews沒有紀錄
    ON reviewers.id = reviews.reviewers_id
 GROUP BY reviewers.id;

-- EXERCISE_7
SELECT title,
       rating,
       CONCAT(first_name,' ', last_name) AS reviewer -- CONCAT (欲加欄位_1,中間區隔,欲加欄位_2)
  FROM reviews
  JOIN series
    ON reviews.series_id = series.id
  JOIN reviewers
    ON reviews.reviewer_id = reviewers.id
 ORDER BY title;


--
-- SCHEMA DESIGN 從頭創立DATABASE, INSERT DATA (instagram exercise)
--
CREATE DATABASE ig_clone;
USE ig_clone;

-- comment line : source 資料夾路徑/檔案名稱.sql

CREATE TABLE users(
  id INT AUTO_INCREMENT PRIMARY KEY,
  username VARCHAR(255) UNIQUE NOT NULL,         -- username 不重複
  created_at TIMESTAMP DEFAULT NOW()    -- 新資料型態，TIMESTAMP
);

CREATE TABLE photos(
  id INT AUTO_INCREMENT PRIMARY KEY,
  image_url VARCHAR(255) NOT NULL,
  user_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY photos(user_id) REFERENCES users(id)
);

CREATE TABLE comments(
  id INT AUTO_INCREMENT PRIMARY KEY,
  comment VARCHAR(255) NOT NULL,
  user_id INT NOT NULL,
  photo_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY comments(user_id) REFERENCES users(id),
  FOREIGN KEY comments(photo_id) REFERENCES photos(id)
);

-- INSERT DATA (以 table-comments 為例)
INSERT INTO comments(comment, user_id, photo_id) VALUES
('good photo!',1,2),
('nice shoot!!!',3,2),
('long time no see~~',2,1);

CREATE TABLE likes(                              -- 此table 不會被refer所以可以不需要放id
  user_id INT NOT NULL,
  photo_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  FOREIGN KEY likes(user_id) REFERENCES users(id),
  FOREIGN KEY likes(photo_id) REFERENCES photos(id),
  PRIMARY KEY (user_id, photo_id)                -- 可以確保一位user僅對一張photo點一次like!!!
);

CREATE TABLE follows(
  following_id INT NOT NULL,
  followed_id INT NOT NULL,
  created_at TIMESTAMP DEFAULT NOW(),
  -- 可以 refer 同一個欄位，如下
  FOREIGN KEY follows(following_id) REFERENCES users(id),
  FOREIGN KEY follows(followed_id) REFERENCES users(id),
  PRIMARY KEY (following_id, followed_id)         -- 確保不重複 follow
);

-- HASTAG 的解決方法，以下為較優解，用兩個tables完成

CREATE TABLE tags(
  id INT AUTO_INCREMENT PRIMARY KEY,
  tag_name VARCHAR(255) UNIQUE,
  created_at TIMESTAMP DEFAULT NOW()
);

CREATE TABLE photo_tags(
  photo_id INT NOT NULL,
  tag_id INT NOT NULL,
  FOREIGN KEY photo_tags(photo_id) REFERENCES photos(id),
  FOREIGN KEY photo_tags(tag_id) REFERENCES tags(id),
  PRIMARY KEY (photo_id, tag_id)
);

--
-- 實際運用 (instagram exercise)
--
-- source 檔案路徑/檔案名稱.sql 執行整份 sql 檔案

-- 1. Finding 5 oldest users
SELECT *
  FROM users
 ORDER BY created_at
 LIMIT 5;

-- 2. Most popular registration date
SELECT dayname(created_at) AS week_day,
       COUNT(*) AS total_count
  FROM users
 GROUP BY week_day
 ORDER BY total_count DESC;

-- 3. Who never post any photo
SELECT username,
       image_url
  FROM users
  LEFT JOIN photos
    ON users.id = photos.user_id
 WHERE photos.image_url IS NULL;

-- 4. Who's photo gets most likes
SELECT users.username,
       photos.photo_id,
       COUNT(likes.photo_id) AS total_likes
  FROM users
  JOIN photos
    ON user.id = photos.user_id
  JOIN likes
    ON photos.id = likes.photo_id
 GROUP BY users.username, photos.photo_id
 ORDER BY total_likes DESC;

-- 5. User's average post
-- use sub query
SELECT (SELECT COUNT(*) FROM photos) / 
       (SELECT COUNT(*) FROM users);

-- 6. Top 5 hashtags were used
SELECT tags.tag_name,
       COUNT(tag_id) AS total_count_hash
  FROM tags
  JOIN photo_tags
    ON tags.id = photo_tags.tag_id
 GROUP BY tag_id
 ORDER BY total_count_hash DESC
 LIMIT 5;

-- 7. who likes every single photo (bot issue)
SELECT username,
       COUNT(*) AS number_likes
  FROM users
  JOIN likes
    ON users.id = likes.user_id
 GROUP BY likes.user_id
 ORDER BY number_likes DESC                           -- 此時，GROUP BY 後才要計算資料，使用HAVING
HAVING number_likes = (SELECT COUNT(*) FROM photos); -- subquery 計算照片總數量


-- youtube link : https://www.youtube.com/watch?v=en6YPAgc6WM&t=40283s
-- Github link :　https://github.com/ccquach/mysql-bootcamp