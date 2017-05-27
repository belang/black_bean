`timescale 1ns/1ps
// file name: computer.v
// author: lianghy
// time: 2017-5-19 16:21:55

`include "define.v"
`include "computer/compare.v"

module computer(
    clk,
    rst_n,
    i_ir,
    i_data,
    o_data
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_ir, i_data;
output [`DATA_WIDTH-1:0] o_data;

compare compare_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ir (ir),
    .i_data (data_bus),
    .o_data (compare_data)
);
endmodule
