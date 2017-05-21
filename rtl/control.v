`timescale 1ns/1ps
// file name: control.v
// author: lianghy
// time: 2017-5-11 17:20:23

`include "define.v"

`define LRST    4'h0
`define LWORK   4'h1

`define LIR_IDLE    2'b00
`define LIR_RST     2'b01
`define LIR_WORK    2'b10

module control(
    clk,
    rst_n,
    i_device,
    i_address,
    o_ir_regfile_en,
    o_ir_regfile_selection,
    o_ir_read_or_write_en,
    o_ir_pointer
);
input clk, rst_n;
input  [`DATA_WIDTH-1:0] i_device, i_address;
output o_ir_regfile_en, o_ir_regfile_selection, o_ir_read_or_write_en;
output [`DATA_WIDTH-1:0] o_ir_pointer;

reg [3:0] reg_core_state;

// wire
reg o_ir_regfile_selection;
reg o_ir_regfile_en;
reg [3:0] next_core_state;
wire device_en;
wire [`DATA_WIDTH-1:0] i_port;
wire larger_en;
wire smaller_en;
wire equal_en;
wire unequal_en;
wire direct_en;
wire address_en;
wire wait_en;
wire stop_en;

// device en
assign device_en = i_device==`DEVICE_CONTROLLER;

// port en
assign i_port = device_en ? i_address:`DATA_WIDTH'h0;

assign larger_en =  i_port == `PORT_JUMP_LARGER ;
assign smaller_en = i_port == `PORT_JUMP_SMALLER;
assign equal_en =   i_port == `PORT_JUMP_EQUAL  ;
assign unequal_en = i_port == `PORT_JUMP_UNEQUAL;
assign direct_en =  i_port == `PORT_JUMP_DIRECT ;
assign address_en = i_port == `PORT_JUMP_ADDR   ;
assign wait_en =    i_port == `PORT_WAIT        ;
assign stop_en =    i_port == `PORT_STOP        ;

// submodule

// core state
always @(posedge clk) begin
    if (!rst_n) begin
        reg_core_state <= `LRST;
    end else begin
        reg_core_state <= next_core_state;
    end
end
always @(*) begin
    case (reg_core_state)
        `LRST: begin
            // reset finished condition
            if (direct_en) begin
                next_core_state = `LWORK;
            end
        end
        default: begin
            next_core_state = reg_core_state;
        end
    endcase
end
always @(reg_core_state) begin
    case (reg_core_state)
        `LRST: begin
            o_ir_regfile_selection = `LIR_RST;
        end
        `LWORK: begin
            o_ir_regfile_selection = `LIR_WORK;
        end
        default: begin
            o_ir_regfile_selection = `LIR_IDLE;
        end
    endcase
end

endmodule
