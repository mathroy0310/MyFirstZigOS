// kernel/boot.zig
const std = @import("std");

// Constants pour l'en-tête multiboot
pub const ALIGN = 1 << 0;
pub const MEMINFO = 1 << 1;
pub const FLAGS = ALIGN | MEMINFO;
pub const MAGIC = 0x1BADB002;
pub const CHECKSUM = -(MAGIC + FLAGS);

// En-tête multiboot
export var multiboot_header align(4) linksection(".multiboot") = [_]i32{ MAGIC, FLAGS, CHECKSUM };

// Point d'entrée
export fn _start() callconv(.Naked) noreturn {
    @setRuntimeSafety(false);
    asm volatile (
        \\call kernel_main
        \\hlt
    );
    unreachable;
}