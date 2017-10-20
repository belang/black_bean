`timescale 1ns/1ps
// file name: mem_controller.v
// author: lianghy
// time: 2017-8-11 15:50:12

`include "../define.v"

module mem_controller(
    clk,
    rst_n,
    i_ren,
    i_wen,
    i_address,
    i_data,
    o_data,
    mem_r_data,
    mem_w_data,
    mem_addr,
    mem_r_en,
    mem_w_en
);

input clk, rst_n;
input i_ren, i_wen;
input [`DATA_WIDTH-1:0] i_address ;
input [`DATA_WIDTH-1:0] i_data ;
output [`DATA_WIDTH-1:0] o_data ;
// ports to chip top
input [`DATA_WIDTH-1:0] mem_r_data;
output [`DATA_WIDTH-1:0] mem_w_data;
output [`DATA_WIDTH-1:0] mem_addr;
output mem_r_en;
output mem_w_en;

assign mem_r_en = i_ren;
assign mem_w_en = i_wen;
assign mem_w_data = i_data;
assign mem_addr = i_address;
assign o_data = mem_r_data ;

endmodule
