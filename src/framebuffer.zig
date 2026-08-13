const std = @import("std");
const rl = @import("raylib_c.zig").raylib;

/// El framebuffer del juego. (width x height) es la resolucion de la cuadricula del game (una celda = un pixel de `image`).
///Ahora bien  al dibujar en pantalla, esa imagen chiquita se escala hasta llenar una ventana pues  mas grande (window_width x window_height), usando filtro POINT para que cada celda se vea como un bloque.
pub const Framebuffer = struct {
    width: i32,
    height: i32,
    window_width: i32,
    window_height: i32,
    image: rl.Image,
    texture: ?rl.Texture2D,
    background_color: rl.Color,

    pub fn init(width: i32, height: i32, window_width: i32, window_height: i32, background_color: rl.Color) Framebuffer {
        return Framebuffer{
            .width = width,
            .height = height,
            .window_width = window_width,
            .window_height = window_height,
            .image = rl.GenImageColor(width, height, background_color),
            .texture = null,
            .background_color = background_color,
        };
    }

    /// La unica funcion para escribir en el framebuffer.  que pinta la celda
    /// (x, y) del color dado. y las coordenas fuera de la cela se ignoran
    pub fn point(self: *Framebuffer, x: i32, y: i32, color: rl.Color) void {
        if (x < 0 or y < 0 or x >= self.width or y >= self.height) return;
        rl.ImageDrawPixel(&self.image, x, y, color);
    }

    /// Regresa el color actual de la celda (x, y). Fuera de rango se considera "background_color" 
    /// asi el algoritmo del juego puede tratar los bordes como muertos sin tener que estar validando limites en cada llamada.
    pub fn get_color(self: *Framebuffer, x: i32, y: i32) rl.Color {
        if (x < 0 or y < 0 or x >= self.width or y >= self.height) return self.background_color;
        return rl.GetImageColor(self.image, x, y);
    }

    /// Ahora bien disponible por si se necesita, pero el loop del juego no la llama, ya que  estado del juego vive en los pixels del framebuffer de
    /// un frame a otro, no en una estructura aparte.
    pub fn clear(self: *Framebuffer) void {
        rl.ImageClearBackground(&self.image, self.background_color);
    }

    pub fn swap(self: *Framebuffer) void {
        rl.BeginDrawing();
        defer rl.EndDrawing();
        rl.ClearBackground(rl.BLACK);

        if (self.texture) |t| rl.UnloadTexture(t);
        self.texture = rl.LoadTextureFromImage(self.image);
        rl.SetTextureFilter(self.texture.?, rl.TEXTURE_FILTER_POINT);

        const src = rl.Rectangle{
            .x = 0,
            .y = 0,
            .width = @floatFromInt(self.width),
            .height = @floatFromInt(self.height),
        };
        const dst = rl.Rectangle{
            .x = 0,
            .y = 0,
            .width = @floatFromInt(self.window_width),
            .height = @floatFromInt(self.window_height),
        };
        rl.DrawTexturePro(self.texture.?, src, dst, rl.Vector2{ .x = 0, .y = 0 }, 0, rl.WHITE);
    }

    pub fn export_image(self: *Framebuffer, path: [*c]const u8) void {
        _ = rl.ExportImage(self.image, path);
    }
};
