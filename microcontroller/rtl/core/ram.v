`timescale 1ns/1ps
// file name: ram.v
// author: lianghy
// time: 2017/12/29 17:21:56

`include "define.v"

module ram(
    clk,
    rst_n,
    addr_bus,
    ram_addr,
    data_bus_in,
    data_bus_out
);

input  clk, rst_n;
input  [`DATA_WIDTH-1:0] addr_bus;
input  [`RAM_ADDR_WIDTH-1:0] ram_addr;
input  [`DATA_WIDTH-1:0] data_bus_in;
output [`DATA_WIDTH-1:0] data_bus_out;

wire ren, wen;
wire [`DATA_WIDTH-1:0] data_out;

assign ren = addr_bus[7:4]==`RAM;
assign wen = addr_bus[3:0]==`RAM;

assign data_bus_out = ren ? data_out : `DATA_WIDTH'b0;

regfile regfile0(
    .clk           (clk),
    .rst_n         (rst_n),
    .i_data        (data_bus_in),
    .i_address     (ram_addr),
    .i_write_en    (wen),
    .o_data         (data_out)
);
endmodule
