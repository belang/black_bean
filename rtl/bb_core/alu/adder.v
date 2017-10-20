`timescale 1ns/1ps
// file name: adder.v
// author: lianghy
// time: 2017/10/19 11:08:08

`include "../../define.v"

module adder(
    clk,
    rst_n,
    i_operand0,
    i_operand1,
    o_adder_sum,
    o_adder_carry
);

input  clk, rst_n;
input [`DATA_WIDTH-1:0] i_operand0, i_operand1;
output [`DATA_WIDTH-1:0] o_adder_sum, o_adder_carry;

assign {o_adder_carry, o_adder_sum} = i_operand0+i_operand1;
endmodule
