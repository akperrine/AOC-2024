const std = @import("std");

pub fn part_one(in_stream: std.io.AnyReader) !void {
    var list_1 = std.ArrayList(i32).init(std.heap.page_allocator);
    var list_2 = std.ArrayList(i32).init(std.heap.page_allocator);
    defer list_1.deinit();
    defer list_2.deinit();

    try read_stream_to_lists(in_stream, &list_1, &list_2);

    std.mem.sort(i32, list_1.items, {}, std.sort.asc(i32));
    std.mem.sort(i32, list_2.items, {}, std.sort.asc(i32));

    var total: u32 = 0;
    for (list_1.items, 0..) |_, i| {
        total += @abs(list_1.items[i] - list_2.items[i]);
        std.debug.print("total in mid: {}, {}\n", .{ list_1.items[i], list_2.items[i] });
    }
    std.debug.print("total: {}\n", .{total});
}

fn read_stream_to_lists(stream: std.io.AnyReader, list_1: *std.ArrayList(i32), list_2: *std.ArrayList(i32)) !void {
    std.debug.print("\n", .{});

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
                try list_2.append(num);
            }
            i += 1;
        }
    }

    std.debug.print("Length of list 1: {}\n", .{list_1.items.len});
    std.debug.print("index of list 1: {}\n", .{list_1.items[0]});
    std.debug.print("Length of list 2: {}\n", .{list_2.items.len});
    std.debug.print("index of list 2: {}\n", .{list_2.items[0]});
}
