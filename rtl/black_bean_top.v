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
    .o_ir_addr_next (ir_addr_next),
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

jump jump_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ir_addr_next (ir_addr_next),
    .i_ir (ir),
    .i_data (data_bus),
    .o_data (jump_data)
);

computer computer_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ir (ir),
    .i_data (data_bus),
    .o_data (computer_data)
);

interface interface_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ir (ir),
    .i_data (data_bus),
    .o_data_valid (interface_data_valid),
    .o_data (interface_data)
);

assign data_bus = fetch_data | regfile_data | jump_data | compare_data |
    interface_data ;
endmodule
