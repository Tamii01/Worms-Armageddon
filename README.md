# Worms-Armageddon

Este proyecto es una adaptación en ARM Assembly del clásico juego Worms Armageddon. En nuestra versión, dos gusanos se enfrentan en un mapa, disparando proyectiles con trayectorias lineales, en un sistema de turnos.

## Modo de Juego
Dos gusanos representados como @####, donde @ es la cabeza.
El disparo sigue una trayectoria lineal determinada por la pendiente elegida por el jugador.
Cada jugador tiene 5 intentos por turno.
Si un gusano es alcanzado, su cabeza cambia a X para indicar su eliminación.
Al finalizar el juego, se muestra "Game Over" y se actualiza la pantalla.
El desarrollo se realizó desglosando los requisitos en tareas más pequeñas, priorizando aspectos clave como la representación del mapa y la implementación de los disparos.

## Implementación en ARM Assembly

1. Representación del Mapa y Salida en Pantalla
Para mostrar el mapa en pantalla, utilizamos la sección .data con el formato .asciz para almacenar la información. Implementamos una función output basada en una syscall (#4 en r7), que permite escribir en pantalla:

  r7 = 4 → Indica que el sistema debe ejecutar una operación de escritura.
  r0 = 1 → Define la salida estándar (pantalla).
  r1 = Dirección del mapa → Carga la referencia en memoria.
  r2 = Longitud del mapa → Define la cantidad de caracteres a imprimir.
  Este método se basa en la Tabla de llamadas al sistema de Linux.

2. Entrada de Datos (Lectura del Usuario)
Para capturar la pendiente elegida por el usuario, implementamos una función input_x1, utilizando una syscall (#3 en r7) para leer datos del teclado:

  r0 = 0 → Indica entrada estándar (teclado).
  r1 = Dirección en memoria → Guarda el valor ingresado.
  r2 = 2 → Cantidad de caracteres a capturar.
  Esta función se reutiliza en input_p1 para gestionar la entrada del segundo jugador.

3. Movimiento del Disparo y Detección de Impactos
La función disparo gestiona el movimiento del proyectil:

  Reduce en una fila y avanza una columna para simular la trayectoria.
  Se imprime * en cada posición recorrida.
  Para insertar el asterisco en el mapa, usamos ins_dot1, que:

  Carga * en r2.
  Obtiene la dirección del mapa en r0.
  Inserta el carácter en la posición correspondiente.

4. Verificación de Trayectoria y Colisiones
Una de las mayores dificultades fue gestionar la trayectoria dinámica del disparo. Para ello, implementamos:

while → Mantiene el disparo en movimiento hasta alcanzar un límite.
Función de impacto (if) → Detecta si el proyectil golpeó a un gusano.
Función de colisión → Controla si el disparo sale del mapa o choca con otro objeto.
El while coordina la actualización del mapa, asegurando que los disparos avancen en la dirección correcta para cada jugador:

Jugador 1 → Disparo ascendente y hacia la derecha.
Jugador 2 → Disparo descendente y hacia la izquierda.

5. Gestión de Turnos
La función turno gestiona el flujo del juego:

Muestra mensajes indicando el turno del jugador.
Espera la entrada del usuario para definir la pendiente del disparo.
Cambia de turno tras cada intento.
Cada jugada se ejecuta en etapas definidas por el código, asegurando el correcto control de los intentos y la jugabilidad para dos jugadores.

## Dificultades Encontradas
Falta de documentación sobre ARM Assembly → La mayoría de los recursos estaban en inglés y basados en x86 o en equivalencias con C.
Errores de acceso a memoria → Al manipular el mapa con ciclos, en ocasiones intentábamos acceder a posiciones fuera de rango.
Integración de funciones → Combinar las funcionalidades desarrolladas por separado en un programa cohesivo fue un reto.
Duplicación de código → Para manejar dos jugadores, inicialmente duplicamos código, aunque era posible optimizarlo, lo que complicó la gestión de valores en memoria.

## Conclusiones
Trabajar en ARM Assembly resultó un desafío tanto técnico como conceptual.

- Fue necesario investigar múltiples fuentes y probar distintos enfoques para implementar correctamente las funciones requeridas.
- Aprendimos cómo funcionan las syscalls y la interacción directa con el sistema operativo a nivel de bajo nivel.
- Nos permitió comprender mejor el funcionamiento interno de un sistema, reforzando la importancia de la eficiencia y la organización en la programación.
- Este proyecto nos ayudó a valorar las ventajas de los lenguajes de alto nivel y a entender la base de la computación desde su núcleo más esencial.
