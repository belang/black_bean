`timescale 1ns/1ps
// file name: counter_8bit.v
// author: lianghy
// time: 2017-4-12 14:18:39

module counter_8bit(
clk,
rst_n,
set,
data_in,
number
);
input clk;
input rst_n;
input set;
input [7:0] data_in;
output [7:0] number;

reg [7:0] reg_counter;
always @(posedge clk) begin
    if (!rst_n) begin
        reg_counter <= 8'b0;
    end else if (set) begin
        reg_counter <= data_in;
        end else if (trigger) begin
            reg_counter <= reg_counter+8'h01;
    end
end

assign number = reg_counter;
endmodule
