`timescale 1ns/1ps
// file name: alu.v
// author: lianghy
// time: 2017-8-11 13:54:28

`include "define.v"

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
    o_alu_output
);
input clk, rst_n;
input i_alu_re_oen, i_alu_ad_oen;
input [`DATA_WIDTH-1:0] i_operand0, i_operand1, i_address_reg, i_program_count, i_config;
output [`DATA_WIDTH-1:0] o_alu_output;

wire [`DATA_WIDTH-1:0] comparer_relation, jump_addr;
reg [`DATA_WIDTH-1:0] o_result;

always @(i_config, comparer_relation, jump_addr) begin
    case (i_config)
        `ALU_COMPARER: begin
            o_result = comparer_relation;
        end
        `ALU_JUMP_CON: begin
            o_result = jump_addr;
        end
        default: begin
            o_result = `DATA_WIDTH'h0;
        end
    endcase
end

assign o_alu_output = (i_alu_re_oen ? o_result : `DATA_WIDTH'h0) |
        (i_alu_ad_oen ? `DATA_WIDTH'h0 : `DATA_WIDTH'h0);

comparer comparer_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_data0 (i_operand0),
    .i_data1 (i_operand1),
    .o_relation (comparer_relation)
);

jump_condition jump_condition_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_operand0 (i_operand0),
    .i_operand1 (i_operand1),
    .i_direct_addr (i_address_reg),
    .i_program_addr (i_program_count),
    .o_addr (jump_addr)
);

endmodule
