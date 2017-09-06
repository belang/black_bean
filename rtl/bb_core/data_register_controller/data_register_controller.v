`timescale 1ns/1ps
// file name: data_register_controller.v
// author: lianghy
// time: 2017-8-24 14:22:57
/*
    data registers except PC are in here.
*/

`include "define.v"

module data_register_controller(
    clk,
    rst_n,
    i_data,
    i_unit_reg_input_en,
    i_unit_reg_output_en,
    i_unit_alu_output_en,
    i_mem_addr_source,
    i_pc_counter_en,
    o_direct_addr,
    o_operand0,
    o_operand1,
    o_register_output,
    o_mem_addr,
    o_program_addr
);

input clk, rst_n;
input [`DATA_WIDTH-1:0] i_data;
input [5:0] i_unit_reg_input_en ;
input [5:0] i_unit_reg_output_en;
input [5:0] i_unit_alu_output_en;
input i_mem_addr_source, i_pc_counter_en;
output [`DATA_WIDTH-1:0] o_direct_addr, o_operand0, o_operand1;
output [`DATA_WIDTH-1:0] o_register_output;
output [`DATA_WIDTH-1:0] o_mem_addr;
output [`DATA_WIDTH-1:0] o_program_addr;

reg [`DATA_WIDTH-1:0] reg_AR, reg_DR0, reg_DR1 ;
wire [`DATA_WIDTH-1:0] program_addr;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_AR  <= `DATA_WIDTH'h0;
        reg_DR0 <= `DATA_WIDTH'h0;
        reg_DR1 <= `DATA_WIDTH'h0;
    end else begin
        reg_AR  <= i_unit_reg_input_en[1] ? i_data : reg_AR ;
        reg_DR0 <= i_unit_reg_input_en[2] ? i_data : reg_DR0;
        reg_DR1 <= i_unit_reg_input_en[3] ? i_data : reg_DR1;
    end
end

assign o_register_output =
    (i_unit_reg_output_en[1] ? reg_AR        : `DATA_WIDTH'h0) |
    (i_unit_reg_output_en[2] ? reg_DR0       : `DATA_WIDTH'h0) |
    (i_unit_reg_output_en[3] ? reg_DR1       : `DATA_WIDTH'h0) |
    (i_unit_reg_output_en[5] ? program_addr  : `DATA_WIDTH'h0) ;

assign o_direct_addr    = reg_AR;
assign o_operand0       = reg_DR0;
assign o_operand1       = reg_DR1;
assign o_mem_addr       = i_mem_addr_source ? program_addr : reg_AR;
assign o_program_addr   = program_addr;

program_counter program_counter_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_pc_input_en (i_unit_reg_input_en[5]),
    .i_pc_count_en(i_pc_counter_en),
    .i_data (i_data),
    .o_pc (program_addr)
);

endmodule
