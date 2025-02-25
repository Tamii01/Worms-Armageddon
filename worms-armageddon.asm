.data

mensaje1:	.asciz "Ingrese un entero para mover el disparo.\n"
longmensaje1= . - mensaje1

mensaje2:	.asciz "Ingrese un entero para cambiar la pendiente.\n"
longmensaje2= . - mensaje2

mensajeturno1:	.asciz "Turno del Jugador 1.\n"
longmsj1= . - mensajeturno1

mensajeturno2:	.asciz "Turno del Jugador 2.\n"
longmsj2= . - mensajeturno2

acierto1: .asciz "¡Acertaste J1!\n"
acierto2: .asciz "¡Acertaste J2!\n"
longacierto= . - acierto1

vida1:	.asciz "\n Esta es la vida 1.\n"
longvida1= . - vida1

vida2:	.asciz "\n Esta es la vida 2.\n"
longvida2= . - vida2

vida3:	.asciz "\n Esta es la vida 3.\n"
longvida3= . - vida3

vida4:	.asciz "\n Esta es la vida 4.\n"
longvida4= . - vida4

vida5:	.asciz "\n Esta es la vida 5.\n"
longvida5= . - vida5

ingreso1: .asciz "  "
pendiente1: .asciz "  "

ingreso2: .asciz "  "
pendiente2: .asciz "  "




mapa: .asciz "______________________________________________________________________________________|\n                                                                                      |\n          *** WORMS ARMAGEDDON - ORGA 1 ***                                           |\n______________________________________________________________________________________|\n                                                                                      |\n                                                                                      |\n                                                                                      |\n                                                                                      |\n                                                                                      |\n                                                                                      |\n           +------------+                                                             |\n           |            |                                             @               |\n           |            |                                             ####            |\n           |            |                                            +----------------+\n           +------------+                                            |                |\n                                                                     |                |\n                                                                     |                |\n                                                                     |                |\n                                               +--------------+      |                |\n                                               |              |      |                |\n                     @                         |              |      |                |\n                  ####                         |              |      |                |\n+---------------------------------------+      |              |      |                |\n|                                       |      |              |      |                |\n|                                       |      +--------------+      |                |\n|                                       |                            |                |\n|                                       |                            |                |\n|                                       |                            +----------------+\n|                                       |                                             |\n+---------------------------------------+                                             |\n______________________________________________________________________________________|\n"

longmapa= . - mapa


.text

input:					@ La etiqueta donde se guarda el ingreso se carga en r1.
	push {lr}			@ Buenas practicas para conservar la posicion original del programa.

	mov r7,#3			@ El sistema toma datos.
	mov r0,#0			@ Indicamos que es una Entrada.
	mov r2,#2			@ La cantidad de caracteres a tomar.	
	swi 0				@ Interrupcion del sistema.
	
	pop {lr}			@ Buenas practicas para recuperar la posicion original del programa.
	bx lr				@ Pasa a la linea siguiente al llamado a la subrutina.


	
ins_dot_der:	
	push {lr}
	
	bl p_init			@ Definimos el punto inicial del disparo.
	
	bl disparo
	
	bl while_der
	
	pop {lr}
	bx lr

ins_dot_izq:	
	push {lr}
	
	bl p_init			@ Definimos el punto inicial del disparo.
	
	bl disparo
	
	bl while_izq
	
	pop {lr}
	bx lr

	

p_init: 

	push {lr}
	
	mov r5,#88			@ La cantidad de columnas o la longitud de cada nivel es de 88 espacios.
	
	mov r10,#0
	mul r10,r1,r5		@ Guardamos la posición de la fila de la matriz donde está la lombriz.	
	add r0,r10			@ La sumamos al punto de partida del mapa para estar en esa posición de Y.
	
	cmp r3,#50			@ Para saber de que lado está.
	addlt r3,r2			@ Si está en la mitad izquierda, sumamos el valor del input_x.	
	subgt r3,r2			@ Sino restamos.

	add r0,r3			@ Sumamos ese valor para obtener la posición inicial del disparo.	
	
	
	pop {lr}			
	bx lr

disparo:
	push {lr}
	push {r2}
	mov r2,#'*'			@ Cargamos "*" en r2.
	strb r2,[r0]			@ Inserta el "*" de r2 en la dirección del mapa indicada.
	pop {r2}
	pop {lr}
	bx lr

while_der:
	push {lr}
	

	bl trayectoria_der			@ Función lineal para definir la siguiente posición donde van los *.
	
	bl disparo
	
	bl trayectoria_der			@ Busco la siguiente posición para saber si podemos avanzar.

	mov r6,#0
	add r6,r0
	ldrb r0,[r0]			@ Leemos lo que está en esa posición.
	
	
	cmp r0,#' '				@ Comparar el valor que hay con el guion bajo ASCII.
	
	mov r8,#'x'
	strneb r8,[r6] 
	add r1,#1				@ Baja una fila.
	sub r3,r4				@ Retrocedemos las posiciones avanzadas.
	
	pop {lr}
	beq while_der			@ Mientras sea igual distinto, que vuelva a ejecutarse el ciclo while.
	
	bx lr

trayectoria_der:				@ Donde se controla la trayectoria segun input.
	
	push {lr}
	ldr r0,=mapa			
	
	sub r1,#1				@ Resto una fila.
	mov r10,#0
	mul r10,r1,r5			@ Guardamos la posición de la fila de la matriz donde está la lombriz.	
	add r0,r10				@ La sumamos al punto de partida del mapa para estar en esa posición.

	
	add r3,r4			@ Sumamos el valor del input para correr la posición.
	
	add r0,r3			@ Sumamos ese valor para obtener la posición inicial del disparo.
	
	pop {lr}			
	bx lr


while_izq:
	push {lr}
	

	bl trayectoria_izq			@ Función lineal para definir la siguiente posición donde van los *.
	
	bl disparo
	
	bl trayectoria_izq			@ Busco la siguiente posición para saber si podemos avanzar.

	mov r6,#0
	add r6,r0
	ldrb r0,[r0]			@ Leemos lo que está en esa posición.
	
	cmp r0,#' '				@ Comparar el valor que hay con el guion bajo ASCII.
	mov r8,#'x'
	strneb r8,[r6] 
	sub r1,#1				@ Baja una fila.
	add r3,r4				@ Retrocedemos las posiciones avanzadas.
	

	pop {lr}
	beq while_izq			@ Mientras sea igual distinto, que vuelva a ejecutarse el ciclo while.
	
	bx lr

trayectoria_izq:				@ Donde se controla la trayectoria segun input.
	
	push {lr}
	ldr r0,=mapa			
	
	add r1,#1				@ Suma una fila.
	mov r10,#0
	mul r10,r1,r5			@ Guardamos la posición de la fila de la matriz donde está la lombriz.	
	add r0,r10				@ La sumamos al punto de partida del mapa para estar en esa posición.

	sub r3,r4
	
	add r0,r3			@ Sumamos ese valor para obtener la posición inicial del disparo.
	
	pop {lr}			
	bx lr
	
output:					@ Imprime lo que esta en r1.
	push {lr}
	
	mov r7,#4			@ Para imprimir en pantalla los datos.
	mov r0,#1			@ Indica que es de tipo Salida.	
									
	swi 0				@ Interrupcion del sistema para que se ejecute el codigo.

	pop {lr}
	bx lr


turno_p1:
	push {lr}
	ldr r1,=mensaje1
	mov r2,#longmensaje1
	bl output
	
	ldr r1,=ingreso1
	bl input			@ El usuario ingresa un valor para el desplazamiento en x del cañon.
	
	ldr r1,=mensaje2
	mov r2,#longmensaje2
	bl output

	ldr r1,=pendiente1
	bl input			@ Ahora otro para la pendiente. 

	
	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	mov r1,#21			@ La fila 21 es donde está la lombriz 1.
	
	ldr r2,=ingreso1
	ldrb r2,[r2]
	sub r2,#0x30
	
	mov r3,#22			@ Se selecciona el punto en X base para el disparo.
	
	ldr r4,=pendiente1
	ldrb r4,[r4]
	sub r4,#0x30
	
	bl ins_dot_der			@ Ingresa "*" en el mapa.
	
	ldr r1,=mapa
	mov r2,#longmapa				
	bl output			@ Imprime.


	pop {lr}
	bx lr

turno_p2:
	push {lr}
	ldr r1,=mensaje1
	mov r2,#longmensaje1
	bl output
	
	ldr r1,=ingreso2
	bl input			@ El usuario ingresa un valor para el desplazamiento en x del cañon.
	
	ldr r1,=mensaje2
	mov r2,#longmensaje2
	bl output

	ldr r1,=pendiente2
	bl input			@ Ahora otro para la pendiente. 

	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	mov r1,#12			@ La fila 12 es donde está la lombriz 2.
	
	ldr r2,=ingreso2
	ldrb r2,[r2]
	sub r2,#0x30
	
	mov r3,#69			@ La cantidad de espacios en X a desplazarse.
	
	ldr r4,=pendiente2
	ldrb r4,[r4]
	sub r4,#0x30
	
	bl ins_dot_izq			@ Ingresa "*" en el mapa.
	
	
	ldr r1,=mapa
	mov r2,#longmapa				
	bl output			@ Imprime.
	
	pop {lr}
	bx lr

impacto:
	push {lr}
	
	push {r1}
	mul r1,r2,r5
	add r0,r1
	add r0,r3
	ldrb r0,[r0]
	cmp r0,#'x'
	
	pop {r1}
	beq colision
	
	
	pop {lr}
	bx lr

colision: 
	
	
	mov r2,#longacierto				
	bl output					@ Imprime.

	
	b fin
	
	
.global main



main:

	@--- Parte inicial ----- 
	@--- Se dibuja el mapa para que los jugadores se situen.
	
	
	ldr r1,=mapa
	mov r2,#longmapa
	bl output			@ Imprime el mapa.


	@--- Inicio de juego ---- 
	@--- El primer ingreso de datos.

					@ Posición de la lombriz 1.
					@ Posición de la lombriz 2.

@Etapa 1
					
	@--- Turno de P1 ---
	
	ldr r1,=mensajeturno1
	mov r2,#longmsj1
	bl output

	ldr r1,=vida1
	mov r2,#longvida1
	bl output

	bl turno_p1
	
	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	ldr r1,=acierto1
	mov r2,#11			@ La fila 11 es donde está la @ de la lombriz 2.
	mov r3,#70			@ El espacio 70 es donde está la @ de la lombriz 2.
	bl impacto 			@ Detectar colision con lombriz.

	@--- Turno de P2.

	ldr r1,=mensajeturno2
	mov r2,#longmsj2
	bl output

	bl turno_p2

	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	ldr r1,=acierto2
	mov r2,#20			@ La fila 21 es donde está la @ de la lombriz 1.
	mov r3,#21			@ El espacio 21 es donde está la @ de la lombriz 1.
	bl impacto 			@ Detectar colision con lombriz.
	
	
@Etapa 2
	
	ldr r1,=vida2
	mov r2,#longvida2
	bl output

	@--- Turno de P1 ---
	
	ldr r1,=mensajeturno1
	mov r2,#longmsj1
	bl output

	bl turno_p1
	
	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	ldr r1,=acierto1
	mov r2,#11			@ La fila 11 es donde está la @ de la lombriz 2.
	mov r3,#70			@ El espacio 70 es donde está la @ de la lombriz 2.
	bl impacto 			@ Detectar colision con lombriz.

	@--- Turno de P2.

	ldr r1,=mensajeturno2
	mov r2,#longmsj2
	bl output

	bl turno_p2

	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	ldr r1,=acierto2
	mov r2,#20			@ La fila 21 es donde está la @ de la lombriz 1.
	mov r3,#21			@ El espacio 21 es donde está la @ de la lombriz 1.
	bl impacto 			@ Detectar colision con lombriz.


@Etapa 3	

	@--- Turno de P1 ---
	
	ldr r1,=mensajeturno1
	mov r2,#longmsj1
	bl output

	ldr r1,=vida3
	mov r2,#longvida3
	bl output

	bl turno_p1
	
	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	ldr r1,=acierto1
	mov r2,#11			@ La fila 11 es donde está la @ de la lombriz 2.
	mov r3,#70			@ El espacio 70 es donde está la @ de la lombriz 2.
	bl impacto 			@ Detectar colision con lombriz.

	@--- Turno de P2.

	ldr r1,=mensajeturno2
	mov r2,#longmsj2
	bl output

	bl turno_p2

	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	ldr r1,=acierto2
	mov r2,#20			@ La fila 21 es donde está la @ de la lombriz 1.
	mov r3,#21			@ El espacio 21 es donde está la @ de la lombriz 1.
	bl impacto 			@ Detectar colision con lombriz.


@Etapa 4

	@--- Turno de P1 ---
	
	ldr r1,=mensajeturno1
	mov r2,#longmsj1
	bl output

	ldr r1,=vida4
	mov r2,#longvida4
	bl output

	bl turno_p1
	
	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	ldr r1,=acierto1
	mov r2,#11			@ La fila 11 es donde está la @ de la lombriz 2.
	mov r3,#70			@ El espacio 70 es donde está la @ de la lombriz 2.
	bl impacto 			@ Detectar colision con lombriz.

	@--- Turno de P2.

	ldr r1,=mensajeturno2
	mov r2,#longmsj2
	bl output

	bl turno_p2

	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	ldr r1,=acierto2
	mov r2,#20			@ La fila 21 es donde está la @ de la lombriz 1.
	mov r3,#21			@ El espacio 21 es donde está la @ de la lombriz 1.
	bl impacto 			@ Detectar colision con lombriz.


@Etapa 5

	@--- Turno de P1 ---
	
	ldr r1,=mensajeturno1
	mov r2,#longmsj1
	bl output

	ldr r1,=vida5
	mov r2,#longvida5
	bl output

	bl turno_p1
	
	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	ldr r1,=acierto1
	mov r2,#11			@ La fila 11 es donde está la @ de la lombriz 2.
	mov r3,#70			@ El espacio 70 es donde está la @ de la lombriz 2.
	bl impacto 			@ Detectar colision con lombriz.

	@--- Turno de P2.

	ldr r1,=mensajeturno2
	mov r2,#longmsj2
	bl output

	bl turno_p2

	ldr r0,=mapa		@ Cargamos la dirección de memoria del mapa.
	ldr r1,=acierto2
	mov r2,#20			@ La fila 21 es donde está la @ de la lombriz 1.
	mov r3,#21			@ El espacio 21 es donde está la @ de la lombriz 1.
	bl impacto 			@ Detectar colision con lombriz.


	@--- Fin de juego ---- 


fin:
	mov r7,#1
	swi 0
