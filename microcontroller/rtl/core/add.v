`timescale 1ns/1ps
// file name: add.v
// author: lianghy
// time: 2018/1/8 16:58:18

`include "define.v"

module add(
    op0,
    op1,
    cr,
    add_result,
    add_addition
);

input  [`DATA_WIDTH-1:0] op0, op1, cr;
output [`DATA_WIDTH-1:0] add_result;
output [`DATA_WIDTH-1:0] add_addition;

assign {add_addition, add_result} = (cr==`ALU_ADD) ? (op0+op1) : `DATA_WIDTH'b0;
endmodule
