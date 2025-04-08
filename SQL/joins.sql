ejercicios sobre joins  avanzados

SELECT * FROM menus

/ejercicio de joins que filtra segun el nombre de (desayuno, almuerzo,cena) en el having 

select m.nombre,m.descripcion , m.precio, m.menu_id , t.nombre,r.nombre,r.direccion from menus m
inner join tipos t on m.tipo_id = t.tipo_id
inner join restaurantes r on m.restaurante_id = r.restaurante_id
group by  m.nombre, m.descripcion, m.precio, m.menu_id, t.nombre, r.nombre, r.direccion
having  t.nombre = 'cena' // desayuno o almuerzo 
order by m.precio ASC ;



/usando otra tabla 
--![x]/ INNERS


Obtener la lista de clientes y sus órdenes, mostrando el nombre del cliente y la fecha de la orden.

select c.nombre as cliente, o.fecha as fecha_orden ,d.cantidad , d.precio from detalle_orden d
inner join ordenes o on d.orden_id = o.orden_id
inner join clientes c on o.cliente_id = c.cliente_id;

 Listar los productos que han sido pedidos al menos una vez, mostrando su nombre y el número de veces que han sido vendidos.

select p.nombre,p.precio,p.stock , c.nombre as cliente_que_compro, o.fecha , d.cantidad  from detalle_orden d
inner join productos p on d.producto_id = p.producto_id
inner join ordenes o on d.orden_id = o.orden_id
inner join clientes c on o.cliente_id = c.cliente_id
 where d.cantidad > 1 ;


 Obtener la cantidad total vendida por cada producto, incluyendo aquellos que nunca han sido vendidos.

 select  p.nombre , p.precio, p.stock ,SUM(d.cantidad) as cantidad_total from detalle_orden d
 inner join productos p on d.producto_id = p.producto_id
 group by p.nombre,p.precio,p.stock
 order by  cantidad_total desc ;


Mostrar el cliente que más ha gastado en órdenes junto con el total gastado.
 
select c.cliente_id , o.fecha , SUM(o.total) as total_gastado ,d.cantidad , p.nombre from ordenes o
inner join clientes c on o.cliente_id = c.cliente_id
inner join detalle_orden d on o.orden_id = d.orden_id
inner join productos p on d.producto_id = p.producto_id
group by c.cliente_id ,o.fecha, p.nombre, d.cantidad
having SUM(o.total) > 2
order by total_gastado  desc  ;

 Obtener todas las órdenes junto con el nombre del cliente y la cantidad total de productos comprados en cada una.

 	select c.nombre,p.nombre, SUM(d.cantidad) as cantidad_total,o.fecha, d.precio  from detalle_orden d
	inner join productos p on d.producto_id = p.producto_id
	inner join ordenes o on d.orden_id = o.orden_id
	inner join clientes c on o.cliente_id = c.cliente_id
	group by  c.nombre,p.nombre,o.fecha, d.precio
	order by cantidad_total desc ;


Listar los productos que se han vendido en todas las órdenes (productos presentes en todas las órdenes registradas).

	select p.nombre,c.cliente_id , o.fecha,o.total , p.stock, d.precio from detalle_orden d
	inner join productos p on d.producto_id = p.producto_id
	inner join ordenes o on d.orden_id = o.orden_id
	inner join clientes c on o.cliente_id = c.cliente_id;

// Muestra una lista con todos los productos vendidos, 
incluyendo el nombre del cliente que los compró y la fecha de la compra.  

    select o.orden_id, c.nombre as nombre_cliente , p.nombre as nombre_producto,
    d.cantidad as cantidad_vendida , o.fecha from ordenes o 
    inner join clientes c on o.cliente_id = c.cliente_id
    inner join detalle_orden d on o.orden_id = d.orden_id
    inner join productos p on d.producto_id = p.producto_id;


Obtén el total gastado por cada cliente en todas sus órdenes, ordenado de mayor a menor gasto.

    select MAX(o.orden_id) as ordenes,c.cliente_id as cliente_id, c.nombre ,MAX(o.total) as total  from ordenes  o
    inner join clientes c on o.cliente_id = c.cliente_id
    group by c.cliente_id , c.nombre 
    order by total asc ;


Muestra los productos que han sido comprados más de una vez y la cantidad total vendida de cada uno.

select p.nombre , o.total , MAX(d.cantidad) as CANTIDAD  from detalle_orden d
inner join productos p on d.producto_id = p.producto_id
inner join ordenes o on d.orden_id =  o.orden_id
where o.total > 2 
group by  p.nombre,o.total
order by CANTIDAD ASC ;

Mostrar los clientes que han comprado todos los productos disponibles al menos una vez.


select c.nombre,p.nombre,d.cantidad, p.stock from detalle_orden d 
inner join productos p on d.producto_id = p.producto_id
inner join ordenes o on d.orden_id = o.orden_id
inner join clientes c on o.cliente_id = c.cliente_id
where d.cantidad > 1;


Listar los productos cuyo precio promedio de venta (en detalle_orden) sea mayor que el precio base registrado en productos.

select p.nombre, p.stock,  p.precio ,AVG(d.precio) as precio_promedio from detalle_orden d 
inner join productos p on d.producto_id = p.producto_id
group by p.nombre, p.stock,  p.precio
having  AVG(d.precio) > p.precio // podria generar errores a futuro si el precio es el mismo;
order by p.nombre desc;

 Obtener la lista de clientes que han hecho al menos una compra cada mes en el último año.

  select c.nombre, p.nombre,o.fecha,d.cantidad,o.total from  detalle_orden d
 inner join productos p on d.producto_id = p.producto_id
 inner join ordenes o on d.orden_id = o.orden_id
 inner join clientes c on o.cliente_id = c.cliente_id
 where  d.cantidad > 1 and o.fecha >= '2025-03-01'
 order by o.fecha desc ;


