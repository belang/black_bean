`timescale 1ns/1ps
// file name: address_caculator.v
// author: lianghy
// time: 2017-8-16 11:23:04

`include "define.v"

module address_caculator(
    clk,
    rst_n,
    i_iosc_ins_pc_oen,
    i_pc_ien,
    i_dir_addr,
    o_pc
);
input clk, rst_n;
input i_iosc_ins_pc_oen;
input i_pc_ien;
input [`DATA_WIDTH-1:0] i_dir_addr;
output [`DATA_WIDTH-1:0] o_pc;

reg [`DATA_WIDTH:0] reg_PC;
wire [`DATA_WIDTH:0] next_pc;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_PC <= 0;
    end else begin
        reg_PC <= next_pc;
    end
end

// jump and read INS
assign next_pc = (i_pc_ien | i_iosc_ins_pc_oen) ? o_pc+1 : reg_PC;

assign o_pc = i_pc_ien ? i_dir_addr : reg_PC;

endmodule
