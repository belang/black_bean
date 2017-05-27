`timescale 1ns/1ps
// file name: processor.v
// author: lianghy
// time: 2017-5-17 10:21:01

`include "define.v"

module processor(
clk,
rst_n,
);
input clk, rst_n;

ir_regifle ir_regifle_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ir (ir),
    .i_data (data_bus),
    .o_data (ir)
);

fetch fetch_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ir (ir),
    .i_data (data_bus),
    .o_data (fetch_data)
);

data_regfile data_regfile_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ir (ir),
    .i_data (data_bus),
    .o_data (regfile_data)
);

compute compute_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ir (ir),
    .i_data (data_bus),
    .o_data (regfile_data)
);

interface interface_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ir (ir),
    .i_data (data_bus),
    .o_data (regfile_data)
);

endmodule
