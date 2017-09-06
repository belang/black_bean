`timescale 1ns/1ps
// file name: program_counter.v
// author: lianghy
// time: 2017-8-16 11:23:04

`include "define.v"

module program_counter(
    clk,
    rst_n,
    i_pc_input_en,
    i_pc_count_en,
    i_data,
    o_pc
);
input clk, rst_n;
input i_pc_input_en, i_pc_count_en;
input [`DATA_WIDTH-1:0] i_data;
output [`DATA_WIDTH-1:0] o_pc;

reg [`DATA_WIDTH:0] reg_counter;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_counter <= 0;
    end else if (i_pc_count_en) begin
        reg_counter <= o_pc+1;
    end
end
assign o_pc = i_pc_input_en ? i_data : reg_counter;

endmodule
