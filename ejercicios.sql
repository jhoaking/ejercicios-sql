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


--![x]/ TRANSACCIONES 

Implementa una transacción que registre una nueva orden de un cliente y actualice el stock de los productos. 
Si el stock es insuficiente, revierte la transacción.


start transaction 
		insert into ordenes(cliente_id,fecha,total) values(1,'2025-03-27',14.2);
		
		update productos set  stock = stock - 1 where producto_id = 1;
		
		

		if( select stock from productos where producto_id = 1) < 0 then 
			rollback;	
		else 
	commit
	 	end if