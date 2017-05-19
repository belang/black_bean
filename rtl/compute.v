`timescale 1ns/1ps
// file name: compute.v
// author: lianghy
// time: 2017-5-19 16:21:55

`include "define.v"

module compute(
    clk,
    rst_n,
    i_device,
    i_address,
    i_data,
    o_data
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_device, i_address, i_data;
output [`DATA_WIDTH-1:0] o_data;
endmodule
