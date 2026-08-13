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

    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    const scratch = try allocator.alloc(bool, @intCast(GRID_WIDTH * GRID_HEIGHT));
    defer allocator.free(scratch);

    place_initial_pattern(&framebuffer);

    var time_since_step: f32 = 0;

    while (!rl.WindowShouldClose()) {
        time_since_step += rl.GetFrameTime();
        if (time_since_step >= STEP_DELAY) {
            time_since_step = 0;
            life.step(&framebuffer, WRAP_EDGES, scratch);
        }

        framebuffer.swap();
    }
}

fn place_initial_pattern(framebuffer: *fb.Framebuffer) void {
    const c = life.ALIVE_COLOR;

    org.place_block(framebuffer, 5, 5, c);
    org.place_beehive(framebuffer, 12, 5, c);
    org.place_boat(framebuffer, 20, 5, c);

    org.place_blinker(framebuffer, 5, 20, c);
    org.place_toad(framebuffer, 15, 20, c);
    org.place_beacon(framebuffer, 25, 20, c);
    org.place_pulsar(framebuffer, 40, 15, c);

    org.place_glider(framebuffer, 5, 40, c);
    org.place_lwss(framebuffer, 20, 60, c);

    org.place_gosper_gun(framebuffer, 70, 10, c);
}
