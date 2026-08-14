# Conway's Game of Life

Implementación de Conway's Game of Life en Zig usando [raylib-zig](https://github.com/raylib-zig/raylib-zig)

## Demo

![Game of Life corriendo](docs/demo.gif)

## Cómo funciona

El estado del juego vive directamente en los píxeles del framebuffer, no en una estructura de datos aparte:

- **`point(x, y, color)`** es la unica funcion que escribe en el framebuffer.
- **`get_color(x, y)`** lee el estado actual de una celda (fuera de rango es "muerta").
- El framebuffer nunca se limpia entre frames: `life.step()` recalcula y repinta cada celda con `point`/`get_color`, en dos pasadas (primero lee todo el estado actual, luego escribe el nuevo) para que ninguna celda "vea" el futuro de sus vecinas dentro del mismo turno.
- La resolución interna del framebuffer es la cuadrícula del juego (140x110 celdas); al dibujarse en pantalla se escala a una ventana más grande con filtro POINT para que se vea en bloques nítidos.

## Reglas implementadas

1. Una celula viva con menos de 2 vecinos vivos, muere (underpopulation).
2. Una celula viva con 2 o 3 vecinos vivos, sobrevive.
3. Una celula viva con más de 3 vecinos vivos, muere (overpopulation).
4. Una celula muerta con exactamente 3 vecinos vivos, nace (reproduction).

## Orillas

Configurable en `src/main.zig` con `WRAP_EDGES`:
- `true` (default): bordes tipo "loop" como pacman jaj que  una celula que sale por un lado reaparece del otro.
- `false`: todo lo que esta fuera del framebuffer se trata como muerto.

## Patron inicial

Definido en `place_initial_pattern` (`src/main.zig`), con una función por organismo en `src/organisms.zig`:

- **Still lifes:** block, beehive, boat.
- **Osciladores:** blinker, toad, beacon, pulsar.
- **Spaceships:** glider, lightweight spaceship (LWSS).
- **Gosper glider gun**, disparando gliders nuevos cada 30 generaciones.

## Controles

| Tecla | Acción |
|---|---|
| SPACE | Pausar / reanudar |
| -> (flecha derecha) | Avanzar un frame (solo si esta en pausado) |
| R | Reiniciar al patron inicial |

## Cómo correrlo

```bash
git clone https://github.com/joel55p/graficas-lab2.git
zig build run
```

Requiere Zig 0.16+