`timescale 1ns/1ps
// file name: common_register.v
// author: lianghy
// time: 2017-8-24 14:22:57
/*
    data registers except PC are in here.
*/

`include "define.v"

module common_register(
    clk,
    rst_n,
    i_skin_data,
    i_core_data,
    i_unit_ien,
    i_unit_oen,
    o_address_reg,
    o_operand0,
    o_operand1,
    o_config_reg,
    o_program_count,
    o_instruction,
    o_reg_value
);

input clk, rst_n;
input [`DATA_WIDTH-1:0] i_skin_data, i_core_data;
input [15:0] i_unit_ien ;
input [15:0] i_unit_oen;
output [`DATA_WIDTH-1:0] o_address_reg, o_operand0, o_operand1, o_config_reg, o_program_count, o_instruction;
output [`DATA_WIDTH-1:0] o_reg_value;

reg [`DATA_WIDTH-1:0] reg_AR, reg_DR0, reg_DR1, reg_CR, reg_IR, reg_PC;
//wire [`DATA_WIDTH-1:0] reg_PC ;
wire [`DATA_WIDTH-1:0] sc_data;


always @(posedge clk) begin
    if (!rst_n) begin
        reg_AR  <= `DATA_WIDTH'h0;
        reg_DR0 <= `DATA_WIDTH'h0;
        reg_DR1 <= `DATA_WIDTH'h0;
        reg_CR  <= `DATA_WIDTH'h0;
        reg_IR  <= `DATA_WIDTH'h0;
        reg_PC  <= `DATA_WIDTH'h0;
    end else begin
        reg_IR  <= i_unit_ien[0] ? sc_data : reg_IR ;
        reg_AR  <= i_unit_ien[2] ? sc_data : reg_AR ;
        reg_DR0 <= i_unit_ien[3] ? sc_data : reg_DR0;
        reg_DR1 <= i_unit_ien[4] ? sc_data : reg_DR1;
        reg_CR  <= i_unit_ien[5] ? sc_data : reg_CR ;
        reg_PC  <= i_unit_ien[1] ? sc_data :
                (i_unit_oen[11]) ? reg_PC+1 : reg_PC;
    end
end

assign sc_data = (|i_unit_oen[13:11]) ? i_skin_data :
        (|i_unit_oen[10:0]) ? i_core_data : `DATA_WIDTH'h0;

assign o_reg_value =
    (i_unit_oen[0] ? reg_IR        : `DATA_WIDTH'h0) |
    (i_unit_oen[1] ? reg_PC        : `DATA_WIDTH'h0) |
    (i_unit_oen[2] ? reg_AR        : `DATA_WIDTH'h0) |
    (i_unit_oen[3] ? reg_DR0       : `DATA_WIDTH'h0) |
    (i_unit_oen[4] ? reg_DR1       : `DATA_WIDTH'h0) |
    (i_unit_oen[5] ? reg_CR        : `DATA_WIDTH'h0) ;

assign o_instruction    = reg_IR;
assign o_program_count  = reg_PC;
assign o_address_reg    = reg_AR;
assign o_operand0       = reg_DR0;
assign o_operand1       = reg_DR1;
assign o_config_reg     = reg_CR;

//address_caculator address_caculator_0(
    //.clk(clk),
    //.rst_n(rst_n),
    //.i_iosc_ins_pc_oen(i_unit_oen[11]),
    //.i_pc_ien(i_unit_ien[1]),
    //.i_dir_addr(sc_data),
    //.o_pc(reg_PC)
//);

endmodule
