const rl = @import("raylib_c.zig").raylib;
const fb = @import("framebuffer.zig");

fn stamp(framebuffer: *fb.Framebuffer, ox: i32, oy: i32, color: rl.Color, cells: []const [2]i32) void {
    for (cells) |c| {
        framebuffer.point(ox + c[0], oy + c[1], color);
    }
}

//  formas

pub fn place_block(framebuffer: *fb.Framebuffer, ox: i32, oy: i32, color: rl.Color) void {
    stamp(framebuffer, ox, oy, color, &.{
        .{ 0, 0 }, .{ 1, 0 },
        .{ 0, 1 }, .{ 1, 1 },
    });
}

pub fn place_beehive(framebuffer: *fb.Framebuffer, ox: i32, oy: i32, color: rl.Color) void {
    stamp(framebuffer, ox, oy, color, &.{
        .{ 1, 0 }, .{ 2, 0 },
        .{ 0, 1 }, .{ 3, 1 },
        .{ 1, 2 }, .{ 2, 2 },
    });
}

pub fn place_boat(framebuffer: *fb.Framebuffer, ox: i32, oy: i32, color: rl.Color) void {
    stamp(framebuffer, ox, oy, color, &.{
        .{ 0, 0 }, .{ 1, 0 },
        .{ 0, 1 }, .{ 2, 1 },
        .{ 1, 2 },
    });
}

//  osciladores

pub fn place_blinker(framebuffer: *fb.Framebuffer, ox: i32, oy: i32, color: rl.Color) void {
    stamp(framebuffer, ox, oy, color, &.{
        .{ 0, 0 }, .{ 1, 0 }, .{ 2, 0 },
    });
}

pub fn place_toad(framebuffer: *fb.Framebuffer, ox: i32, oy: i32, color: rl.Color) void {
    stamp(framebuffer, ox, oy, color, &.{
        .{ 1, 0 }, .{ 2, 0 }, .{ 3, 0 },
        .{ 0, 1 }, .{ 1, 1 }, .{ 2, 1 },
    });
}

pub fn place_beacon(framebuffer: *fb.Framebuffer, ox: i32, oy: i32, color: rl.Color) void {
    stamp(framebuffer, ox, oy, color, &.{
        .{ 0, 0 }, .{ 1, 0 },
        .{ 0, 1 },
        .{ 3, 2 },
        .{ 2, 3 }, .{ 3, 3 },
    });
}

pub fn place_pulsar(framebuffer: *fb.Framebuffer, ox: i32, oy: i32, color: rl.Color) void {
    const arm = [_][2]i32{
        .{ 2, 0 }, .{ 3, 0 }, .{ 4, 0 },
        .{ 0, 2 }, .{ 0, 3 }, .{ 0, 4 },
        .{ 5, 2 }, .{ 5, 3 }, .{ 5, 4 },
        .{ 2, 5 }, .{ 3, 5 }, .{ 4, 5 },
    };
    for (arm) |c| {
        const dx = c[0];
        const dy = c[1];
        stamp(framebuffer, ox, oy, color, &.{.{ dx, dy }});
        stamp(framebuffer, ox, oy, color, &.{.{ -dx, dy }});
        stamp(framebuffer, ox, oy, color, &.{.{ dx, -dy }});
        stamp(framebuffer, ox, oy, color, &.{.{ -dx, -dy }});
    }
}

//  naves 

pub fn place_glider(framebuffer: *fb.Framebuffer, ox: i32, oy: i32, color: rl.Color) void {
    stamp(framebuffer, ox, oy, color, &.{
        .{ 1, 0 },
        .{ 2, 1 },
        .{ 0, 2 }, .{ 1, 2 }, .{ 2, 2 },
    });
}

pub fn place_lwss(framebuffer: *fb.Framebuffer, ox: i32, oy: i32, color: rl.Color) void {
    stamp(framebuffer, ox, oy, color, &.{
        .{ 1, 0 }, .{ 4, 0 },
        .{ 0, 1 },
        .{ 0, 2 }, .{ 4, 2 },
        .{ 0, 3 }, .{ 1, 3 }, .{ 2, 3 }, .{ 3, 3 },
    });
}

/// Bonus que dispara un glider nuevo cada 30 turnos
pub fn place_gosper_gun(framebuffer: *fb.Framebuffer, ox: i32, oy: i32, color: rl.Color) void {
    stamp(framebuffer, ox, oy, color, &.{
        .{ 24, 0 },
        .{ 22, 1 }, .{ 24, 1 },
        .{ 12, 2 }, .{ 13, 2 }, .{ 20, 2 }, .{ 21, 2 }, .{ 34, 2 }, .{ 35, 2 },
        .{ 11, 3 }, .{ 15, 3 }, .{ 20, 3 }, .{ 21, 3 }, .{ 34, 3 }, .{ 35, 3 },
        .{ 0, 4 },  .{ 1, 4 },  .{ 10, 4 }, .{ 16, 4 }, .{ 20, 4 }, .{ 21, 4 },
        .{ 0, 5 },  .{ 1, 5 },  .{ 10, 5 }, .{ 14, 5 }, .{ 16, 5 }, .{ 17, 5 }, .{ 22, 5 }, .{ 24, 5 },
        .{ 10, 6 }, .{ 16, 6 }, .{ 24, 6 },
        .{ 11, 7 }, .{ 15, 7 },
        .{ 12, 8 }, .{ 13, 8 },
    });
}
