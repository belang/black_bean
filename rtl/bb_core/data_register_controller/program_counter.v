`timescale 1ns/1ps
// file name: program_counter.v
// author: lianghy
// time: 2017-8-16 11:23:04

`include "define.v"

module program_counter(
    clk,
    rst_n,
    i_pc_input_en,
    i_pc_counter_en,
    i_data,
    o_pc
);
input clk, rst_n;
input i_pc_input_en, i_pc_counter_en;
input [`DATA_WIDTH-1:0] i_data;
output [`DATA_WIDTH-1:0] o_pc;

counter_parameter #(8) counter_8bit(
    .clk (clk),
    .rst_n (rst_n),
    .i_set_en (i_pc_input_en),
    .i_count_en (i_pc_counter_en),
    .i_data (i_data),
    .number (o_pc)
);

endmodule
