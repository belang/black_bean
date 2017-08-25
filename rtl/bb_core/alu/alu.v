`timescale 1ns/1ps
// file name: alu.v
// author: lianghy
// time: 2017-8-11 13:54:28

`include "define.v"

module alu(
    clk,
    rst_n,
    i_unit_alu_output_en,
    i_perand0,
    i_perand1,
    i_direct_addr,
    i_program_addr,
    o_alu_output,
);
input clk, rst_n;
input [5:0] i_unit_alu_output_en;
input [`DATA_WIDTH-1:0] i_perand0, i_perand1, i_direct_addr, i_program_addr;
output [`DATA_WIDTH-1:0] o_alu_output;

wire [`DATA_WIDTH-1:0] comparer_relation, jump_addr;
reg [`DATA_WIDTH-1:0] o_result;

always @(i_unit_alu_output_en) begin
    case (i_unit_alu_output_en)
        `ALU_COMPARER: begin
            o_result = comparer_relation;
        end
        `ALU_JUMP_COND: begin
            o_result = jump_addr;
        end
        default: begin
            o_result = `DATA_WIDTH'h0;
        end
    endcase
end

comparer comparer_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_perand0 (i_perand0),
    .i_perand1 (i_perand1),
    .o_relation (comparer_relation)
);

jump_condition jump_condition_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_perand0 (i_perand0),
    .i_perand1 (i_perand1),
    .i_direct_addr (i_direct_addr),
    .i_program_addr (i_program_addr),
    .o_addr (jump_addr)
);


endmodule
