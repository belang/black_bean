`timescale 1ns/1ps
// file name: skin.v
// author: lianghy
// time: 2017/10/16 11:20:08

`include "../define.v"

module skin(
    clk,
    rst_n,
    i_mem_oen,
    i_mem_ien,
    i_mem_addr,
    i_mem_pc,
    i_mem_data,
    o_mem_data,
    o_mem_interrupt,
    i_mem_r_data,
    o_mem_w_data,
    o_mem_addr,
    o_mem_r_en,
    o_mem_w_en
);

input  clk, rst_n;
input  [1:0] i_mem_oen;
input  [1:0] i_mem_ien;
input  [`DATA_WIDTH-1:0] i_mem_addr;
input  [`DATA_WIDTH-1:0] i_mem_pc  ;
input  [`DATA_WIDTH-1:0] i_mem_data;
output [`DATA_WIDTH-1:0] o_mem_data;
output [`DATA_WIDTH-1:0] o_mem_interrupt;
input  [`DATA_WIDTH-1:0] i_mem_r_data;
output [`DATA_WIDTH-1:0] o_mem_w_data;
output [`DATA_WIDTH-1:0] o_mem_addr;
output o_mem_r_en;
output o_mem_w_en;

wire [`DATA_WIDTH-1:0] mem_addr;
assign mem_addr = (i_mem_ien[0]|i_mem_oen[0]) ? i_mem_pc:i_mem_addr;

mem_controller mem_controller_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ren (|i_mem_oen),
    .i_wen (|i_mem_ien),
    .i_address (mem_addr),
    .i_data (i_mem_data),
    .o_data (o_mem_data),
    .mem_r_data (i_mem_r_data),
    .mem_w_data (o_mem_w_data),
    .mem_addr   (o_mem_addr  ),
    .mem_r_en   (o_mem_r_en  ),
    .mem_w_en   (o_mem_w_en  )
);

endmodule
