-- Users and permissions
create user 'admin'@'localhost' identified by 'admin';
grant all privileges on chocolate_shop to 'admin'@'localhost';

create user 'manager'@'localhost' identified by 'manager';
grant insert, update, select on chocolate_shop.* to 'manager'@'localhost';

create user 'customer'@'localhost' identified by 'customer';
grant insert on chocolate_shop.orders to 'customer'@'localhost';

-- Subqueries, CTEs, window functions
with may_2024 as (
	select * from orders where date > '2024-05-01'
)
select chocolate_id, sum(quantity) as num_ordered from may_2024
group by chocolate_id
order by num_ordered desc;

with orders_by_date as (
	select date, count(date) as num_orders from orders group by date order by 1
)
select date, avg(num_orders) over (order by date rows between 6 preceding and current row) as seven_day_rolling_average from orders_by_date;

select * from loyal_customers where num_orders = (select max(num_orders) from loyal_customers);

-- Order insertion transaction
begin;
insert into orders (quantity, price, date, chocolate_id, customer_id) values
	(18, 18.00, '2024-05-13', 1, 26),
	(12, 15.00, '2024-05-12', 3, 8);
commit;
rollback;
