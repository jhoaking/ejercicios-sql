PROCEDURES

Crea un procedimiento almacenado que inserte una nueva orden en la tabla ordenes
y luego inserte los productos en la tabla detalle_orden asociándolos a la orden.

DELIMITER //

CREATE PROCEDURE insertar_orden(
IN i_nombre VARCHAR(40) ,
IN i_correo VARCHAR(30),
IN i_direccion VARCHAR(40),
IN i_fecha DATE, 
IN i_total_orden DECIMAL(10,2),
IN i_cantidad INT ,
IN i_precio_producto DECIMAL(10,2),
OUT o_salida VARCHAR(50) 
)
BEGIN

	DECLARE v_cliente_id INT DEFAULT 0;
	DECLARE v_orden_id INT DEFAULT 0;
	
	START TRANSACTION ;
	INSERT INTO clientes(nombre,email,direccion) VALUES(i_nombre,i_correo,i_direccion);
	SET v_cliente_id = LAST_INSERT_ID();
	
	INSERT INTO ordenes (cliente_id , fecha,total) VALUES (v_cliente_id,i_fecha,i_total_orden);
	SET v_orden_id = LAST_INSERT_ID();
	
	INSERT INTO detalle_orden(orden_id,producto_id,cantidad,precio) VALUES(v_orden_id,v_cliente_id,i_cantidad,i_precio_producto);
	
	COMMIT; 
	
	SET o_salida = "orden creada co nexito"
	

END //
DELIMITER ;



Procedimiento para actualizar precio de producto: 
Crea un procedimiento almacenado que actualice el precio de un producto dado su producto_id.


DELIMITER //

CREATE PROCEDURE sp_actualizar_producto(
  IN i_producto_id INT,
  IN i_nuevo_precio DECIMAL(10,2),
  OUT o_salida VARCHAR(50)
)
	BEGIN
  		START TRANSACTION;

		  UPDATE productos
		  SET precio = i_nuevo_precio
		  WHERE producto_id = i_producto_id;

  	COMMIT;

  	SET o_salida = 'Producto actualizado correctamente';
  	
	END //

DELIMITER ;



 Crea un procedimiento almacenado que inserte un nuevo cliente, incluyendo validaciones para verificar si el email ya existe.

DELIMITER // 
	
	CREATE PROCEDURE sp_insertar_cliente(
	IN i_nombre VARCHAR(30),
	IN i_email VARCHAR(50) ,
	IN i_direccion VARCHAR(30),
	OUT o_salida VARCHAR(30)
	)
		BEGIN
			DECLARE existe_email INT DEFAULT 0; 
	
			START TRANSACTION;
			
			SELECT COUNT(*) INTO existe_email FROM clientes WHERE email = i_email;
			
				IF existe_email != 0 THEN 
					SET o_salida = "ya existe ese correo";
				ROLLBACK;
				ELSE
				
				INSERT INTO clientes(nombre,email,direccion) VALUES(i_nombre,i_email,i_direccion);
					SET  o_salida = "se agrego el cliente";
				
				END IF;
 	COMMIT;

 END;

DELIMITER ;

CALL sp_insertar_cliente('pepe', 'pepe@gmail.com', 'Av siempre viva', @mensaje);
SELECT @mensaje;



Crea un procedimiento almacenado que elimine una orden y todos los detalles asociados a esa orden.

DELIMITER // 
	CREATE PROCEDURE sp_eliminar_orden(
		IN i_orden_id INT,
		OUT o_salida VARCHAR(30)
	) 
	 BEGIN 
		 DECLARE v_existe_orden INT DEFAULT 0;

		 START TRANSACTION;
		 
			SELECT COUNT(*) INTO v_existe_orden FROM ordenes WHERE orden_id = i_orden_id;
			
		    IF v_existe_orden != 0 THEN
		    	SET o_salida = "no hay ninguna orden";
		  ROLLBACK;
		  ELSE 
		  
		   DELETE FROM detalle_orden WHERE orden_id = i_orden_id;
		   DELETE FROM  ordenes WHERE orden_id = i_orden_id;
		
		 
		 	SET o_salida = "se elimino con exito la orden";
		 	
		 	END IF;
		 COMMIT;

	END//
DELIMITER ;

CALL sp_eliminar_orden(10, @mensaje);
SELECT @mensaje;


Crea un procedimiento que registre una compra de productos, actualizando el stock y creando una nueva orden.

DELIMITER // 
	CREATE PROCEDURE sp_registrar_y_cambiar_producto(
		IN i_nombre VARCHAR(30),
		IN i_precio DECIMAL (10,2),
		IN i_stock INT,
		IN i_cliente_id INT,
		OUT o_salida VARCHAR(50)
	)
		BEGIN 
			 DECLARE v_producto_id INT DEFAULT 0;
			 DECLARE v_orden_id INT DEFAULT 0;
			 
			START TRANSACTION 
			 INSERT INTO productos(nombre,precio,stock) VALUES (i_nombre, i_precio, i_stock);
			 	SET v_producto_id = LAST_INSERT_ID();
			 	
			INSERT INTO ordenes(cliente_id , fecha,total) VALUES(i_cliente_id , CURDATE(), i_precio * i_stock);
			 	SET v_orden_id = LAST_INSERT_ID();
			
			INSERT INTO detalle_orden(orden_id,producto_id,cantidad,precio) VALUES(v_orden_id,v_producto_id, i_stock, i_precio);
			
		 COMMIT;
		 SET o_salida = "se registro y actualizo con exito";

	END //
DELIMITER ;

CALL sp_registrar_y_cambiar_producto('Harina', 5.20, 4, 2, @res);
SELECT @res;


Crea un procedimiento almacenado que devuelva todos los detalles de una orden dada su orden_id.

DELIMITER // 
	CREATE PROCEDURE sp_devolver_orden(
		IN i_orden_id INT,
		OUT o_salida VARCHAR(50)
	)
		BEGIN 
				SELECT * FROM detalle_orden WHERE orden_id = i_orden_id;
				SET o_salida = "mostrando orden";

  END // 
DELIMITER ;


Crea un procedimiento almacenado que modifique el stock de un producto en función de una cantidad específica.

DELIMITER // 
	CREATE PROCEDURE sp_actualizar_stock(
		IN i_producto_id INT,
		IN i_cantidad INT ,
		OUT o_salida VARCHAR(50)
	)
		BEGIN 
			
			START TRANSACTION;
				UPDATE productos SET stock = i_cantidad WHERE producto_id = i_producto_id;
		COMMIT;
			SET o_salida = "se actualizo el producto";

	END//
DELIMITER ;



Crea un procedimiento que reciba un cliente_id y devuelva todas las órdenes asociadas a ese cliente.

DELIMITER //
	CREATE PROCEDURE sp_ordenes_de_cliente(
		IN i_cliente_id INT,
		OUT o_salida VARCHAR(50)
	)	
		BEGIN 
			 SELECT c.nombre , o.fecha, o.total FROM ordenes o 
			 	 INNER JOIN clientes c ON o.cliente_id = c.cliente_id
			 WHERE o.cliente_id = i_cliente_id;
		
			SET o_salida = 'Órdenes obtenidas exitosamente';

	END//
DELIMITER ;


Crea un procedimiento almacenado que permita transferir una cantidad de stock de un producto a otro.

DELIMITER //
	CREATE PROCEDURE sp_transferir_stock (
		IN i_producto_actual_id INT,
		IN i_producto_llegada_id INT,
		IN i_cantidad INT,
		OUT o_salida VARCHAR(50)
	)
		BEGIN 
			DECLARE v_stock_actual INT DEFAULT 0;
			START TRANSACTION;
				SELECT stock INTO v_stock_actual FROM productos WHERE producto_id = i_producto_actual_id;
			IF v_stock_actual < i_cantidad THEN
			ROLLBACK;
			SET o_salida = 'No hay suficiente stock para transferir';
		ELSE
		UPDATE productos SET stock = stock - i_cantidad WHERE producto_id = i_producto_actual_id;

		UPDATE productos SET stock = stock + i_cantidad WHERE producto_id = i_producto_llegada_id;

		COMMIT;
			SET o_salida = 'Stock transferido con éxito';
		END IF;
	END//
DELIMITER ;
