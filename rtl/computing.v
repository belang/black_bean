`timescale 1ns/1ps
// file name: computing.v
// author: lianghy
// time: 2017-5-9 15:59:32

`include "define.v"

`include "adder.v"
`include "compare.v"

module computing(
clk,
rst_n,
device_en,
address,
i_data,
o_data
);
input clk, rst_n;
input  device_en;
input  [`DATA_WIDTH-1:0] address, i_data;
output [`DATA_WIDTH-1:0] o_data;

assign i_port = device_en?address:`DATA_WIDTH'h0;
assign o_data = o_data_adder | o_data_compare;

adder adder_0 (
.clk (clk),
.rst_n (rst_n),
.i_data (i_data),
.i_port (i_port),
.o_data (o_data)
);
compare compare_0 (
.clk (clk),
.rst_n (rst_n),
.i_data (i_data),
.i_port (i_port),
.o_data (o_data)
);
endmodule
