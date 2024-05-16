Create database Pizzasales

create table order_details (
order_details_id int not null,
order_id int not null,

pizza_id text not null,
quantity int not null,
primary key (order_details_id) );

-- Retrieve the total number of orders placed
select count(order_id)as total_orders from orders;
 
 -- Calculate the total revenue generated from pizza sales. 
SELECT * FROM pizzasales.pizzas;
SELECT 
    ROUND(SUM(order_details.quantity * pizzas.price),
            2) AS total_sales
FROM
    order_details
        JOIN
    pizzas ON pizzas.pizza_id = order_details.pizza_id
    
   -- Identify the highest-priced pizza.

SELECT pizza_types.name, pizzas.price,
FROM
    pizza_types
        JOIN
    pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
ORDER BY pizzas.price DESC
LIMIT 1;

-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
Group by pizza_types.name order by quantity desc 
limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered. 
select pizza_types.category,
sum(order_details.quantity) as quantity
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id 
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by quantity desc;

-- Determine the distribution of orders by hour of the day.
select hour(order_time) as hour, count(order_id) as order_count from orders
group by hour(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.

select category, count(name) from pizza_types
group by category

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select round ( avg(quantity), 0) from 
(select orders.order_date, sum(order_details.quantity)as quantity
from orders join order_details
on orders.order_id = order_details.order_id
group by orders.order_date) as order_quantity ;

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name, 
sum(order_details.quantity * pizzas.price) as revenue
from pizza_types join pizzas
on pizzas.pizza_type_id = pizza_types.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.name order by revenue desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue.
select pizza_types.category, 
round(sum(order_details.quantity * pizzas.price) /(select 
round(sum(order_details.quantity * pizzas.price),
2) as total_sale
from order_details
join pizzas on pizzas.pizza_id = order_details.pizza_id )*100,2) as revenue
from pizza_types join pizzas
on pizza_types.pizza_type_id = pizzas.pizza_type_id
join order_details
on order_details.pizza_id = pizzas.pizza_id
group by pizza_types.category order by revenue desc;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
SELECT name, revenue
FROM (
    SELECT category, name, revenue,
           RANK() OVER (PARTITION BY category ORDER BY revenue DESC) AS rn
    FROM (
        SELECT pizza_types.category, pizza_types.name, 
               SUM(order_details.quantity * pizzas.price) AS revenue
        FROM pizza_types
        JOIN pizzas ON pizza_types.pizza_type_id = pizzas.pizza_type_id
        JOIN order_details ON order_details.pizza_id = pizzas.pizza_id
        GROUP BY pizza_types.category, pizza_types.name
    ) AS A
) AS B
WHERE rn <= 3;

