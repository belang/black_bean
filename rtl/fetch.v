`timescale 1ns/1ps
// file name: fetch.v
// author: lianghy
// time: 2017-5-12 11:03:42

`include "define.v"

module fetch(
    clk,
    rst_n,
    i_ir,
    i_data,
    o_data
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_ir, i_data;
output [`DATA_WIDTH-1:0] o_data;

reg [`DATA_WIDTH-1:0] reg_data;

// state-- 0:fetch device ID
always @(posedge clk) begin
    if (!rst_n) begin
        reg_data <= `DATA_WIDTH'h0;
    end else begin
        reg_data <= i_ir[0] ? i_ir : `DATA_WIDTH'h0;
    end
end

assign o_data = reg_data;

endmodule
