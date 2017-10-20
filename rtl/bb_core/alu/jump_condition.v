`timescale 1ns/1ps
// file name: jump_condition.v
// author: lianghy
// time: 2017-8-24 10:35:32
/*
    caculate the jump address.
    if the dr0 match dr1, the jump address is from AR,
    else is NPC.
*/

`include "../../define.v"

module jump_condition(
    clk,
    rst_n,
    i_operand0,
    i_operand1,
    i_direct_addr,
    i_program_addr,
    o_addr
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_operand0, i_operand1, i_direct_addr, i_program_addr;
output [`DATA_WIDTH-1:0] o_addr;

assign o_addr = (i_operand0 == i_operand1) ? i_direct_addr : i_program_addr;
endmodule
