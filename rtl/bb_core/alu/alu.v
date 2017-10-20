`timescale 1ns/1ps
// file name: alu.v
// author: lianghy
// time: 2017-8-11 13:54:28

`include "../../define.v"

module alu(
    clk,
    rst_n,
    i_alu_re_oen,
    i_alu_ad_oen,
    i_operand0,
    i_operand1,
    i_address_reg,
    i_program_count,
    i_config,
    o_alu_result
);
input clk, rst_n;
input i_alu_re_oen, i_alu_ad_oen;
input [`DATA_WIDTH-1:0] i_operand0, i_operand1, i_address_reg, i_program_count, i_config;
output [`DATA_WIDTH-1:0] o_alu_result;

wire [`DATA_WIDTH-1:0] adder_result, comparer_result, jump_result;
wire [`DATA_WIDTH-1:0] adder_except, comparer_except, jump_except;
reg [`DATA_WIDTH-1:0] o_result, o_except;

always @(clk) begin
    case (i_config)
        `ALU_ADD: begin
            o_result = adder_result;
            o_except = adder_except;
        end
        `ALU_COMPARER: begin
            o_result = comparer_result;
            o_except = comparer_except;
        end
        `ALU_JUMP_CON: begin
            o_result = jump_result;
            o_except = jump_except;
        end
        default: begin
            o_result = `DATA_WIDTH'h0;
            o_except = `DATA_WIDTH'h0;
        end
    endcase
end

assign o_alu_result = (i_alu_re_oen ? o_result : `DATA_WIDTH'h0) |
        (i_alu_ad_oen ? o_except : `DATA_WIDTH'h0);


adder adder_0(
    .clk    (clk),
    .rst_n    (rst_n),
    .i_operand0    (i_operand0),
    .i_operand1    (i_operand1),
    .o_adder_sum    (adder_result),
    .o_adder_carry    (adder_except)
);

comparer comparer_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_data0 (i_operand0),
    .i_data1 (i_operand1),
    .o_relation (comparer_result)
);

jump_condition jump_condition_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_operand0 (i_operand0),
    .i_operand1 (i_operand1),
    .i_direct_addr (i_address_reg),
    .i_program_addr (i_program_count),
    .o_addr (jump_result)
);

endmodule
