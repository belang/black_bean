`timescale 1ns/1ps
// file name: fetch.v
// author: lianghy
// time: 2017-5-12 11:03:42

`include "define.v"

module fetch(
clk,
rst_n,
i_next_ir_en,
i_data,
o_device,
o_port
);
input clk, rst_n;
input i_next_ir_en;
input  [`DATA_WIDTH-1:0] i_data;
output [`DATA_WIDTH-1:0] o_device, o_port;

reg [`DATA_WIDTH-1:0] reg_device;
reg state;

// state-- 0:fetch device ID
always @(posedge clk) begin
    if (!rst_n) begin
        reg_device <= `DATA_WIDTH'h0;
    end else begin
        reg_device <= state ? reg_device : i_data;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        state <= 1'b0;
    end else begin
        state <= i_next_ir_en ? !state : state;
    end
end

assign o_device = reg_device;
assign o_port = i_data;

endmodule
