const std = @import("std");
const rl = @import("raylib_c.zig").raylib;
const fb = @import("framebuffer.zig");
const life = @import("life.zig");
const org = @import("organisms.zig");

const GRID_WIDTH = 140;
const GRID_HEIGHT = 110;

const CELL_SIZE = 7;
const WINDOW_WIDTH = GRID_WIDTH * CELL_SIZE;
const WINDOW_HEIGHT = GRID_HEIGHT * CELL_SIZE;

const WRAP_EDGES = true;
const STEP_DELAY: f32 = 0.08;

pub fn main() !void {
    rl.InitWindow(WINDOW_WIDTH, WINDOW_HEIGHT, "Conway's Game of Life");
    defer rl.CloseWindow();
    rl.SetTargetFPS(60);

    var framebuffer = fb.Framebuffer.init(GRID_WIDTH, GRID_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, life.DEAD_COLOR);

    var gpa = std.heap.DebugAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const scratch = try allocator.alloc(bool, @intCast(GRID_WIDTH * GRID_HEIGHT));
    defer allocator.free(scratch);

    place_initial_pattern(&framebuffer);

    var time_since_step: f32 = 0;
    // Empieza pausado: asi el primer frame que se ve es exactamente el
    // patron inicial, sin que ya hayan corrido generaciones de mas.
    var paused = true;

    while (!rl.WindowShouldClose()) {
        if (rl.IsKeyPressed(rl.KEY_SPACE)) paused = !paused;

        if (rl.IsKeyPressed(rl.KEY_R)) {
            framebuffer.clear();
            place_initial_pattern(&framebuffer);
            time_since_step = 0;
        }

        if (paused) {
            if (rl.IsKeyPressed(rl.KEY_RIGHT)) {
                life.step(&framebuffer, WRAP_EDGES, scratch);
            }
        } else {
            time_since_step += rl.GetFrameTime();
            if (time_since_step >= STEP_DELAY) {
                time_since_step = 0;
                life.step(&framebuffer, WRAP_EDGES, scratch);
            }
        }

        framebuffer.swap();
    }
}

fn place_initial_pattern(framebuffer: *fb.Framebuffer) void {
    const c = life.ALIVE_COLOR;

    org.place_block(framebuffer, 5, 5, c);
    org.place_beehive(framebuffer, 20, 5, c);
    org.place_boat(framebuffer, 40, 5, c);

    org.place_blinker(framebuffer, 5, 30, c);
    org.place_toad(framebuffer, 20, 30, c);
    org.place_beacon(framebuffer, 35, 30, c);
    org.place_pulsar(framebuffer, 65, 35, c);

    org.place_glider(framebuffer, 5, 60, c);
    org.place_lwss(framebuffer, 15, 90, c);

    org.place_gosper_gun(framebuffer, 90, 15, c);
}