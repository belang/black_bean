`timescale 1ns/1ps
// file name: bb_core.v
// author: lianghy
// time: 2017-8-10 15:42:09

`include "define.v"

module bb_core(
    clk,
    rst_n,
    i_ins_data,
    o_ins_oen,
    o_ins_ien,
    o_ins_addr,
    o_ins_pc,
    o_ins_data,
    i_oth_data,
    o_oth_oen,
    o_oth_ien,
    o_oth_addr,
    o_oth_data
);

input  clk,  rst_n;
input  [`DATA_WIDTH-1:0] i_ins_data;
output [1:0] o_ins_oen;
output [1:0] o_ins_ien;
output [`DATA_WIDTH-1:0] o_ins_addr, o_ins_pc;
output [`DATA_WIDTH-1:0] o_ins_data;
input  [`DATA_WIDTH-1:0] i_oth_data;
output o_oth_oen, o_oth_ien;
output [`DATA_WIDTH-1:0] o_oth_addr;
output [`DATA_WIDTH-1:0] o_oth_data;

wire [`DATA_WIDTH-1:0] alu_output, register_output ;
wire [`DATA_WIDTH-1:0] address_reg, config_reg ;
wire [`DATA_WIDTH-1:0] operand0, operand1, program_count;
wire [`DATA_WIDTH-1:0] device_data, ins;
wire [`DATA_WIDTH-1:0] branch_addr;
wire [15:0] unit_oen, unit_ien;

assign device_data = unit_oen[14] ? i_oth_data : i_ins_data;
assign o_ins_oen  = unit_oen[13:12];
assign o_ins_ien  = unit_ien[13:12];
assign o_ins_data = alu_output | register_output;
assign o_ins_addr = address_reg;
assign o_ins_pc   = program_count;
assign o_oth_oen  = unit_oen[14];
assign o_oth_ien  = unit_ien[14];
assign o_oth_addr = address_reg;
assign o_oth_data = alu_output | register_output;

// #block#controller
decoder decoder_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ins (ins),
    .o_unit_ien (unit_ien),
    .o_unit_oen (unit_oen)
);

brancher brancher_0(
    .clk                (clk),
    .rst_n              (rst_n),
    .i_program_count    (program_count),
    .i_address_reg      (address_reg),
    .i_operand0         (operand0),
    .i_operand1         (operand1),
    .i_config_reg       (config_reg),
    .i_config_reg_ien   (unit_ien[6]),
    .i_config_reg_oen   (unit_oen[6]),
    .o_branch_addr      (branch_addr)
);

// #block#GPR: general purpose registers
common_register common_register_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_skin_data (device_data),
    .i_core_data (o_ins_data),
    .i_unit_ien (unit_ien),
    .i_unit_oen (unit_oen),
    .i_branch_addr      (branch_addr)
    .o_address_reg (address_reg),
    .o_operand0 (operand0),
    .o_operand1 (operand1),
    .o_config_reg (config_reg),
    .o_program_count (program_count),
    .o_instruction(ins),
    .o_reg_value (register_output)
);

// #block#alu
alu alu_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_alu_re_oen (unit_oen[9]),
    .i_alu_ad_oen (unit_oen[10]),
    .i_operand0 (operand0),
    .i_operand1 (operand1),
    .i_address_reg (address_reg),
    .i_program_count (program_count),
    .i_config (config_reg),
    .o_alu_output (alu_output)
);


endmodule
