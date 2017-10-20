`timescale 1ns/1ps
// file name: black_bean.v
// author: lianghy
// time: 2017-5-17 10:21:01

`include "define.v"

module black_bean(
    clk,
    rst_n,
    IO_MEM_R_DATA,
    IO_MEM_W_DATA,
    IO_MEM_ADDR,
    IO_MEM_R_EN,
    IO_MEM_W_EN
);

input clk, rst_n;
output [`DATA_WIDTH-1:0]   IO_MEM_R_DATA;
output [`DATA_WIDTH-1:0]   IO_MEM_W_DATA;
output [`DATA_WIDTH-1:0]   IO_MEM_ADDR;
output    IO_MEM_R_EN;
output    IO_MEM_W_EN;

wire [`DATA_WIDTH-1:0] mem_address, mem_data_read_in, mem_data_to_write;
wire [1:0] mem_oen;
wire [1:0] mem_ien;
wire [`DATA_WIDTH-1:0] mem_interrupt;
wire [`DATA_WIDTH-1:0] mem_addr, mem_pc, data_to_mem, data_from_mem;
wire mem_sc_oen, mem_sc_ien;
wire [`DATA_WIDTH-1:0] mem_sc_in_data, mem_sc_addr, mem_sc_out_data;
wire [`DATA_WIDTH-1:0] mem_sc_interrupt;
wire oth_oen, oth_ien;
wire [`DATA_WIDTH-1:0] oth_in_data, oth_addr, oth_out_data;

bb_core bb_core_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_mem_data (data_from_mem),
    .o_mem_oen (mem_oen),
    .o_mem_ien (mem_ien),
    .o_mem_addr (mem_addr),
    .o_mem_pc   (mem_pc  ),
    .o_mem_data (data_to_mem),
    .i_oth_data (oth_out_data),
    .o_oth_oen (oth_oen),
    .o_oth_ien (oth_ien),
    .o_oth_addr (oth_addr),
    .o_oth_data (oth_in_data)
);

skin skin_0(
    .clk    (clk),
    .rst_n    (rst_n),
    .i_mem_oen    (mem_oen),
    .i_mem_ien    (mem_ien),
    .i_mem_addr    (mem_addr),
    .i_mem_pc    (mem_pc),
    .i_mem_data    (data_to_mem),
    .o_mem_data    (data_from_mem),
    .o_mem_interrupt    (mem_interrupt),
    .i_mem_r_data  (IO_MEM_R_DATA),
    .o_mem_w_data  (IO_MEM_W_DATA),
    .o_mem_addr    (IO_MEM_ADDR),
    .o_mem_r_en    (IO_MEM_R_EN),
    .o_mem_w_en    (IO_MEM_W_EN)
);

endmodule
