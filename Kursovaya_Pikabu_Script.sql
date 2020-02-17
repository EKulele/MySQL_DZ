
DROP DATABASE IF EXISTS pikabu;
CREATE DATABASE pikabu;
use pikabu;

DROP TABLE IF EXISTS users; -- Таблица с пользователями
CREATE TABLE users (
	id SERIAL PRIMARY KEY, 
    firstname VARCHAR(50),
    lastname VARCHAR(50), 
    email VARCHAR(120) UNIQUE,
    user_password VARCHAR(120), 
    INDEX users_firstname_lastname_idx(firstname, lastname)
);

DROP TABLE IF EXISTS `profiles`; -- профиль пользователя
CREATE TABLE `profiles` (
	user_id SERIAL PRIMARY KEY,
	nickname VARCHAR(50),
	rating INT,
	about_me text,
    gender CHAR(1),
    birthday DATE,
	photo_id BIGINT UNSIGNED NULL,
    created_at DATETIME DEFAULT NOW(),
    FOREIGN KEY (user_id) REFERENCES users(id) 
);

DROP TABLE IF EXISTS posts; --  посты
CREATE TABLE posts (
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
	header_body VARCHAR(50), -- заголовок поста
	body TEXT,
	media_id VARCHAR(255),
	comments VARCHAR(255), 
	post_rating INT, -- рейтинг поста
	tags varchar (255), 
    created_at DATETIME DEFAULT NOW(), 
    index (tags),
    INDEX (user_id),
    
    FOREIGN KEY (user_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS Subs; -- подписки и подписчики
CREATE TABLE Subs (
	from_user_id BIGINT UNSIGNED NOT NULL,
    to_user_id BIGINT UNSIGNED NOT NULL,
    `status` ENUM('subscriptions', 'Followers'),
	requested_at DATETIME DEFAULT NOW(),
	confirmed_at DATETIME,
	
    PRIMARY KEY (from_user_id, to_user_id),
	INDEX (from_user_id),
    INDEX (to_user_id),
    FOREIGN KEY (from_user_id) REFERENCES users(id),
    FOREIGN KEY (to_user_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS communities; -- группы
CREATE TABLE communities(
	id SERIAL PRIMARY KEY,
	name VARCHAR(150),

	INDEX communities_name_idx(name)
);

DROP TABLE IF EXISTS users_communities; -- пользователи групп
CREATE TABLE users_communities(
	user_id BIGINT UNSIGNED NOT NULL,
	community_id BIGINT UNSIGNED NOT NULL,
  
	PRIMARY KEY (user_id, community_id), -- чтобы не было 2 записей о пользователе и сообществе
    FOREIGN KEY (user_id) REFERENCES users(id),
    FOREIGN KEY (community_id) REFERENCES communities(id)
);

DROP TABLE IF EXISTS media_types; 
CREATE TABLE media_types(
	id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

DROP TABLE IF EXISTS media;
CREATE TABLE media(
	id SERIAL PRIMARY KEY,
    media_type_id BIGINT UNSIGNED NOT NULL,
    user_id BIGINT UNSIGNED NOT NULL,
  	body text,
    filename VARCHAR(255),
    size INT,
	metadata JSON,
    created_at DATETIME DEFAULT NOW(),
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,

    INDEX (user_id),
    FOREIGN KEY (media_type_id) REFERENCES users(id),
    FOREIGN KEY (media_type_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS likes; -- лайки и дизлайки
CREATE TABLE likes(
	id SERIAL PRIMARY KEY,
	user_id BIGINT UNSIGNED NOT NULL,
    dislike INT,
    like_id INT, 
    post_rating INT,
    created_at DATETIME DEFAULT NOW(),
	
    INDEX (user_id),
    
    FOREIGN KEY (user_id) REFERENCES posts(user_id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);


DROP TABLE IF EXISTS `photos`;
CREATE TABLE `photos` (
	id SERIAL PRIMARY KEY,
	`media_id` BIGINT unsigned NOT NULL,

    FOREIGN KEY (media_id) REFERENCES media(id),
    FOREIGN KEY (media_id) REFERENCES media_types(id)
);


DROP TABLE IF EXISTS `videos`;
CREATE TABLE `videos` (
	id SERIAL PRIMARY KEY,
	`movie_id` BIGINT unsigned not null,
	
    FOREIGN KEY (movie_id) REFERENCES media(id),
    FOREIGN KEY (movie_id) REFERENCES media_types(id)
);

DROP TABLE IF EXISTS notification; -- уведомления
CREATE TABLE notification (
	id SERIAL primary key,
	from_notif_id BIGINT UNSIGNED NOT NULL,
    to_usernotif_id BIGINT UNSIGNED NOT NULL,
	created_at DATETIME DEFAULT NOW(), 
	
    INDEX messages_from_notif_id (from_notif_id),
    INDEX messages_to_usernotif_id (to_usernotif_id),
    
    FOREIGN KEY (from_notif_id) REFERENCES users(id),
    FOREIGN KEY (from_notif_id) REFERENCES communities(id),
    FOREIGN KEY (from_notif_id) REFERENCES subs(from_user_id),
    FOREIGN KEY (to_usernotif_id) REFERENCES users(id),
    FOREIGN KEY (to_usernotif_id) REFERENCES subs(to_user_id)
);



-- скрипты наполнения БД данными;

insert into users values 
(1,'Jesus', 'Magomedov', 'holly@share.ru','123'),
(2,'Max', 'factor', 'holly11@share.ru','123'),
(3,'Dmitriy', 'Peskov', 'holly121@share.ru','123'),
(4,'Kirsten', 'Danst', 'hollymolly@share.ru','123'),
(5,'Gautama', 'Budva', 'hollynotcare@share.ru','123')
;

insert into posts(user_id, header_body, body, media_id, comments, post_rating, tags) values
(1,'My little pony', 'blablablablbalbalb',556,null,46,'omg'),
(2,'Not little pony', 'blablablablbalbalb',null,null,-52, null),
(3,'Very little pony', 'blablablablbalbalb',null,null,2166, 'omg'),
(4,'Like Ur IQ little pony', 'blablablablbalbalb',null,null,12,'omg'),
(5,'My little pony2', 'blablablablbalbalb2',55,null,4887,'omg');

insert into communities values
(5, 'Liga spravedlivosti'),
(6, 'Liga nespravedlivosti');

insert into users_communities(user_id, community_id) values
(1,5),
(2,5),
(3,6),
(4,5),
(5,5);

insert into likes(user_id, dislike, like_id) values
(1, 10, 56),
(2, 0, 52),
(3, 0, 166),
(4, 22, 34);



-- скрипты характерных выборок (включающие группировки, JOIN'ы, вложенные таблицы);

select * -- показывает все посты с медиа
from posts 
where media_id >0;

SELECT media_id, user_id FROM posts -- все медиа пользователя
WHERE user_id = (select id from users where email = 'holly@share.ru')
;

SELECT users.firstname, posts.header_body -- заголовки постов Пользователя
FROM users INNER JOIN posts
ON users.id = posts.user_id
order by users.firstname, posts.header_body
;

-- представления (минимум 2); 
CREATE or replace VIEW view_fresh_posts -- показывает свежие посты (где рейтинг ниже 25)
AS 
  SELECT header_body, body as Sveghee
  FROM posts as p 
  where p.post_rating <25;
 
CREATE or replace VIEW view_hot_posts -- показывает "горячие" посты(где рейтинг выше 25)
AS 
  SELECT header_body, body as Goryachee
  FROM posts as p 
  where p.post_rating>25;

CREATE or replace VIEW view_best_posts -- показывает лучшие посты (где рейтинг выше 2000)
AS 
  SELECT header_body, body as Luchshee
  FROM posts as p 
  where p.post_rating>2000;
 
-- хранимые процедуры / триггеры;

-- мб процедуру с дистриктом по рейтингу постов в группе


drop procedure if exists posts_rand; -- показывает по 3 лучших поста пользователя

delimiter //
create procedure posts_rand(in user_id INT)
  begin
	select user_id, header_body, body, post_rating
	from posts
	where post_rating>20
	order by rand()
	limit 3; 
  END//
DELIMITER ; 


call posts_rand(1);

















