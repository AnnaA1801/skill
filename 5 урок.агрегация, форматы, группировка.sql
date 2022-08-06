-- Пусть в таблице users поля created_at и updated_at оказались незаполненными. 
-- Заполните их текущими датой и временем.

create database test;
use test;
create table users (
id int unsigned not null auto_increment primary key,
last_name varchar(100),
create_at datetime,
update_at datetime);

insert into users values 
(null, 'Abaev', null, null),
(null, 'Kirkov', null, null),
(null, 'Barev', null, null);

select * from users;

drop table users;

update users set create_at =now(),
update_at=now();


-- Таблица users была неудачно спроектирована. Записи created_at и updated_at были заданы 
-- типом VARCHAR и в них долгое время помещались значения в формате 20.10.2017 8:10. 
-- Необходимо преобразовать поля к типу DATETIME, сохранив введённые ранее значения.
drop table users;

create table users (
id int unsigned not null auto_increment primary key,
last_name varchar(100),
create_at varchar(100),
update_at varchar(100));

insert into users values 
(null, 'Abaev', '20.10.2017 8:10', '20.10.2021 17:10'),
(null, 'Kirkov', '25.02.2009 16:43', '21.11.2013 23:10'),
(null, 'Barev', '03.10.2020 1:15', '19.11.2017 2:50');

select * from users;


alter table users alter column create_at datetime;

alter table users modify create_at datetime;

/*
select date_format('20.10.2017 8:10', '%Y %m %d %H %i %S');

select date_format('14.10.1917', '%d.%m.%Y');

select convert('14.10.1917', date);
*/

select STR_TO_DATE('20.10.2017 8:10', '%d.%m.%Y %H:%i');

create table users_new as  
(select id, last_name, STR_TO_DATE(create_at, '%d.%m.%Y %H:%i') create_at, 
STR_TO_DATE(update_at, '%d.%m.%Y %H:%i') update_at
from users);

alter table users_new modify create_at datetime;

select * from users_new;

desc users_new;

drop table users;

rename table users_new to users;

select * from users;

desc users;



- Тема Операции, задание 3
-- В таблице складских запасов storehouses_products в поле value могут встречаться самые
-- разные цифры: 0, если товар закончился и выше нуля, если на складе имеются запасы.
-- Необходимо отсортировать записи таким образом, чтобы они выводились в порядке увеличения
-- значения value. Однако, нулевые запасы должны выводиться в конце, после всех записей.
DROP TABLE IF EXISTS storehouses_products;
CREATE TABLE storehouses_products (
  id SERIAL PRIMARY KEY,
  storehouse_id INT UNSIGNED,
  product_id INT UNSIGNED,
  value INT UNSIGNED COMMENT 'Запас товарной позиции на складе',
  created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
  updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) COMMENT = 'Запасы на складе';

INSERT INTO
  storehouses_products (storehouse_id, product_id, value)
VALUES
  (1, 543, 0),
  (1, 789, 2500),
  (1, 3432, 0),
  (1, 826, 30),
  (1, 719, 500),
  (1, 638, 1);
  
 select *
 from storehouses_products
 order by case when value>0 then 0
  			   else 1
  			   end,
  			   value;
 -- IF( value = 0, 1, 0 ) , value;
  			  
  			  
 -- Тема Операции, задание 4
-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в
-- августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')

-- Таблица users создана для задания 2 темы Операции
  			  
 DROP TABLE IF EXISTS users;
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
) COMMENT = 'Покупатели';

INSERT INTO
  users (name, birthday_at, created_at, updated_at)
VALUES
  ('Геннадий', '1990-10-05', '07.01.2016 12:05', '07.01.2016 12:05'),
  ('Наталья', '1984-11-12', '20.05.2016 16:32', '20.05.2016 16:32'),
  ('Александр', '1985-05-20', '14.08.2016 20:10', '14.08.2016 20:10'),
  ('Сергей', '1988-02-14', '21.10.2016 9:14', '21.10.2016 9:14'),
  ('Иван', '1998-01-12', '15.12.2016 12:45', '15.12.2016 12:45'),
  ('Мария', '2006-08-29', '12.01.2017 8:56', '12.01.2017 8:56'); 			  
 
 
 CREATE TABLE users_new (
  id SERIAL PRIMARY KEY,
  name VARCHAR(255) COMMENT 'Имя покупателя',
  birthday_at DATE COMMENT 'Дата рождения',
  created_at VARCHAR(255),
  updated_at VARCHAR(255)
);


create table users_new as  
(select id, name, birthday_at, STR_TO_DATE(created_at, '%d.%m.%Y %H:%i') created_at, 
STR_TO_DATE(updated_at, '%d.%m.%Y %H:%i') updated_at
from users);

alter table users_new modify created_at datetime;
alter table users_new modify updated_at datetime;

select * from users_new;

desc users_new;

drop table users;

rename table users_new to users;

select * from users;

desc users;

-- (по желанию) Из таблицы users необходимо извлечь пользователей, родившихся в
-- августе и мае. Месяцы заданы в виде списка английских названий ('may', 'august')

select * from users
where date_format(birthday_at, "%M") in ('may', 'august');





-- Тема Операции, задание 5
-- (по желанию) Из таблицы catalogs извлекаются записи при помощи запроса.
-- SELECT * FROM catalogs WHERE id IN (5, 1, 2);
-- Отсортируйте записи в порядке, заданном в списке IN.

DROP TABLE IF EXISTS catalogs;
CREATE TABLE catalogs (
  id SERIAL PRIMARY KEY,
  name VARCHAR(100) NOT NULL
) COMMENT = 'Каталог';

INSERT INTO catalogs VALUES
  (NULL, 'Процессоры'),
  (NULL, 'Материнские платы'),
  (NULL, 'Видеокарты'),
  (NULL, 'Жесткие диски'),
  (NULL, 'Оперативная память');
  
 
 SELECT * 
 FROM catalogs WHERE id IN (5, 1, 2)
 order by case when id=5 then 1
 when id=1 then 2
 else 3
 end;
 

-- Тема Агрегация, задание 1
-- Подсчитайте средний возраст пользователей в таблице users

select floor(avg(datediff(now(), birthday_at)/365.25)) from users;  

-- Тема Агрегация, задание 2
-- Подсчитайте количество дней рождения, которые приходятся на каждый из дней недели.
-- Следует учесть, что необходимы дни недели текущего года, а не года рождения.

select id, name, birthday_at, DAYOFWEEK(birthday_at), weekday(birthday_at)
from users;

SELECT DAYOFWEEK('2021-08-05') -- 1-воскресенье
, weekday('2021-08-05'); -- 0-понедельник

select weekday(concat('2022.', date_format(birthday_at, '%m.%d'))), count(id)
from users
group by weekday(concat('2022.', date_format(birthday_at, '%m.%d')))
order by weekday(concat('2022.', date_format(birthday_at, '%m.%d'))); 


-- Тема Агрегация, задание 3
-- (по желанию) Подсчитайте произведение чисел в столбце таблицы

-- Используйте таблицу catalogs, созданную для задания 5 темы Операции
select * from catalogs;

select exp(SUM(log(id)))
from catalogs;


