const std = @import("std");
const fs = std.fs;

fn sliceToNumber(digits: []const u8) i32 {
    var acc: i32 = 0;
    for (digits) |d| {
        acc = acc * 10 + (d - '0');
    }
    return acc;
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const contents = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 1 << 30 // 1GB
    );
    defer allocator.free(contents);

    var it = std.mem.splitScalar(u8, contents, '\n');

    var current_position: i32 = 50;
    var result: u32 = 0;

    var result2: u32 = 0;
    var steps_to_zero: i32 = 0;
    while (it.next()) |line| {
        const number: i32 = sliceToNumber(line[1..]);

        const char = line[0];
        if (char == 'L') {
            if (current_position == 0) {
                steps_to_zero = 100;
            } else {
                steps_to_zero = current_position;
            }

            current_position = @mod(current_position - number, 100);
        } else if (char == 'R') {
            if (current_position == 0) {
                steps_to_zero = 100;
            } else {
                steps_to_zero = 100 - current_position;
            }

            current_position = @mod(current_position + number, 100);
        }

        if (number >= steps_to_zero) {
            result2 += 1;
        }
        result2 += @abs(number - steps_to_zero) / 100;
        if (current_position == 0) {
            result += 1;
        }
    }
    std.debug.print("Part 1 Result: {}\n", .{result});
    std.debug.print("Part 2 Result: {}\n", .{result2});
}
