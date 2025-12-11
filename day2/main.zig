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
            if ((digits % 2) == 0) {
                const first_half = num / @as(u64, std.math.pow(u64, 10, digits / 2));
                const second_half = num % @as(u64, std.math.pow(u64, 10, digits / 2));

                if (first_half == second_half) {
                    result += @as(u64, num);
                }
            }
            // std.debug.print("Number: {}, Digits: {}\n", .{ num, digits });
        }
        std.debug.print("Start: {}, End: {}\n", .{ start, end });
    }
    std.debug.print("Part 1 Result: {}\n", .{result});
    // std.debug.print("Part 2 Result: {}\n", .{result2});
}
