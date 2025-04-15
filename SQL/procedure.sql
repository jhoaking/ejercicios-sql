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
