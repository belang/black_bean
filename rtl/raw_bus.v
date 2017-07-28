`timescale 1ns/1ps
// file name: raw_bus.v
// author: lianghy
// time: 2017-7-27 10:14:15

`include "define.v"

module raw_bus(
    clk,
    rst_n,
    i_raw_bus_0_en,
    i_raw_bus_1_en,
    i_data,
    o_raw_bus_0,
    o_raw_bus_1
);
input clk, rst_n;
input i_raw_bus_0_en;
input i_raw_bus_1_en;
input [`DATA_WIDTH-1:0] i_data;

output [`DATA_WIDTH-1:0] o_raw_bus_0, o_raw_bus_1;

reg [`DATA_WIDTH-1:0] reg_raw_bus_0, reg_raw_bus_1;

wire [`DATA_WIDTH-1:0] next_raw_bus_0, next_raw_bus_1;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_raw_bus_0 <= `DATA_WIDTH'h0;
        reg_raw_bus_1 <= `DATA_WIDTH'h0;
    end else begin
        reg_raw_bus_0 <= next_raw_bus_0;
        reg_raw_bus_1 <= next_raw_bus_1;
    end
end

assign next_raw_bus_0 = i_raw_bus_0_en ? i_data : reg_raw_bus_0;
assign next_raw_bus_1 = i_raw_bus_1_en ? i_data : reg_raw_bus_1;
endmodule
