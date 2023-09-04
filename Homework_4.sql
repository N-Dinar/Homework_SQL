# Задание 1. Вывести на экран сколько машин каждого цвета для машин марок BMW и LADA
SELECT COUNT(*) AS number_of_cars, COLOR, MARK
FROM AUTO
WHERE MARK = 'BMW' or MARK = 'LADA'
GROUP BY MARK, COLOR;


# Задание 2. Вывести на экран марку авто и количество AUTO не этой марки
SELECT DISTINCT MARK,
(SELECT COUNT(*) FROM AUTO AS a1 WHERE a1.MARK != a2.MARK)
AS number_of_cars_another_marks FROM AUTO AS A2;

# Через вложенный запрос SELECT...(SELECT...)...

# вывести уникальные значения по столбцу MARK,
# вывести под псевдонимом number_of_cars_another_mark 
# количество строк из таблицы AUTO под псевдонимом а1, где значения по столбцу MARK 
# отличаются от значений по столбцу MARK из таблицы AUTO под псевдонимом а2. 


# Задание 3. 
# Даны 2 таблицы. Напишите запрос, который вернет строки из таблицы test_a, 
# id которых нет в таблице test_b, НЕ используя ключевого слова NOT.

CREATE TABLE  test_a (id INT, test VARCHAR(10));
CREATE TABLE test_b (id INT);

INSERT INTO test_a (id, test) 
VALUES
(10, 'A'),
(20, 'A'),
(30, 'F'),
(40, 'D'),
(50, 'C');

INSERT INTO  test_b (id) 
VALUES
(10),
(30),
(50);

SELECT test_a.id, test 
FROM test_a
LEFT JOIN test_b 
ON test_a.id = test_b.id
WHERE test_b.id IS NULL;

# при объединении LEFT JOIN 
# берём всё из левой + из правой то, что подходит
# + WHERE - добавляем те строки, где в столбце id таблицы test_b - пустое значение 