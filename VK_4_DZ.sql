-- первое задание. заполнил 2 таблицы, материал усвоил

use vk;

INSERT INTO users VALUES
('155', 'Miniya1', 'Newvanov', 'chtozaden1@mail.ru', NULL),
('24', 'Miniya2', 'Newvanov', 'chtozaden2@mail.ru', NULL),
('37', 'Miniya3', 'Newvanov', 'chtozaden3@mail.ru', NULL),
('46', 'Miniya4', 'Newvanov', 'chtozaden4@mail.ru', NULL),
('5999', 'Miniya5', 'Newvanov', 'chtozaden5@mail.ru', NULL),
('64', 'Miniya6', 'Newvanov', 'chtozaden6@mail.ru', NULL),
('71', 'Miniya7', 'Newvanov', 'chtozaden7@mail.ru', NULL),
('88', 'Miniya8', 'Newvanov', 'chtozaden8@mail.ru', NULL),
('96', 'Miniya9', 'Newvanov', 'chtozaden9@mail.ru', NULL),
('100', 'Miniya10', 'Newvanov', 'chtozaden10@mail.ru', NULL)
;

INSERT INTO communities values
('1','Group1'),
('2','Group2'),
('3','Group3'),
('4','Group4'),
('5','Group5'),
('6','Group6'),
('7','Group7'),
('8','Group8'),
('9','Group9'),
('10','Group10')
;

INSERT INTO photo_albums values
('154','myboringlife1','155'),
('1','myboringlife2','64'),
('15','myboringlife3','71'),
('55','myboringlife4','88')
;


-- второе задание

select distinct firstname
from users; 

-- третье задание

ALTER TABLE profiles ADD COLUMN is_active varchar(50) NOT NULL DEFAULT 'False'

UPDATE vk.profiles
SET  
	is_active='True'
	
WHERE user_id=24;

-- четвертое задание

INSERT INTO messages (from_user_id, to_user_id, body, created_at) values
('24','37','Voluptatem ut quaerat quia. Pariatur esse amet ratione qui quia. In necessitatibus reprehenderit et. Nam accusantium aut qui quae nesciunt non.','1995-08-28 22:44:29'),
('46','5999','Sint dolores et debitis est ducimus. Aut et quia beatae minus. Ipsa rerum totam modi sunt sed. Voluptas atque eum et odio ea molestias ipsam architecto.',now()),
('64','71','Sed mollitia quo sequi nisi est tenetur at rerum. Sed quibusdam illo ea facilis nemo sequi. Et tempora repudiandae saepe quo.','2019-12-27 19:45:58')
;

delete from messages
where created_at > now()  -- '2019-12-26 23:44:58'
;
























