const std = @import("std");

const smbus = @cImport(@cInclude("i2c/smbus.h"));
const ioctl = @cImport(@cInclude("sys/ioctl.h"));
const i2cdevice = @cImport(@cInclude("linux/i2c-dev.h"));
const string = @cImport(@cInclude("string.h"));

pub fn set_slave_addr(file: std.fs.File, addr: u8, force: bool) !void {
    var ret: c_int = 0;
    if (force) {
        ret = ioctl.ioctl(file.handle, i2cdevice.I2C_SLAVE_FORCE, addr);
    } else {
        ret = ioctl.ioctl(file.handle, i2cdevice.I2C_SLAVE, addr);
    }
    if (ret < 0) {
        std.debug.print("Error: {s}\n", .{string.strerror(-ret)});
        return error.IoError;
    }
}

pub fn i2c_write(file: std.fs.File, addr: u8, val: u8) !void {
    try set_slave_addr(file, addr, false);

    var ret = smbus.i2c_smbus_write_byte(file.handle, val);
    if (ret < 0) {
        std.debug.print("Error: {s}\n", .{string.strerror(-ret)});
        return error.IoError;
    }

    ret = smbus.i2c_smbus_read_byte(file.handle);
    if (ret < 0) {
        std.debug.print("Error: {s}\n", .{string.strerror(-ret)});
        return error.IoError;
    }

    if (ret != val) {
        std.debug.print("Error: read {x} from {x}, expected {x}\n", .{ ret, addr, val });
        return error.ReadBackError;
    }
}

pub fn i2c_write_cmd(file: std.fs.File, addr: u8, cmd: u8, val: u8) !void {
    try set_slave_addr(file, addr, false);

    var ret = smbus.i2c_smbus_write_byte_data(file.handle, cmd, val);
    if (ret < 0) {
        std.debug.print("Error: {s}\n", .{string.strerror(-ret)});
        return error.IoError;
    }

    ret = smbus.i2c_smbus_read_byte_data(file.handle, cmd);
    if (ret < 0) {
        std.debug.print("Error: {s}\n", .{string.strerror(-ret)});
        return error.IoError;
    }

    if (ret != val) {
        std.debug.print("Error: read {x} from {x}, expected {x}\n", .{ ret, addr, val });
        return error.ReadBackError;
    }
}

pub fn i2c_read_cmd(file: std.fs.File, addr: u8, cmd: u8) !u8 {
    try set_slave_addr(file, addr, false);

    var ret = smbus.i2c_smbus_read_byte_data(file.handle, cmd);
    if (ret < 0) {
        std.debug.print("Error: {s}\n", .{string.strerror(-ret)});
        return error.IoError;
    }

    return @as(u8, @intCast(ret));
}

pub fn i2c_read_bytes16(file: std.fs.File, addr: u8, cmd: u16, len: u16, buf: []u8) !void {
    try set_slave_addr(file, addr, false);

    var ret = smbus.i2c_smbus_write_byte_data(file.handle, @intCast((cmd & 0xFF00) >> 8), @intCast(cmd & 0x00FF));
    if (ret < 0) {
        std.debug.print("Error: {s}\n", .{string.strerror(-ret)});
        return error.WriteError;
    }
    var i: u16 = 0;
    while (i < len) {
        ret = smbus.i2c_smbus_read_byte(file.handle);
        if (ret < 0) {
            std.debug.print("Error: {s}\n", .{string.strerror(-ret)});
            return error.ReadError;
        }
        buf[i] = @intCast(ret);
        i = i+1;
    }
    if (i != len) {
        std.debug.print("Error: read {x} bytes from {x}, expected {x}\n", .{ ret, addr, len });
        return error.ReadError;
    }
}

pub fn i2c_write_bytes8(file: std.fs.File, addr: u8, cmd: u8, len: u8, buf: []u8) !void {
    try set_slave_addr(file, addr, false);

    var ret = smbus.i2c_smbus_write_block_data(file.handle, cmd, len, &buf[0]);
    if (ret < 0) {
        std.debug.print("Error: {s}\n", .{string.strerror(-ret)});
        return error.WriteError;
    }
    if (ret != len) {
        std.debug.print("Error: wrote {x} bytes to {x}, expected {x}\n", .{ ret, addr, len });
        return error.WriteError;
    }
}

pub const Dino = struct {
    i2cdev: std.fs.File,
    port: u8,
    dino_type: DinoType,
    const I2C_SWITCH_ADDR: u8 = 0x70;
    const I2C_IOEXT_ADDR: u8 = 0x20;
    const I2C_SWITCH_PORTS = [_]u8{ 0x20, 0x80, 0x02, 0x08, 0x10, 0x40, 0x01, 0x04 };
    const I2C_IOEXT_REG_DIR: u8 = 0x03;
    const I2C_IOEXT_REG_OUT: u8 = 0x01;
    const I2C_EEPROM_ADDR: u8 = 0x50;

    pub const IoextPorts = packed struct(u8) {
        clk_dir: bool = false,
        data_dir: bool = false,
        status_led: bool = false,
        n_we: bool = false,
        input_zero: bool = false,
        sat_detect: bool = false,
        gain_lsb: bool = false,
        gain_msb: bool = false,

        pub fn to_u8(self: IoextPorts) u8 {
            return @bitCast(self);
        }
        pub fn from_u8(val: u8) IoextPorts {
            return @bitCast(val);
        }
        pub fn to_string(self: IoextPorts) ![]u8 {
            var buf: [8:0]u8 = undefined;
            return try std.fmt.bufPrint(&buf, "{b}{b}{b}{b}{b}{b}{b}{b}", .{
                @intFromBool(self.clk_dir),
                @intFromBool(self.data_dir),
                @intFromBool(self.status_led),
                @intFromBool(self.n_we),
                @intFromBool(self.input_zero),
                @intFromBool(self.sat_detect),
                @intFromBool(self.gain_lsb),
                @intFromBool(self.gain_msb),
            });
        }
    };

    pub const Gain = enum(u8) {
        GAIN_1 = 0,
        GAIN_2 = 1,
        GAIN_5 = 2,
        GAIN_10 = 3,
        pub fn get_lsb(self: Gain) bool {
            return (@intFromEnum(self) & 0x1) == 1;
        }
        pub fn get_msb(self: Gain) bool {
            return (@intFromEnum(self) & 0x2) == 1;
        }
    };

    pub const DinoType = enum {
        ADC,
        DAC,
    };

    pub fn open(i2cdev: std.fs.File, port: u8, dino_type: DinoType) Dino {
        return Dino{ .i2cdev = i2cdev, .port = port, .dino_type = dino_type };
    }
    pub fn set_i2c_switch(self: *Dino, port: u8) !void {
        try i2c_write(self.i2cdev, I2C_SWITCH_ADDR, I2C_SWITCH_PORTS[port]);
    }
    pub fn set_ioext_dir(self: *Dino, dir: IoextPorts) !void {
        try i2c_write_cmd(self.i2cdev, I2C_IOEXT_ADDR, I2C_IOEXT_REG_DIR, dir.to_u8());
    }
    pub fn set_ioext_out(self: *Dino, out: IoextPorts) !void {
        try i2c_write_cmd(self.i2cdev, I2C_IOEXT_ADDR, I2C_IOEXT_REG_OUT, out.to_u8());
    }
    pub fn get_ioext_out(self: *Dino) !IoextPorts {
        return IoextPorts.from_u8(try i2c_read_cmd(self.i2cdev, I2C_IOEXT_ADDR, I2C_IOEXT_REG_OUT));
    }
    pub fn get_eeprom_data(self: *Dino, addr: u8, len: u8, buf: []u8) !void {
        return try i2c_read_bytes16(self.i2cdev, I2C_EEPROM_ADDR, addr, len, buf);
    }
    pub fn set_eeprom_data(self: *Dino, addr: u8, len: u8, buf: []u8) !void {
        return try i2c_write_bytes8(self.i2cdev, I2C_EEPROM_ADDR, addr, len, buf);
    }
    pub fn configure(self: *Dino) !void {
        try self.set_i2c_switch(self.port);
        if (self.dino_type == DinoType.ADC) {
            try self.set_ioext_dir(IoextPorts{ .sat_detect = true });
            try self.set_ioext_out(IoextPorts{ .data_dir = true, .status_led = true, .n_we = true, .input_zero = true });
            try self.set_ioext_out(IoextPorts{ .data_dir = true, .status_led = true, .input_zero = true });
        } else {
            try self.set_ioext_dir(IoextPorts{});
            try self.set_ioext_out(IoextPorts{ .status_led = true });
        }
    }
    pub fn set_gain(self: *Dino, gain: Gain) !void {
        if (self.dino_type != DinoType.ADC) {
            return error.InvalidDinoType;
        }
        try self.set_i2c_switch(self.port);
        var val = try self.get_ioext_out();
        val.gain_lsb = gain.get_lsb();
        val.gain_msb = gain.get_msb();
        try self.set_ioext_out(val);
    }
    pub fn get_config(self: *Dino) !IoextPorts {
        try self.set_i2c_switch(self.port);
        return try self.get_ioext_out();
    }
    pub fn program_dino_type(self: *Dino, dino_type: DinoType) !void {
        try self.set_i2c_switch(self.port);
        var buf = [_]u8{0x00} ** 4;
        switch(dino_type) {
            DinoType.ADC => {
                buf[1] = 'A';
                buf[2] = 'D';
                buf[3] = 'C';
            },
            DinoType.DAC => {
                buf[1] = 'D';
                buf[2] = 'A';
                buf[3] = 'C';
            },
        }
        try self.set_eeprom_data(0, 4, &buf);
    }
    pub fn query_dino_type(self: *Dino) !void {
        var buf: [3:0]u8 = undefined;
        try self.set_i2c_switch(self.port);
        self.get_eeprom_data(0, 3, &buf) catch |err| {
            switch (err) {
                error.WriteError => {
                    std.debug.print("EEPROM did not reply.", .{});
                    return error.EepromNoReply;
                },
                else => return err,
            }
        };
        std.debug.print("EEPROM: {x}{x}{x}", .{ buf[0], buf[1], buf[2] });
    }
};

pub fn main() !void {
    // Prints to stderr (it's a shortcut based on `std.io.getStdErr()`)
    std.debug.print("Good morning\n", .{});

    var i2cdev = try std.fs.openFileAbsolute("/dev/i2c-2", .{});
    defer i2cdev.close();

    var dinoCh1 = Dino.open(i2cdev, 0, Dino.DinoType.ADC);
    var dinoCh2 = Dino.open(i2cdev, 1, Dino.DinoType.DAC);

    try dinoCh1.configure();
    try dinoCh2.configure();
    try dinoCh1.set_gain(Dino.Gain.GAIN_1);

    var config = try dinoCh1.get_config();
    var str = try config.to_string();
    std.debug.print("Channel 1: {s}\n", .{str});
    config = try dinoCh2.get_config();
    str = try config.to_string();
    std.debug.print("Channel 2: {s}\n", .{str});

    try dinoCh2.program_dino_type(Dino.DinoType.DAC);
    try dinoCh2.query_dino_type();
}
