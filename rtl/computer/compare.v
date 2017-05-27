`timescale 1ns/1ps
// file name: compare.v
// author: lianghy
// time: 2017-5-27 16:57:41

`include "define.v"

module compare(
    clk,
    rst_n,
    i_ir,
    i_data,
    o_data
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_ir, i_data;
output [`DATA_WIDTH-1:0] o_data;

endmodule
