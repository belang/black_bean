`timescale 1ns/1ps
// file name: fetch.v
// author: lianghy
// time: 2017-5-12 11:03:42

`include "define.v"

`define LIDLE            4'h0
`define LSOURCE_DEVICE   4'h0
`define LSOURCE_ADDRESS  4'h0
`define LTARGET_DEVICE   4'h0
`define LTARGET_ADDRESS  4'h0

module fetch(
    clk,
    rst_n,
    i_ir_regfile_en,
    i_ir,
    o_target_device_flag,
    o_device,
    o_address
);
input clk, rst_n;
input  i_ir_regfile_en;
input  [`DATA_WIDTH-1:0] i_ir;
output o_target_device_flag;
output [`DATA_WIDTH-1:0] o_device, o_address;

reg [`DATA_WIDTH-1:0] reg_device;
reg [3:0] state;

reg [3:0] next_state;
reg o_target_device_flag;
// state-- 0:fetch device ID
always @(posedge clk) begin
    if (!rst_n) begin
        reg_device <= `DATA_WIDTH'h0;
    end else begin
        reg_device <= state ? reg_device : i_ir;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        state <= `LIDLE;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        `LIDLE: begin
            next_state = `LSOURCE_DEVICE;
        end
        `LSOURCE_DEVICE: begin
            next_state = `LSOURCE_ADDRESS;
        end
        `LSOURCE_ADDRESS: begin
            next_state = `LTARGET_DEVICE;
        end
        `LTARGET_DEVICE: begin
            next_state = `LTARGET_ADDRESS;
        end
        `LTARGET_ADDRESS: begin
            next_state = `LIDLE;
        end
        default: begin
            next_state = `LIDLE;
        end
    endcase
end

always @(*) begin
    case (state)
        `LTARGET_DEVICE: begin
            o_target_device_flag = 1'b1;
        end
        default: begin
            o_target_device_flag = 1'b0;
        end
    endcase
end

assign o_device = reg_device;
assign o_address = i_ir;

endmodule
