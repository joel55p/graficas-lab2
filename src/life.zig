const std = @import("std");
const rl = @import("raylib_c.zig").raylib;
const fb = @import("framebuffer.zig");

pub const ALIVE_COLOR = rl.Color{ .r = 255, .g = 255, .b = 255, .a = 255 };
pub const DEAD_COLOR = rl.Color{ .r = 0, .g = 0, .b = 0, .a = 255 };

/// Como el juego no guarda un grid aparte, "viva" se decide comparando el color contra el color de fondo. Cualquier color que no sea el
/// de fondo cuenta como viva.
pub fn is_alive(color: rl.Color, background: rl.Color) bool {
    return !(color.r == background.r and color.g == background.g and color.b == background.b);
}

/// en las paredes `wrap = true` hace un "loop" donde el vecino del otro lado de la pantalla cuenta. `wrap = false` trata todo lo que esta fuera del
/// framebuffer como muerto
pub fn count_neighbors(framebuffer: *fb.Framebuffer, x: i32, y: i32, wrap: bool) u8 {
    var count: u8 = 0;
    var dy: i32 = -1;
    while (dy <= 1) : (dy += 1) {
        var dx: i32 = -1;
        while (dx <= 1) : (dx += 1) {
            if (dx == 0 and dy == 0) continue;

            var nx = x + dx;
            var ny = y + dy;

            if (wrap) {
                nx = @mod(nx, framebuffer.width);
                ny = @mod(ny, framebuffer.height);
            }

            const neighbor_color = framebuffer.get_color(nx, ny);
            if (is_alive(neighbor_color, framebuffer.background_color)) count += 1;
        }
    }
    return count;
}

/// Aplica las 4 reglas a una celda.
pub fn next_state(alive: bool, neighbors: u8) bool {
    if (alive) {
        return neighbors == 2 or neighbors == 3;
    } else {
        return neighbors == 3;
    }
}

/// Un paso completo del juego es que  dos pasadas sobre la cuadricula para que ninguna celda  como que "vea" el futuro de 
/// las otras en el mismo turno.  ahora bien 'scratch' debe tener al menos width*height bools con el llamador para no reservar memoria cada frame.
pub fn step(framebuffer: *fb.Framebuffer, wrap: bool, scratch: []bool) void {
    const w = framebuffer.width;
    const h = framebuffer.height;

    var y: i32 = 0;
    while (y < h) : (y += 1) {
        var x: i32 = 0;
        while (x < w) : (x += 1) {
            const idx: usize = @intCast(y * w + x);
            const current = is_alive(framebuffer.get_color(x, y), framebuffer.background_color);
            const neighbors = count_neighbors(framebuffer, x, y, wrap);
            scratch[idx] = next_state(current, neighbors);
        }
    }

    y = 0;
    while (y < h) : (y += 1) {
        var x: i32 = 0;
        while (x < w) : (x += 1) {
            const idx: usize = @intCast(y * w + x);
            framebuffer.point(x, y, if (scratch[idx]) ALIVE_COLOR else DEAD_COLOR);
        }
    }
}
