-- 1.1 Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток. 
-- С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день", 
-- с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".

DELIMITER //
DROP FUNCTION IF EXISTS format_now//
CREATE FUNCTION format_now (format time)
returns varchar(20) DETERMINISTIC
begin
	
	declare format_now varchar(20);

	if format > '06:00:00' and format < '12:00:00' THEN
  		set format_now = 'Доброе утро';
  	
	elseif format > '12:01:00' and format < '18:00:00' THEN
  		set format_now = 'Добрый день';
  	
  	elseif format > '18:01:00' and format < '23:59:59' THEN
  		set format_now = 'Добрый вечер';
  	
  	elseif format > '00:00:00' and format < '05:59:59' THEN
  		set format_now = 'Доброй ночи';
  	
    end if;
   
    return format_now;
   
end//

select format_now(DATE_FORMAT(NOW(), "%H:%i:%s"))//

-- 1.2 В таблице products есть два текстовых поля: name с названием товара и description с его описанием.
-- Допустимо присутствие обоих полей или одно из них. Ситуация, когда оба поля принимают неопределенное значение NULL неприемлема.
-- Используя триггеры, добейтесь того, чтобы одно из этих полей или оба поля были заполнены. 
-- При попытке присвоить полям NULL-значение необходимо отменить операцию.


DROP TABLE IF EXISTS products1;
CREATE TABLE products1 (
	name varchar(255),
	description varchar(255));

drop TRIGGER if exists check_null_insert;

DELIMITER //

CREATE TRIGGER check_null_insert BEFORE INSERT ON products1
FOR EACH ROW
begin
    IF new.name is null then
        signal sqlstate '45000'
        set message_text = 'Неверное значение NULL';
       
    elseif new.description is null then
        signal sqlstate '45000'
        set message_text = 'Неверное значение NULL';
   
  END IF;
END//

DELIMITER ;


insert into products1 values
('Kefir', 'white'),
('Kolaider', null);
		
-- 2.1 В базе данных shop и sample присутствуют одни и те же таблицы, учебной базы данных. 
-- Переместите запись id = 1 из таблицы shop.users в таблицу sample.users. Используйте транзакции

DROP TABLE IF EXISTS shop1;
CREATE TABLE shop1(
	users int(10),
	name varchar(255),
	description varchar(255));

DROP TABLE IF EXISTS sample2;
CREATE TABLE sample2(
	users int(10),
	name varchar(255),
	description varchar(255));

insert into shop1 values
(1,'power', 'white'),
(2,'Avitominoz', null);

insert into sample2 values
(3,'Fisting', 'light'),
(4,'Vitamin C', null);

START TRANSACTION;

insert into sample2 SELECT * FROM shop1 WHERE users = 1;
delete from shop1 where  users = 1;
commit;



-- 2.2 Создайте представление, которое выводит название name товарной позиции из таблицы products
-- и соответствующее название каталога name из таблицы catalogs.

DROP TABLE IF EXISTS products1;
CREATE TABLE products1 (
	id int,
	name varchar(255),
	description varchar(255));

insert into products1 values
(1,'Kefir', 'white'),
(2,'Kolaider', null);

DROP TABLE IF EXISTS catalogs2;
CREATE TABLE catalogs2 (
	id int,
	name varchar(255),
	description varchar(255));

insert into catalogs2 values
(1,'very white like our power hehe', 'nnnnn'),
(4,'Kolaider', null);

CREATE or replace VIEW view_na
AS 
  SELECT p.name as play, c.name as cell
  FROM products1 as p JOIN catalogs2 as c
  ON p.id = c.id;


DROP VIEW IF exists view_na























	

 






