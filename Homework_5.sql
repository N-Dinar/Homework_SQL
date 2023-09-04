CREATE TABLE cars
(
id INT PRIMARY KEY AUTO_INCREMENT,
name VARCHAR(25) NOT NULL,
cost INT NOT NULL
);

INSERT INTO cars (name, cost)
VALUES
('Audi', 52642),
('Mercedes', 57127),
('Scoda', 9000),
('Volvo', 29000),
('Bentley', 350000),
('Citroen', 21000),
('Hummer', 41400),
('Volkswagen', 21600);

# Задача 1.	Создайте представление, в которое попадут автомобили 
# стоимостью до 25 000 долларов
CREATE VIEW cheap_cars
	AS SELECT * 
	FROM cars 
	WHERE cost < 25000;

# Задача 2.	Изменить в существующем представлении порог для стоимости: 
# пусть цена будет до 30 000 долларов (используя оператор ALTER VIEW) 
ALTER VIEW cheap_cars
	AS SELECT * 
	FROM cars 
	WHERE cost < 30000;


# Задача 3. Создайте представление, в котором будут только автомобили марки “Шкода” и “Ауди”
CREATE VIEW scoda_audi
	AS SELECT *
    FROM cars
    WHERE name = 'Scoda' OR name = 'Audi';


# Задача 4. Вывести название и цену для всех анализов, которые продавались 
# 5 февраля 2020 и всю следующую неделю.
/*
Есть таблица анализов Analysis:
an_id — ID анализа;
an_name — название анализа;
an_cost — себестоимость анализа;
an_price — розничная цена анализа;
an_group — группа анализов.

Есть таблица групп анализов Groups:
gr_id — ID группы;
gr_name — название группы;
gr_temp — температурный режим хранения.

Есть таблица заказов Orders:
ord_id — ID заказа;
ord_datetime — дата и время заказа;
ord_an — ID анализа.
*/

CREATE TABLE Analysis
(
an_id INT,
an_name VARCHAR(40),
an_cost INT,
an_price INT,
an_group VARCHAR(40)
); 

CREATE TABLE Orders_2
(
ord_id INT,
ord_datetime VARCHAR(25),
ord_an INT
);

# Соединяю две таблицы: Analysis, Orders по ID анализа 
# и вывожу анализы за 05.02.2020 и всю следующую неделю
SELECT A.an_id, A.an_name, A.an_price, O.ord_datetime
FROM Analysis AS A
JOIN Orders_2 AS O
ON A.an_id = O.ord_an
WHERE O.ord_datetime BETWEEN '05.02.2020' AND '12.02.2020';


/* Задача 5. Добавьте новый столбец под названием «время до следующей станции». 

Чтобы получить это значение, мы вычитаем время станций для пар смежных станций. 
Мы можем вычислить это значение без использования оконной функции SQL, 
но это может быть очень сложно. Проще это сделать с помощью оконной функции LEAD.
Эта функция сравнивает значения из одной строки со следующей строкой, 
чтобы получить результат. В этом случае функция сравнивает значения в столбце «время» 
для станции со станцией сразу после нее.
*/

CREATE TABLE timetable
(
train_id INT,
station VARCHAR(40),
station_time TIME
);

INSERT INTO timetable(train_id, station, station_time)
VALUES
(110, 'San Francisco', '10:00:00'),
(110, 'Redwood City', '10:54:00'),
(110, 'Palo Alto', '11:02:00'),
(110, 'San Jose', '12:35:00'),
(120, 'San Francisco', '11:00:00'),
(120, 'Palo Alto', '12:49:00'),
(120, 'San Jose', '13:30:00')
;

# LEAD(station_time) OVER(PARTITION BY train_id - значение в следующей строке по группам
# функция SUBTIME - для вычисления разницы между TIME значениями.
SELECT *,
    SUBTIME(LEAD(station_time) 
    OVER(PARTITION BY train_id), station_time) AS 'time_to_next_station'
FROM timetable;