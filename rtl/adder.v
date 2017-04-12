`timescale 1ns/1ps
// file name: adder.v
// author: lianghy
// time: 2017-3-13 11:20:36

`include "define.v"

module adder(
input clk,
input rst_n,
input [`DATA_WIDTH-1:0] data_in1,
input [`DATA_WIDTH-1:0] data_in2,
input op,
input [1:0] wen,
output [`DATA_WIDTH-1:0] data_o,
output carry
);

reg [`DATA_WIDTH-1:0] reg_data_in1, reg_data_in2;
wire [`DATA_WIDTH-1:0] complement_data_in2;
wire in1_en, in2_en, op_en;

assign in1_en = wen==2'b01;
assign in2_en = wen==2'b10;
assign op_en = wen==2'b11;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_data_in1 <= `DATA_WIDTH'b0;
    end else if (in1_en) begin
        reg_data_in1 <= data_in1;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        reg_data_in2 <= `DATA_WIDTH'b0;
    end else if (in2_en) begin
        reg_data_in2 <= data_in2;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        reg_op <= `DATA_WIDTH'b0;
    end else if (op_en) begin
        reg_op <= op;
    end
end

assign complement_data_in2 = ~reg_data_in2+`DATA_WIDTH'b1;
assign {carry, data_o} = op ? (reg_data_in1+complement_data_in2) :
    (reg_data_in1+reg_data_in2);

endmodule
