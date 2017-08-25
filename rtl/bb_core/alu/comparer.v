`timescale 1ns/1ps
// file name: comparer.v
// author: lianghy
// time: 2017-8-11 13:55:21

`include "define.v"

module comparer(
    clk,
    rst_n,
    i_data0,
    i_data1,
    o_relation
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_data0;
input [`DATA_WIDTH-1:0] i_data1;
output [`DATA_WIDTH-1:0] o_relation;

// < 3C
// = 3D
// > 3E
// 
assign o_relation = 
    ((i_data0 <  i_data1) ? `DATA_WIDTH'h3c : `DATA_WIDTH'h00) |
    ((i_data0 == i_data1) ? `DATA_WIDTH'h3d : `DATA_WIDTH'h00) |
    ((i_data0 >  i_data1) ? `DATA_WIDTH'h3e : `DATA_WIDTH'h00) ;

endmodule
