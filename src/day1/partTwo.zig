const std = @import("std");

pub fn part_two(in_stream: std.io.AnyReader) !void {
    var list_1 = std.ArrayList(i32).init(std.heap.page_allocator);
    var set_2 = std.AutoHashMap(i32, i32).init(std.heap.page_allocator);
    defer list_1.deinit();
    defer set_2.deinit();

    try read_stream_to_lists(in_stream, &list_1, &set_2);

    var total: i32 = 0;

    for (list_1.items) |val| {
        const set_occurances = set_2.get(val);
        if (set_occurances) |occurance| {
            total += (val * occurance);
            std.debug.print("val {}, occ {}\n", .{ val, occurance });
            std.debug.print("total in mid: {}\n", .{total});
        }
    }

    std.debug.print("total: {}\n", .{total});
}

fn read_stream_to_lists(stream: std.io.AnyReader, list_1: *std.ArrayList(i32), set_2: *std.AutoHashMap(i32, i32)) !void {
    var buf: [1024]u8 = undefined;

    while (try stream.readUntilDelimiterOrEof(&buf, '\n')) |line| {
        var line_break = std.mem.tokenizeSequence(u8, line, "   ");

        var i: i32 = 0;
        while (line_break.next()) |val| {
            var num: i32 = 0;
            std.debug.print("{s}\n", .{val});
            num = try std.fmt.parseInt(i32, val, 10);
            if (i == 0) {
                try list_1.append(num);
            }
            if (i == 1) {
                const set_map = try set_2.getOrPut(num);
                if (set_map.found_existing) {
                    set_map.value_ptr.* += 1;
                } else {
                    set_map.value_ptr.* = 1;
                }
            }
            i += 1;
        }
    }
}
