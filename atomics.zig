const std = @import("std");
const AtomicInt = std.atomic.Atomic(u32);

fn updateData(data : *AtomicInt) void {
	var i : usize = 0;
	while(i < 1000) : (i +=1 ){
		_ = data.fetchAdd(1, .Release);
	}
}

test "interview me 😁"{
	var threads: [50]std.Thread = undefined;
	var data = AtomicInt.init(0);

	for(&threads) |*thread| {
		thread.* = try std.Thread.spawn(.{}, updateData, .{&data});
	}

	for(threads) |thread| {
		thread.join();
	}

	try std.testing.expect(data.loadUnchecked() == 50_000);
}