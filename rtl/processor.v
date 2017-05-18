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
    .i_regfile_en (ir_regfile_en),
    .i_regfile_selection (ir_regfile_selection),
    .i_read_or_write_en (ir_read_or_write_en),
    .i_address (ir_pointer),
    //.i_data (cached_data),
    .o_data (ir)
);

fetch fetch_0(
    .clk (clk),
    .rst_n (rst_n),
    //fetch_en,
    .o_target_device_flag (target_device_flag),
    .o_device (device),
    .o_address (address)
);

control control_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_device (device),
    .i_address (address),
    .o_ir_regfile_en (ir_regfile_en),
    .o_ir_regfile_selection (ir_regfile_selection),
    .o_ir_read_or_write_en (ir_read_or_write_en),
    .o_ir_pointer (ir_pointer)
    //fetch_en,
);

data_regifle data_regifle_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_device (device),
    .i_address (address),
    .i_data (cached_data),
    .o_data (data_to_cache)
);

data_cache data_cache_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_device (device),
    .i_address (address),
    .i_data (data_to_cache),
    .o_data (cached_data)
);

compute compute_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_device (device),
    .i_address (address),
    .i_data (cached_data),
    .o_data (data_to_cache)
);

interface interface_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_device (device),
    .i_address (address),
    .i_data (cached_data),
    .o_data (data_to_cache)
);

endmodule
