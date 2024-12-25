const std = @import("std");
const day_one_part_one = @import("./day1/partOne.zig");
const day_one_part_two = @import("./day1/partTwo.zig");

pub fn main() !void {
    const Errors = error{InvalidArgument};
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};

    const allocator = gpa.allocator();
    defer _ = gpa.deinit();

    const args = try std.process.argsAlloc(allocator);
    defer std.process.argsFree(allocator, args);

    if (args.len != 2) {
        std.debug.print("Required test input missing from args\n", .{});
        return Errors.InvalidArgument;
    }

    const file_path = args[1];
    std.debug.print("{s} file", .{file_path});
    var file = try std.fs.cwd().openFile(file_path, .{});
    defer file.close();

    var buf_reader = std.io.bufferedReader(file.reader());
    const in_stream = buf_reader.reader().any();

    // try day_one_part_one.part_one(in_stream);
    try day_one_part_two.part_two(in_stream);
}
