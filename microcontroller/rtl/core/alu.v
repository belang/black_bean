`timescale 1ns/1ps
// file name: alu.v
// author: lianghy
// time: 2018/1/8 16:19:19

`include "define.v"

module alu(
    clk,
    rst_n,
    op0,
    op1,
    cr,
    addr_bus,
    data_bus_out,
    alu_re
);

input  clk, rst_n;
input  [`DATA_WIDTH-1:0] op0, op1, cr;
input  [`DATA_WIDTH-1:0] addr_bus;
output [`DATA_WIDTH-1:0] data_bus_out;
output [`DATA_WIDTH-1:0] alu_re;

wire  [`DATA_WIDTH-1:0] alu_ad;
wire  [`DATA_WIDTH-1:0] compare_addition, compare_result;
wire  [`DATA_WIDTH-1:0] add_addition, add_result;
wire  [`DATA_WIDTH-1:0] counter_addition, counter_result;
wire  [`DATA_WIDTH-1:0] op0, op1, cr;

assign alu_re = (cr==`ALU_TRUE) ? `DATA_WIDTH'b1 :
                (cr==`ALU_FALSE) ? `DATA_WIDTH'b0 :
                compare_result | add_result | counter_result;
assign alu_ad = (cr==`ALU_TRUE) ? `DATA_WIDTH'b1 :
                (cr==`ALU_FALSE) ? `DATA_WIDTH'b0 :
                compare_addition | add_addition | counter_addition;
assign data_bus_out = (addr_bus[7:4]==`RE) ? alu_re : 
                  ((addr_bus[7:4]==`AD) ? alu_ad : `DATA_WIDTH'b0);

compare compare0(
    .op0                (op0),
    .op1                (op1),
    .relation           (cr),
    .compare_result     (compare_result),
    .compare_addition    (compare_addition)
);

add add0(
    .op0            (op0),
    .op1            (op1),
    .cr             (cr),
    .add_result     (add_result),
    .add_addition    (add_addition)
);

counter counter0(
    .clk            (clk),
    .rst_n          (rst_n),
    .dr0            (op0),
    .dr1            (op1),
    .cr             (cr),
    .addr_bus       (addr_bus),
    .counter_result    (counter_result),
    .counter_addition     (counter_addition)
);

endmodule
