`timescale 1ns/1ps
// file name: rom.v
// author: lianghy
// time: 2017/12/29 17:21:56


`include "define.v"

module rom(
    clk,
    rst_n,
    addr_bus,
    rom_addr,
    data_bus_in,
    instructor
);

input  clk, rst_n;
input  [`DATA_WIDTH-1:0] addr_bus;
input  [`ROM_ADDR_WIDTH-1:0] rom_addr;
input  [`DATA_WIDTH-1:0] data_bus_in;
output [`DATA_WIDTH-1:0] instructor;

regfile regfile0(
    .clk            (clk),
    .rst_n          (rst_n),
    .i_data         (data_bus_in),
    .i_address      (rom_addr),
    .i_write_en     (1'b0),
    .o_data         (instructor)
);

endmodule
