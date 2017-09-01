`timescale 1ns/1ps
// file name: black_bean.v
// author: lianghy
// time: 2017-5-17 10:21:01

`include "define.v"

module black_bean(
    clk,
    rst_n,
    mem_r_data,
    mem_r_addr,
    mem_w_data,
    mem_w_addr,
    mem_r_en,
    mem_w_en
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] mem_r_data;
output [`DATA_WIDTH-1:0] mem_r_addr;
output [`DATA_WIDTH-1:0] mem_w_data;
output [`DATA_WIDTH-1:0] mem_w_addr;
output mem_r_en;
output mem_w_en;

wire [1:0] mem_action;
wire [`DATA_WIDTH-1:0] mem_address, mem_data_read_in, mem_data_to_write;

bb_core bb_core_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_data (mem_data_read_in),
    .o_action (mem_action),
    .o_addr (mem_address),
    .o_data (mem_data_to_write)
);

mem_controller mem_controller_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_action (mem_action),
    .i_address (mem_address),
    .i_data (mem_data_to_write),
    .o_data (mem_data_read_in),
    .mem_r_data (mem_r_data),
    .mem_r_addr (mem_r_addr),
    .mem_w_data (mem_w_data),
    .mem_w_addr (mem_w_addr),
    .mem_r_en (mem_r_en),
    .mem_w_en (mem_w_en)
);

endmodule
