/* Домашнее задание №3*/
--  3.1 Используемы таблицы: salespeople, customers, orders

/*3.1.1 Напишите запрос, который вывел бы таблицу со столбцами в следующем порядке: city, sname,
snum, comm. (к первой или второй таблице, используя SELECT)*/

SELECT city, sname, snum, comm
FROM salespeople
ORDER BY city;


/*3.1.2  Напишите команду SELECT, которая вывела бы оценку(rating), сопровождаемую именем
каждого заказчика в городе San Jose. (“заказчики”)*/

SELECT rating, cname
FROM customers
WHERE city ='San Jose';


/*3.1.3. Напишите запрос, который вывел бы значения snum всех продавцов из таблицы заказов без
каких бы то ни было повторений. (уникальные значения в “snum“ “Продавцы”)*/

SELECT DISTINCT snum
FROM orders;


/*3.1.4. Напишите запрос, который бы выбирал заказчиков, чьи имена начинаются с буквы G.
Используется оператор "LIKE": (“заказчики”)*/    

SELECT *
FROM customers
WHERE cname LIKE 'G%'; 


/*3.1.5. Напишите запрос, который может дать вам все заказы со значениями суммы выше чем $1,000.
(“Заказы”, “amt” - сумма)*/

SELECT *
FROM orders
WHERE amt > 1000;   


/*3.1.6. Напишите запрос который выбрал бы наименьшую сумму заказа.
(Из поля “amt” - сумма в таблице “Заказы” выбрать наименьшее значение)*/

SELECT *
FROM orders
WHERE amt = (SELECT min(amt) FROM orders);


/*3.1.7. Напишите запрос к таблице “Заказчики”, который может показать всех заказчиков, у которых
рейтинг больше 100 и они находятся не в Риме.*/

SELECT * 
FROM customers
WHERE rating >100 and city !='Rome';


--  3.2 Используемы таблицы: staff

/*3.2.1 Отсортируйте поле “зарплата” в порядке убывания и возрастания*/

-- в порядке убывания
SELECT *
FROM staff
ORDER BY salary DESC; 

-- в порядке возрастания
SELECT *
FROM staff
ORDER BY salary; 


/*3.2.2 Отсортируйте по возрастанию поле “Зарплата” и выведите 5 строк с наибольшей заработной платой (возможен подзапрос)*/

SELECT *
FROM staff
WHERE salary = (SELECT MAX(salary) FROM staff)
ORDER BY salary
LIMIT 5;


/*3.2.3 Выполните группировку всех сотрудников по специальности , суммарная зарплата которых превышает 100000*/

SELECT post, sum(salary) as sumSalary
FROM staff
GROUP BY post
HAVING sumSalary>100000