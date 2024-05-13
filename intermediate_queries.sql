-- Top-selling chocolate 
select orders.chocolate_id, name, sum(quantity) as number_ordered from orders 
join inventory on inventory.chocolate_id = orders.chocolate_id
group by chocolate_id order by 3 desc;

-- Lowest inventory
select * from inventory order by quantity_in_stock;

-- Most popular days
select count(date) as number_of_orders, date from orders group by date order by 1 desc;

-- Total revenue between 1/24-5/24
select sum(price) as revenue from orders where date between '2024-01-01' and '2024-05-01';

-- Top 10 most loyal customers from view
create view loyal_customers as
select customers.customer_id, name, email, sum(orders.price) as total_spent, count(orders.customer_id) as num_orders from customers
join orders on orders.customer_id = customers.customer_id
group by orders.customer_id
order by 4 desc;

select * from loyal_customers order by total_spent desc limit 10;

-- Index of customer ids
create index customer_ids on customers (customer_id);

-- Procedure to fetch customer info by id
delimiter //
create procedure get_customer_by_id(customer_id int)
begin
	select name, email from customers where customers.customer_id = customer_id;
end //

delimiter ;

call get_customer_by_id(98); 
