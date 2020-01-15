-- 1.1  Пусть в таблице users поля created_at и updated_at оказались незаполненными. Заполните их текущими датой и временем.

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

insert into users(created_at, updated_at) values
	(now(),now());

-- 1.2 Таблица users была неудачно спроектирована. Записи created_at и updated_at 
-- были заданы типом VARCHAR и в них долгое время помещались значения в формате "20.10.2017 8:10". 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введеные ранее значения

DROP TABLE IF EXISTS users2;
CREATE TABLE users2 (
  id SERIAL PRIMARY KEY,
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
);

insert into users2(created_at, updated_at) values
	('20.10.2017 8:10','14.12.2018 8:10');

SELECT STR_TO_DATE(created_at, '%d.%m.%Y') from users2;
SELECT STR_TO_DATE(updated_at, '%d.%m.%Y') from users2;

-- 1.3 В таблице складских запасов storehouses_products в поле value могут встречаться самые разные цифры:
-- 0, если товар закончился и выше нуля, если на складе имеются запасы. Необходимо отсортировать записи таким образом,
-- чтобы они выводились в порядке увеличения значения value. Однако, нулевые запасы должны выводиться в конце, 
-- после всех записей.

DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  name varchar(255),
  value INT DEFAULT null);
 
insert into storehouses_products values
	('Intel Core i3-8100', 2),
	('AMD FX-8320E', 3),
	('ASUS ROG MAXIMUS X HERO', 7),
	('Gigabyte H310M S2H', null),
	('MSI B250M GAMING PRO', 6);

select * from storehouses_products order by value desc

SELECT * FROM storehouses_products ORDER BY IF (value > 0, 0, 1), value;
  
-- 2.1 Подсчитайте средний возраст пользователей в таблице users

DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255),
  birthday_at DATE
  );
  

INSERT INTO users (name, birthday_at) VALUES
  ('Геннадий', '1990-10-05'),
  ('Наталья', '1984-11-12'),
  ('Александр', '1985-05-20'),
  ('Сергей', '1988-02-14'),
  ('Иван', '1998-01-12'),
  ('Мария', '1992-08-29');  
 
 
SELECT
  name, 
  birthday_at,
  (YEAR(CURRENT_DATE)-YEAR(birthday_at))-(RIGHT(CURRENT_DATE,5)<RIGHT(birthday_at,5)
  ) AS age
FROM users
ORDER BY name;

-- 2.2 Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели. 
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

SELECT 
  name,
  birthday_at,
  DAYNAME(birthday_at) as dayage
from users
order by name;

select DATE_FORMAT(DATE_ADD(birthday_at, INTERVAL (TIMESTAMPDIFF(YEAR, birthday_at, now())) year), '%W')
  as 'день недели', count('Количество дней рождения в дне недели')
  from users group by birthday_at;
  
  





