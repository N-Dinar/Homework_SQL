-- Домашнее задание 6

/* 6.1 Создайте таблицу users_old, аналогичную таблице users. Создайте процедуру, 
с помощью которой можно переместить любого (одного) пользователя из таблицы users
 в таблицу users_old. (использование транзакции с выбором commit или rollback – обязательно). */
 
DROP TABLE IF EXISTS users_old;
CREATE TABLE users_old (
	id INT UNSIGNED NOT NULL UNIQUE ,
    firstname VARCHAR(50),
    lastname VARCHAR(50) COMMENT 'Фамилия',
    email VARCHAR(120) UNIQUE
);


DROP PROCEDURE IF EXISTS transfer_users;
DELIMITER //
CREATE PROCEDURE transfer_users(
user_id BIGINT,
OUT  tran_result varchar(100))
BEGIN
	
	DECLARE `_rollback` BIT DEFAULT b'0';
	DECLARE code varchar(100);
	DECLARE error_string varchar(100); 
	DECLARE CONTINUE HANDLER FOR SQLEXCEPTION
	BEGIN
 		SET `_rollback` = b'1';
 		GET stacked DIAGNOSTICS CONDITION 1
			code = RETURNED_SQLSTATE, error_string = MESSAGE_TEXT;
	END;
	
	START TRANSACTION;
	
    -- вставка данных в новую таблицу
    INSERT INTO users_old (id, firstname, lastname, email) 
    SELECT users.id, users.firstname, users.lastname, users.email  
    FROM users
    WHERE users.id = user_id ;
    
    -- удаление записи из старой таблицы
    DELETE FROM users
    WHERE users.id = user_id;
    
    -- формирование текста результата процедуры
	IF `_rollback` THEN
		SET tran_result = CONCAT('Ошибка: ', code, ' Текст ошибки: ', error_string);
		ROLLBACK;
	ELSE
		SET tran_result = 'OK';
		COMMIT;
	END IF;
END//
DELIMITER ;

SELECT * FROM users;

CALL transfer_users(6, @tran_result); -- запуск процедуры
SELECT @tran_result; -- вывод результатов
SELECT * FROM users_old;


/*6.2 Создайте хранимую функцию hello(), которая будет возвращать приветствие, в зависимости от текущего времени суток.
 С 6:00 до 12:00 функция должна возвращать фразу "Доброе утро", с 12:00 до 18:00 функция должна возвращать фразу "Добрый день",
 с 18:00 до 00:00 — "Добрый вечер", с 00:00 до 6:00 — "Доброй ночи".  */
 
DROP FUNCTION IF EXISTS hello;
DELIMITER //
CREATE FUNCTION hello()
RETURNS VARCHAR(20) NO SQL
BEGIN
	DECLARE timer TIME;
	DECLARE answer VARCHAR(20); 
	
    SET timer = CURTIME();
	
    IF timer >= TIME('06:00:00') AND timer < TIME('12:00:00') THEN
    SET answer ="Доброе утро";
	ELSEIF timer >= TIME('12:00:00') AND timer<TIME('18:00:00') THEN
    SET answer ="Добрый день";
    ELSEIF timer >=TIME('18:00:00') AND timer< TIME('24:00:00') THEN
    SET answer ="Добрый вечер";
    ELSE
    SET answer ="Доброй ночи";
    END IF;
	RETURN answer;
END//
DELIMITER ;

SELECT hello();


/* 6.3 Создайте таблицу logs типа Archive. Пусть при каждом создании записи в таблицах users, 
communities и messages в таблицу logs помещается время и дата создания записи, 
название таблицы, идентификатор первичного ключа. */

DROP TABLE IF EXISTS logs;

CREATE TABLE IF NOT EXISTS logs 
(
time_create DATETIME DEFAULT CURRENT_TIMESTAMP,
table_name VARCHAR(20),
id_user INT 
);

-- для таблицы users
DROP TRIGGER IF EXISTS Log_user;
DELIMITER //
CREATE TRIGGER Log_user AFTER INSERT ON users
FOR EACH ROW
BEGIN
    DECLARE id_tbl INT;
    SELECT id INTO id_tbl FROM users ORDER BY id DESC LIMIT 1;
    INSERT INTO logs (table_name, id_user)
    VALUES ('users', id_tbl);
END//
DELIMITER ;

-- для таблицы communities
DROP TRIGGER IF EXISTS Log_communities;
DELIMITER //
CREATE TRIGGER Log_communities AFTER INSERT ON communities
FOR EACH ROW
BEGIN
    DECLARE id_tbl INT;
    SELECT id INTO id_tbl FROM communities ORDER BY id DESC LIMIT 1;
    INSERT INTO logs (table_name, id_user)
    VALUES ('communities', id_tbl);
END//
DELIMITER ;

-- для таблицы messages
DROP TRIGGER IF EXISTS Log_messages;
DELIMITER //
CREATE TRIGGER Log_messagess AFTER INSERT ON messages
FOR EACH ROW
BEGIN
    DECLARE id_tbl INT;
    SELECT id INTO id_tbl FROM messages ORDER BY id DESC LIMIT 1;
    INSERT INTO logs (table_name, id_user)
    VALUES ('messages', id_tbl);
END//
DELIMITER ;