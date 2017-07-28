`timescale 1ns/1ps
// file name: result_bus.v
// author: lianghy
// time: 2017-7-27 10:19:22

`include "define.v"

module result_bus(
    clk,
    rst_n,
    i_raw_bus_0,
    i_raw_bus_1,
    i_raw_bus_0_ren,
    i_raw_bus_1_ren,
    o_data
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_raw_bus_0;
input [`DATA_WIDTH-1:0] i_raw_bus_1;
input i_raw_bus_0_en;
input i_raw_bus_1_en;
//input [`DATA_WIDTH-1:0] i_md_a;

output [`DATA_WIDTH-1:0] o_data;

assign o_data = (i_raw_bus_0_ren ? i_raw_bus_0 : `DATA_WIDTH'h0) |
    (i_raw_bus_1_ren ? i_raw_bus_1 : `DATA_WIDTH'h0);
endmodule
