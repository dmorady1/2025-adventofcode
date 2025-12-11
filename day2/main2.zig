const std = @import("std");
const fs = std.fs;

fn sliceToNumber(digits: []const u8) u64 {
    var acc: u64 = 0;
    for (digits) |d| {
        acc = acc * 10 + (d - '0');
    }
    return acc;
}

fn digitCount(n: u64) u8 {
    var count: u8 = 0;
    var num = if (n == 0) 1 else n;
    while (num > 0) : (num /= 10) {
        count += 1;
    }
    return count;
}

fn usizeToString(allocator: std.mem.Allocator, value: usize) ![]u8 {
    return std.fmt.allocPrint(allocator, "{}", .{value});
}

pub fn main() !void {
    const allocator = std.heap.page_allocator;

    const contents = try std.fs.cwd().readFileAlloc(allocator, "input.txt", 1 << 30 // 1GB
    );
    defer allocator.free(contents);

    var it = std.mem.splitScalar(u8, contents, ',');

    var result: u64 = 0;
    while (it.next()) |line| {
        // const number: u32 = sliceToNumber(line[1..]);

        var it_nums = std.mem.splitScalar(u8, line, '-');
        const start_u8 = it_nums.next().?;
        const end_u8 = it_nums.next().?;
        const start = sliceToNumber(start_u8);
        const end = sliceToNumber(end_u8);

        for (start..end + 1) |num| {
            const digits = digitCount(@as(u64, num));

            const num_str = try usizeToString(allocator, num);
            for (2..digits + 1) |i| {
                // std.debug.print("Checking number: {}, repeating: {}\n", .{ num, i });
                // if (i == half_size + 2) {
                //     break;
                // }
                // if (i == half_size + 1) {
                //     i = digits;
                // }
                if (digits % i == 0) {
                    const pattern_size = digits / i;
                    const pattern = num_str[0..pattern_size];
                    // std.debug.print("Checking number: {}, pattern size: {}, pattern: {s}\n", .{ num, pattern_size, pattern });
                    var matched = true;
                    for (1..i) |j| {
                        const start_index = j * pattern_size;
                        const end_index = start_index + pattern_size;
                        if (!std.mem.eql(u8, pattern, num_str[start_index..end_index])) {
                            matched = false;
                            break;
                        }
                    }
                    if (matched) {
                        result += @as(u64, num);
                        // std.debug.print("Match at {}\n", .{num});
                        break;
                    }
                }

                // std.debug.print("Number: {}, Digits: {}\n", .{ num, digits });
            }
            // std.debug.print("Start: {}, End: {}\n", .{ start, end });
        }
        std.debug.print("Part 1 Result: {}\n", .{result});
        // std.debug.print("Part 2 Result: {}\n", .{result2});
    }
}
