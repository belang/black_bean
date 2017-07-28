`timescale 1ns/1ps
// file name: address_caculator.v
// author: lianghy
// time: 2017-7-26 15:51:47

`include "define.v"

module address_caculator(
    clk,
    rst_n,
    i_target_address,
    i_object,
    i_condition,
    i_reset_ip ,
    i_hold_ip_flag,
    i_memory_address_source,
    i_select_jump_address,
    o_memory_address
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_target_address        ;
input [`DATA_WIDTH-1:0] i_object                ;
input [`DATA_WIDTH-1:0] i_condition             ;
input i_reset_ip              ;
input i_hold_ip_flag          ;
input i_memory_address_source ;
input i_select_jump_address   ;

output [`DATA_WIDTH-1:0] o_memory_address ;

reg [`DATA_WIDTH-1:0] reg_ip;

wire [`DATA_WIDTH-1:0] next_ip;
// when intstruction is transfer_condition and transfer condition don't match,
// next_ip_type is low.
// next_ip_type :: 1 -> match, reg_ip; 0 -> not match, reg_ip +1
wire next_ip_type;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_ip <= `IR_WIDTH'h00;
    end else begin
        reg_ip <= next_ip;
    end
end

assign next_ip = i_hold_ip_flag ? reg_ip : o_memory_address + `DATA_WIDTH'h1;

assign o_memory_address = i_reset_ip ? `DATA_WIDTH'h0 :
    i_memory_address_source ? i_target_address :
    next_ip_type ? reg_ip : reg_ip + `DATA_WIDTH'h1 ;

assign next_ip_type = (!i_select_jump_address) &&
    (i_object != i_condition) ;
endmodule
