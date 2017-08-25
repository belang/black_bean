`timescale 1ns/1ps
// file name: bb_core.v
// author: lianghy
// time: 2017-8-10 15:42:09

`include "define.v"

module bb_core(
    clk,
    rst_n,
    i_data,
    o_action,
    o_addr,
    o_data,
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_data;
output [`DATA_WIDTH-1:0] o_action;
output [`DATA_WIDTH-1:0] o_addr;
output [`DATA_WIDTH-1:0] o_data;

wire [`DATA_WIDTH-1:0] alu_output, register_output ;
wire [5:0] unit_reg_input_en ;
wire [5:0] unit_reg_output_en;
wire [5:0] unit_alu_output_en;
wire [`DATA_WIDTH-1:0] direct_addr, operand0, operand1, program_addr;
wire pc_counter_en;

assign o_data = alu_result | register_result;

decoder decoder_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ir (i_data),
    .o_mem_action (o_action),
    .o_unit_reg_input_en (unit_reg_input_en),
    .o_unit_reg_output_en (unit_reg_output_en),
    .o_unit_alu_output_en (unit_alu_output_en),
    .o_action_read_addr_source (action_read_addr_source),
    .o_pc_counter_en (pc_counter_en)
);

data_reg_controller data_reg_controller_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_data (i_data),
    .i_unit_reg_input_en (unit_reg_input_en),
    .i_unit_reg_output_en (unit_reg_output_en),
    .i_unit_alu_output_en (unit_alu_output_en),
    .i_action_read_addr_source (action_read_addr_source),
    .i_pc_counter_en (pc_counter_en),
    .o_direct_addr (direct_addr),
    .o_operand0 (operand0),
    .o_operand1 (operand1),
    .o_register_output (register_output),
    .o_mem_read_addr (o_addr),
    .o_program_addr (program_addr)
);

alu alu_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_unit_alu_output_en (unit_alu_output_en),
    .i_operand0 (operand0),
    .i_operand1 (operand1),
    .i_direct_addr (direct_addr),
    .i_program_addr (program_addr),
    .o_alu_output (alu_output)
);
endmodule
