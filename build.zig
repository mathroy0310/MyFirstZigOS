const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{ .default_target = .{
        .cpu_arch = .x86,
        .os_tag = .freestanding,
    } });
    const optimize = b.standardOptimizeOption(.{});

    const boot = b.addExecutable(.{
        .name = "MyFirstZigOS",
        .root_source_file = b.path("kernel/boot.zig"),
        .target = target,
        .optimize = optimize,
    });

    const kernel = b.addObject(.{
        .name = "MyFirstZigKernel",
        .root_source_file = b.path("kernel/kernel.zig"),
        .target = target,
        .optimize = optimize,
        .code_model = .kernel,
    });

    boot.setLinkerScriptPath(b.path("kernel/linker.ld"));
    boot.addObject(kernel);
    b.installArtifact(boot);

    const run_cmd = b.addSystemCommand(&[_][]const u8{
        "qemu-system-i386",
        "-kernel",
        "./zig-out/bin/MyFirstZigOS",
    });
    run_cmd.step.dependOn(b.getInstallStep());

    const run_step = b.step("run", "Run the kernel in QEMU");
    run_step.dependOn(&run_cmd.step);
}
