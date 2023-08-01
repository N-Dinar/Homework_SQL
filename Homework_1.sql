/* Домашнее задание №1 */
/* 1.1 Создайте таблицу с мобильными телефонами, используя графический интерфейс. Заполните БД данными */
USE phonesdb;


/* 1.2 Выведите название, производителя и цену для товаров, количество которых превышает 2 */
SELECT ProductName, Manufacturer, Price From phonelist WHERE ProductCount > 2;


/* 1.3 Выведите весь ассортимент товаров марки “Samsung” */
SELECT * From phonelist WHERE Manufacturer = 'Samsung';


/* 1.4  С помощью регулярных выражений найти: */
/* 1.4.1  Товары, в которых есть упоминание "Iphone" */
SELECT * From phonelist WHERE ProductName like '%iPhone%';

/* 1.4.2  "Samsung" */
SELECT * From phonelist WHERE Manufacturer like '%Samsung%';

/* 1.4.3  Товары, в которых есть ЦИФРЫ */
SELECT * From phonelist WHERE ProductName rlike '[0-9]';

/* 1.4.4  Товары, в которых есть ЦИФРА "8"*/
SELECT * From phonelist WHERE ProductName like '%8%'