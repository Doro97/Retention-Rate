-- group users by week 
SELECT id, week(sale_date) AS sale_week, amount
FROM sale
GROUP BY id, week(sale_date);

-- extract first week of purchase for each user 
SELECT id, min(week(sale_date)) AS start_week, amount
FROM sale
GROUP BY id;

-- merge the tables above 
SELECT a.id, a.sale_date, a.amount, b.start_week AS start_week
FROM
(
SELECT id, week(sale_date) AS sale_date, amount
FROM sale
GROUP BY id, week(sale_date)) a,
(
SELECT id, min(week(sale_date)) AS start_week,amount
FROM sale 
GROUP BY id) b
WHERE a.id = b.id;

-- calculate the number of the week 
SELECT a.id,a.sale_date, a.amount, b.start_week AS start_week, b.amount,
a.sale_date-start_week AS week_num
FROM
(SELECT id, week(sale_date), sum(amount) AS amount
FROM sale
GROUP BY id, week(sale_date)) a,
(SELECT id, min(week(sale_date)) AS start_week, sum(amount) AS amount
FROM sale
GROUP BY id) b
WHERE a.id =b.id;

SELECT first_week,
     SUM(CASE WHEN week_num = 0 THEN 1 ELSE 0 END) AS week_0,
       SUM(CASE WHEN week_num = 1 THEN 1 ELSE 0 END) AS week_1,
       SUM(CASE WHEN week_num = 2 THEN 1 ELSE 0 END) AS week_2,
       SUM(CASE WHEN week_num = 3 THEN 1 ELSE 0 END) AS week_3,
       SUM(CASE WHEN week_num = 4 THEN 1 ELSE 0 END) AS week_4,
       SUM(CASE WHEN week_num = 5 THEN 1 ELSE 0 END) AS week_5,
       SUM(CASE WHEN week_num = 6 THEN 1 ELSE 0 END) AS week_6
       FROM  
       (SELECT a.id,a.sale_date, b.start_week,a.sale_date-start_week as week_num, b.amount
       FROM   
       (SELECT id, sale_date
        FROM sale
		GROUP BY id,week(sale_date)) a,
        (SELECT id, min(week(sale_date)) AS start_week, sum(amount) AS amount
		FROM sale
		GROUP BY id) b
        where a.id=b.id
    
        ) AS with_week_number
    
         GROUP BY start_week
     ORDER BY start_week;


