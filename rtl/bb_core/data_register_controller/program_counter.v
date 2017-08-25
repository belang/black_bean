`timescale 1ns/1ps
// file name: program_counter.v
// author: lianghy
// time: 2017-8-16 11:23:04

`include "define.v"

module program_counter(
    clk,
    rst_n,
    i_action,
    i_pc_input_en,
    i_data,
    o_pc
);
input clk, rst_n;
input [1:0] i_action;
input i_pc_input_en;
input [`DATA_WIDTH-1:0] i_data; // input instruction
output [`DATA_WIDTH-1:0] o_pc;

reg counter_en, set_counter;

counter_parameter #(8) counter_8bit(
    .clk (clk),
    .rst_n (rst_n),
    .i_set_en (set_counter),
    .i_counter_en (counter_en),
    .i_data (i_data),
    .number (o_pc)
);

endmodule
