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