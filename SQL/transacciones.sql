
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