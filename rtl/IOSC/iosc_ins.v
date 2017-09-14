`timescale 1ns/1ps
// file name: iosc_ins.v
// author: lianghy
// time: 2017-9-7 9:08:00

`include "define.v"

module iosc_ins(
    clk,
    rst_n,
    i_core_oen,
    i_core_ien,
    i_core_addr,
    i_core_pc,
    i_core_data,
    o_core_data,
    o_core_interrupt,
    i_skin_data,
    i_skin_interrupt,
    o_skin_oen,
    o_skin_ien,
    o_skin_addr,
    o_skin_data
);

input  clk, rst_n;
input  [1:0] i_core_oen;
input  [1:0] i_core_ien;
input  [`DATA_WIDTH-1:0] i_core_addr;
input  [`DATA_WIDTH-1:0] i_core_pc  ;
input  [`DATA_WIDTH-1:0] i_core_data;
output [`DATA_WIDTH-1:0] o_core_data;
output [`DATA_WIDTH-1:0] o_core_interrupt;
// skin
input  [`DATA_WIDTH-1:0] i_skin_data;
input  [`DATA_WIDTH-1:0] i_skin_interrupt;
output o_skin_oen;
input  o_skin_ien;
output [`DATA_WIDTH-1:0] o_skin_addr;
output [`DATA_WIDTH-1:0] o_skin_data;

assign o_skin_oen = |i_core_oen;
assign o_skin_ien = |i_core_ien;
assign o_skin_addr = (i_core_ien[0] | i_core_oen[0]) ? i_core_pc : i_core_addr;
assign o_skin_data = i_core_data;
assign o_core_data = i_skin_data;
assign o_core_interrupt = i_skin_interrupt;

endmodule
