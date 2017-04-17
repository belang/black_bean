`timescale 1ns/1ps
// file name: counter_8bit.v
// author: lianghy
// time: 2017-4-12 14:18:39

module counter_8bit(
clk,
rst_n,
i_set,
i_data,
i_trigger,
o_number
);
input clk;
input rst_n;
input i_set;
input i_trigger;
input [7:0] i_data;
output [7:0] o_number;

reg [7:0] reg_counter;
always @(posedge clk) begin
    if (!rst_n) begin
        reg_counter <= 8'b0;
    end else if (set) begin
        reg_counter <= i_data;
    end else if (i_trigger) begin
        reg_counter <= reg_counter+8'h01;
    else begin
        reg_counter <= reg_counter;
    end
end

assign o_number = reg_counter;
endmodule
