`timescale 1ns/1ps
// file name: controller.v
// author: lianghy
// time: 2017-5-11 17:20:23

`include "define.v"

module controller(
    clk,
    rst_n,
    memory_read_data,
    memory_write_data,
    memory_address,
    memory_write_enable,
    memory_read_enable
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] memory_read_data ;
output [`DATA_WIDTH-1:0] memory_write_data ;
output [`DATA_WIDTH-1:0] memory_address ;
output memory_read_enable;
output memory_write_enable;

wire [`DATA_WIDTH-1:0] raw_bus_0, raw_bus_1 ;
wire memory_address_source;
wire hold_ip_flag;
wire reset_ip;
wire select_jump_address;
wire ir_enable;
wire raw_bus_0_wen;
wire raw_bus_1_wen;
wire raw_bus_0_ren;
wire raw_bus_1_ren;

address_caculator address_caculator_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_target_address (raw_bus_0),
    .i_object (raw_bus_0),
    .i_condition (raw_bus_1),
    .i_reset_ip (reset_ip),
    .i_hold_ip_flag (hold_ip_flag),
    .i_memory_address_source (memory_address_source),
    .i_select_jump_address (select_jump_address),
    .o_memory_address (memory_address)
);

raw_bus raw_bus_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_raw_bus_0_en (raw_bus_0_en),
    .i_raw_bus_1_en (raw_bus_1_en),
    .i_data (memory_read_data),
    .o_raw_bus_0 (raw_bus_0),
    .o_raw_bus_1 (raw_bus_1)
);

result_bus result_bus_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_raw_bus_0 (raw_bus_0),
    .i_raw_bus_1 (raw_bus_1),
    .i_raw_bus_0_ren (raw_bus_0_ren),
    .i_raw_bus_1_ren (raw_bus_1_ren),
    .o_data (memory_write_data)
);

decoder decoder_0(
    .clk (clk),
    .rst_n (rst_n),
    .i_ir (memory_read_data),
    .o_memory_address_source (memory_address_source),
    .o_memory_read_enable (memory_read_enable),
    .o_memory_write_enable (memory_write_enable),
    .o_hold_ip_flag (hold_ip_flag),
    .o_reset_ip (reset_ip),
    .o_select_jump_address (select_jump_address),
    .o_ir_enable (ir_enable),
    .o_raw_bus_0_wen (raw_bus_0_wen),
    .o_raw_bus_1_wen (raw_bus_1_wen),
    .o_raw_bus_0_ren (raw_bus_0_ren),
    .o_raw_bus_1_ren (raw_bus_1_ren)
);

endmodule
