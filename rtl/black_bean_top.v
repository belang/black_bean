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
wire [1:0] ins_oen;
wire [1:0] ins_ien;
wire [`DATA_WIDTH-1:0] ins_interrupt;
wire [`DATA_WIDTH-1:0] ins_addr, ins_pc, ins_in_data, ins_out_data;
wire mem_sc_oen, mem_sc_ien;
wire [`DATA_WIDTH-1:0] mem_sc_in_data, mem_sc_addr, mem_sc_out_data;
wire [`DATA_WIDTH-1:0] mem_sc_interrupt;
wire oth_oen, oth_ien;
wire [`DATA_WIDTH-1:0] oth_in_data, oth_addr, oth_out_data;

bb_core bb_core_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ins_data (ins_out_data),
    .o_ins_oen (ins_oen),
    .o_ins_ien (ins_ien),
    .o_ins_addr (ins_addr),
    .o_ins_pc   (ins_pc  ),
    .o_ins_data (ins_in_data),
    .i_oth_data (oth_out_data),
    .o_oth_oen (oth_oen),
    .o_oth_ien (oth_ien),
    .o_oth_addr (oth_addr),
    .o_oth_data (oth_in_data)
);

iosc_ins iosc_ins_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_core_oen         (ins_oen),
    .i_core_ien         (ins_ien),
    .i_core_addr        (ins_addr),
    .i_core_pc          (ins_pc  ),
    .i_core_data        (ins_in_data),
    .o_core_data        (ins_out_data),
    .o_core_interrupt   (ins_interrupt),
    .i_skin_data        (mem_sc_in_data),
    .i_skin_interrupt   (mem_sc_interrupt),
    .o_skin_oen         (mem_sc_oen),
    .o_skin_ien         (mem_sc_ien),
    .o_skin_addr        (mem_sc_addr),
    .o_skin_data        (mem_sc_out_data)
);

mem_controller mem_controller_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ren (mem_sc_oen),
    .i_wen (mem_sc_ien),
    .i_address (mem_sc_addr),
    .i_data (mem_sc_out_data),
    .o_data (mem_sc_in_data),
    .mem_r_data (IO_MEM_R_DATA),
    .mem_w_data (IO_MEM_W_DATA),
    .mem_addr   (IO_MEM_ADDR),
    .mem_r_en   (IO_MEM_R_EN),
    .mem_w_en   (IO_MEM_W_EN)
);

endmodule
