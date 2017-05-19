`timescale 1ns/1ps
// file name: fetch.v
// author: lianghy
// time: 2017-5-12 11:03:42

`include "define.v"

module fetch(
    clk,
    rst_n,
    .ir (ir),
    .o_target_device_flag,
    .o_device,
    .o_address
);
input clk, rst_n;
input  [`DATA_WIDTH-1:0] ir;
output o_target_device_flag;
output [`DATA_WIDTH-1:0] o_device, o_address;

reg [`DATA_WIDTH-1:0] reg_device;
reg state;

reg nex_state;
// state-- 0:fetch device ID
always @(posedge clk) begin
    if (!rst_n) begin
        reg_device <= `DATA_WIDTH'h0;
    end else begin
        reg_device <= state ? reg_device : ir;
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
assign o_address = ir;

endmodule
