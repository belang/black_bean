`timescale 1ns/1ps
// file name: data_cache.v
// author: lianghy
// time: 2017-5-19 16:19:51

`include "define.v"

module data_cache(
    clk,
    rst_n,
    i_target_device_flag,
    i_device,
    i_address,
    i_data,
    o_data
);
input clk, rst_n;
input i_target_device_flag;
input [`DATA_WIDTH-1:0] i_device, i_address, i_data;
output [`DATA_WIDTH-1:0] o_data;
endmodule
