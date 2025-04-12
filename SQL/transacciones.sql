
--![x]/ TRANSACCIONES 

//Implementa una transacción que registre una nueva orden de un cliente y actualice el stock de los productos. 
Si el stock es insuficiente, revierte la transacción.


start transaction 
		insert into ordenes(cliente_id,fecha,total) values(1,'2025-03-27',14.2);
		
		update productos set  stock = stock - 1 where producto_id = 1;
		
		

		if( select stock from productos where producto_id = 1) < 0 then 
			rollback;	
		else 
	commit
	 	end if




// Crea una transacción que revierta una compra (devuelve el dinero al cliente y repone el stock del producto).

start transaction 
		update  productos set stock = stock - 1 where producto_id = 1 and 
		(select SUM(total)from ordenes where cliente_id = 1) > 0;
	
	  if ROW_COUNT() = 0 then 
	  	rollback;
	  else 
	  	commit
	 end if		

Crear una transacción que inserte una nueva orden y agregue productos a detalle_orden.

start transaction 
		insert into ordenes(cliente_id,fecha,total) values (1,'2025-03-29',20.2);
		update productos set stock = stock +1 where producto_id = 1;
	if  (ROW_COUNT() = 0) then 
    	rollback;
	else 
    	commit ;
	end if ;

Hacer una transacción que descuente stock al insertar una nueva orden.

	start transaction 
		insert into ordenes(cliente_id,fecha,total) values (1,'2025-03-29',20.2);
		update productos set stock = stock -1 where producto_id = 1;
	select  row_count();
	rollback;
    commit;

hacer una transaccion que  al acutalizar en productos muestre el estado que fie afectado
	
	start transaction
	 	insert into productos(nombre,precio,stock) values ('jabon',20.2,64);
		
		select last_INSERT_ID();
	
		insert into productos(producto_id,nombre,precio,stock) values (1,'jabon',20.2,64);
		
		update productos set  stock = stock -3 where producto_id = 1;
	rollback;
	commit;

Actualizar múltiples productos en una transacción.
Cambia el stock de 2 productos y guarda solo si ambas actualizaciones funcionan.

START TRANSACTION;

UPDATE productos 
SET stock = stock - 2 
WHERE producto_id = 1;

UPDATE productos 
SET stock = stock - 1 
WHERE producto_id = 2;

COMMIT;


Transacción con eliminación: Elimina una orden y si la eliminación de la orden no se realiza correctamente, haz un rollback.
		
START TRANSACTION;

// esto se hace para eliminar las tablas que tienen relacon por llave forenea.

DELETE FROM detalle_orden WHERE orden_id = 1;

DELETE FROM ordenes WHERE orden_id = 1;


UPDATE productos
SET stock = stock + 1
WHERE producto_id IN (SELECT producto_id FROM detalle_orden WHERE orden_id = 1);

ROLLBACK;

Inserta un nuevo cliente y una nueva orden (asociada a ese cliente) en una transacción. Si alguno de los insertos falla, realiza un rollback.

START TRANSACTION;

INSERT INTO clientes(nombre, email, direccion) VALUES (' pete', 'PETE@gmail.com', 'Av augenia  123');
INSERT INTO ordenes(cliente_id, fecha, total) VALUES (LAST_INSERT_ID(),'2024-04-10',45.20);

SELECT cliente_id, total FROM ordenes WHERE  cliente_id = LAST_INSERT_ID();

ROLLBACK;


Inserta un detalle de orden, pero antes de hacerlo ve  si el cliente existe y si el producto tiene suficiente stock. Si alguna condición no se cumple, realiza un rollback.


START TRANSACTION; 


SELECT cliente_id  FROM ordenes WHERE cliente_id = 2;
SELECT * FROM ordenes WHERE orden_id = 2;
SELECT stock FROM productos WHERE producto_id = 1;

INSERT INTO detalle_orden(orden_id, producto_id, cantidad, precio) VALUES (2,1,20,40.2);

ROLLBACK;
