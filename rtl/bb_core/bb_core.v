`timescale 1ns/1ps
// file name: bb_core.v
// author: lianghy
// time: 2017-8-10 15:42:09

`include "../define.v"

module bb_core(
    clk,
    rst_n,
    i_mem_data,
    o_mem_oen,
    o_mem_ien,
    o_mem_addr,
    o_mem_pc,
    o_mem_data,
    i_oth_data,
    o_oth_oen,
    o_oth_ien,
    o_oth_addr,
    o_oth_data
);

input  clk,  rst_n;
input  [`DATA_WIDTH-1:0] i_mem_data;
output [1:0] o_mem_oen;
output [1:0] o_mem_ien;
output [`DATA_WIDTH-1:0] o_mem_addr, o_mem_pc;
output [`DATA_WIDTH-1:0] o_mem_data;
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

assign device_data = unit_oen[`INDEX_EN_OTH] ? i_oth_data : i_mem_data;
assign o_mem_oen  = {unit_oen[`INDEX_EN_MEM_AR], unit_oen[`INDEX_EN_MEM_PC]};
assign o_mem_ien  = {unit_ien[`INDEX_EN_MEM_AR], unit_ien[`INDEX_EN_MEM_PC]};
assign o_mem_data = alu_output | register_output;
assign o_mem_addr = address_reg;
assign o_mem_pc   = program_count;
assign o_oth_oen  = unit_oen[`INDEX_EN_OTH];
assign o_oth_ien  = unit_ien[`INDEX_EN_OTH];
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
    .o_branch_addr      (branch_addr)
);

// #block#GPR: general purpose registers
common_register common_register_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_skin_data (device_data),
    .i_core_data (o_mem_data),
    .i_unit_ien (unit_ien),
    .i_unit_oen (unit_oen),
    .i_branch_addr      (branch_addr),
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
    .i_alu_re_oen (unit_oen[`INDEX_EN_RE]),
    .i_alu_ad_oen (unit_oen[`INDEX_EN_AD]),
    .i_operand0 (operand0),
    .i_operand1 (operand1),
    .i_address_reg (address_reg),
    .i_program_count (program_count),
    .i_config (config_reg),
    .o_alu_result (alu_output)
);


endmodule
