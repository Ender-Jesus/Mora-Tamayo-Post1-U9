# LABORATORIO: ENTRADA Y SALIDA AVANZADOS (POST-CONTENIDO 1)

REPOSITORIO: ender-mora-Post1-U9

-------------------------------------------------------------------------
CHECKPOINT 1: LECTURA DEL PUERTO DE ESTADO DEL TECLADO (TECL.ASM)
-------------------------------------------------------------------------
* Desarrollo: 
Se implementó un programa en lenguaje ensamblador x86 (NASM) para interactuar directamente con el controlador de teclado 8042. El código realiza un bucle de polling sobre el puerto de estado (64h) monitoreando el bit OBF. Cuando este cambia, lee el scancode del puerto de datos (60h) y lo muestra en pantalla convertido a hexadecimal.

* Arreglo para su funcionamiento:
Al ejecutar el programa desde la consola, este capturaba inmediatamente el "Break Code" de la tecla Enter (9Ch) al ser liberada, finalizando instantáneamente. Para solucionarlo, se añadió un filtro con las instrucciones `CMP AL, 9Ch` y `JE .poll` justo después de la lectura del puerto de datos. Esto obliga al programa a ignorar la liberación del Enter residual y quedarse esperando la pulsación de una nueva tecla.

-------------------------------------------------------------------------
CHECKPOINT 2: POLLING CON TIMEOUT (POLL_T.ASM)
-------------------------------------------------------------------------
* Desarrollo: 
[cite_start]Se implementó una versión mejorada del polling para el puerto de teclado[cite: 467]. [cite_start]Para evitar que el programa se cuelgue si el hardware no responde, se agregó un contador de reintentos en el registro CX, apoyado por la instrucción LOOP[cite: 477].

* Observación de la ejecución: 
[cite_start]Al ajustar el contador a un valor bajo y ejecutar POLL_T.COM sin presionar ninguna tecla, el bucle agotó sus intentos correctamente[cite: 493]. [cite_start]El programa detectó el "Timeout", imprimió el mensaje "Timeout: sin respuesta del dispositivo" [cite: 492] y finalizó devolviendo el control a DOSBox. Como detalle, el prompt (C:\U9P1>) se imprimió en la misma línea porque la cadena del mensaje original no incluía caracteres de salto de línea (CR/LF).
-------------------------------------------------------------------------
CHECKPOINT 3: ESCRITURA AL PUERTO PARALELO LPT1 (LPT1.ASM)
-------------------------------------------------------------------------
* Desarrollo: 
Se implementó el protocolo Centronics para el envío de datos a través del puerto paralelo (0378h). El programa coloca el carácter "A" (41h) en el bus de datos y posteriormente genera un pulso activo en bajo en el pin STROBE mediante el registro de control (037Ah), esperando 1µs con un bucle de retardo.

* Observación de la ejecución: 
Durante las pruebas, el programa original se quedaba bloqueado en un bucle infinito en la etiqueta `.wait_ready`. Esto ocurrió porque DOSBox, al no tener una impresora física emulada conectada, retornaba constantemente un 0 en el bit 7 (BUSY#) del puerto de estado (0379h). Para permitir la ejecución del pulso STROBE y la finalización exitosa del programa, se comentó la instrucción `JZ .wait_ready`, demostrando así el correcto envío de la señal al hardware virtual.

-------------------------------------------------------------------------