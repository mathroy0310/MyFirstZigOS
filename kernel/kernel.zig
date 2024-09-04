// kernel/kernel.zig
const std = @import("std");

// Pointeur vers le buffer de la mémoire vidéo
var terminal_buffer: [*]volatile u16 = @ptrFromInt(0xB8000);

// Fonction principale du kernel
export fn kernel_main() void {
    // Effacer l'écran
    for (0..25) |y| {
        for (0..80) |x| {
            const index = y * 80 + x;
            terminal_buffer[index] = @as(u16, ' ') | (@as(u16, 0x00) << 8);
        }
    }

    // Afficher un message
    const msg = "Hello, World from Zig Kernel!";
    var index: usize = 0;

    for (msg) |c| {
        terminal_buffer[index] = @as(u16, c) | (@as(u16, 0x0F) << 8);
        index += 1;
    }
}