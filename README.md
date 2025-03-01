# 🐛 Worms Armageddon en Assembly (ARM)  

Este proyecto es una adaptación del clásico **Worms Armageddon**, desarrollado en **ARM Assembly** y ejecutado en **PuTTY**. El objetivo es que dos equipos de gusanos compitan disparando proyectiles en un mapa hasta eliminar al equipo contrario.  

## 🎮 Mecánicas del Juego  

1. **Dos gusanos en un mapa** representados con `@####`, donde `@` es la cabeza.  
2. **Disparos con trayectoria lineal**, definidos por el usuario ingresando una pendiente.  
3. **Turnos alternos:** Cada jugador tiene **5 intentos** para acertar.  
4. **Colisión e impacto:** Si un gusano es alcanzado, su cabeza (`@`) cambia a `X`.  
5. **Fin del juego:** Al final de los turnos o cuando un gusano es eliminado, aparece **"Game Over"** y se actualiza la pantalla.  

## 🔧 Implementación en Assembly  

### 🗺️ Representación del mapa  
El mapa se almacena en la sección `.data` usando el formato `.asciz`. Para imprimirlo en pantalla, se usa la función `output`, que realiza una **syscall** (`mov r7, #4`).  

```assembly
ldr r0,=mapa    @ Cargar la dirección de memoria del mapa
mov r7, #4      @ Syscall para escribir en pantalla
swi 0           @ Interrupción del sistema
```

📌 **Explicación:**  
- `r7, #4` → Indica al sistema que queremos escribir.  
- `r0` → Contiene la dirección del mapa a imprimir.  
- `swi 0` → Llama al kernel para ejecutar la operación.  

### ⌨️ Entrada del usuario  
Para leer valores ingresados por el usuario, utilizamos una syscall `#3`:  

```assembly
mov r7, #3      @ Syscall para leer entrada del usuario
mov r0, #0      @ Leer desde la entrada estándar
mov r2, #2      @ Cantidad de caracteres a leer
ldr r1, =buffer @ Almacenar el valor ingresado en buffer
swi 0
```

📌 **Detalles:**  
- `r7, #3` → Indica una **lectura de datos**.  
- `r0, #0` → Se lee desde la **entrada estándar (teclado)**.  
- `r2, #2` → Se lee un máximo de **2 caracteres**.  
- `r1` → Dirección donde se almacena el dato ingresado.  

### 🎯 Detección de impacto  
Para verificar si un disparo acierta a un gusano, se usa la función `impacto`:  

```assembly
ldr r0,=mapa   @ Cargar la dirección del mapa
ldr r1,=acierto1
mov r2,#11     @ Fila donde está la lombriz 2
mov r3,#70     @ Columna donde está la lombriz 2
bl impacto     @ Llamada a la función impacto
```

📌 **Flujo del disparo:**  
1. Se carga el mapa (`r0`).  
2. Se almacena la posición de impacto (`r1`, `r2`, `r3`).  
3. Se llama a la función `impacto` para verificar la colisión.  

### 🔄 Turnos y Juego  
El juego se desarrolla por turnos alternos, mostrando mensajes en pantalla y permitiendo que los jugadores ingresen la pendiente del disparo.  

```assembly
ldr r1,=mensajeturno2  @ Mensaje para el turno del Jugador 2
mov r2,#longmsj2       
bl output               @ Mostrar mensaje

bl turno_p2             @ Llamar a la función del turno de P2
```

📌 **Detalles:**  
- Se muestra un mensaje indicando el **turno actual**.  
- Se llama a la función `turno_p2` para procesar la jugada del Jugador 2.  

---

## 🚧 Dificultades encontradas  

✅ **Falta de documentación en ARM Assembly** → La mayoría de la información disponible es para x86.  
✅ **Errores al modificar el mapa** → Al ingresar nuevos caracteres, surgían errores de segmentación.  
✅ **Estructura del código** → Al integrar todas las funcionalidades, mantener un flujo lógico fue complicado.  
✅ **Optimización** → Para mantener la jugabilidad en turnos, se duplicó código en lugar de reutilizar funciones.  

## 📌 Conclusiones  

Trabajar en **Assembly** nos permitió entender el funcionamiento de bajo nivel de un programa y la importancia de las **syscalls** en la interacción con el sistema operativo. Si bien es un lenguaje complejo, nos brindó una nueva perspectiva sobre cómo los lenguajes de alto nivel abstraen estos procesos.  

---

## 🛠️ Cómo ejecutar el código  

Si quieres probar el juego en tu entorno:  

1️⃣ **Compila el código:**  
```bash
as -o gusanos.o gusanos.s
ld -o gusanos gusanos.o
```
2️⃣ **Ejecuta el programa:**  
```bash
./gusanos
```
3️⃣ **Abre PuTTY para jugar** en un entorno Linux.  

---


