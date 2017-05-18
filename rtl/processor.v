`timescale 1ns/1ps
// file name: processor.v
// author: lianghy
// time: 2017-5-17 10:21:01

`include "define.v"

module processor(
clk,
rst_n,
);
input clk, rst_n;

ir_regifle ir_regifle_0(
    .clk (clk),
    .rst_n (rst_n),
    regfile_en,
    .regfile_selection (ir_regfile_selection),
    read_or_write_en,
    .address (ir_pointer),,
    .i_data (cached_data),
    .o_data (ir),
);

fetch fetch_0(
    .clk (clk),
    .rst_n (rst_n),
    //fetch_en,
    target_device_flag,
    device,
    address,
);

control control_0(
    device,
    address,
    ir_regfile_en,
    ir_regfile_selection,
    ir_read_or_write_en,
    ir_pointer,
    //fetch_en,
);
endmodule
