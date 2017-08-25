`timescale 1ns/1ps
// file name: counter_8bit.v
// author: lianghy
// time: 2017-4-12 14:18:39

module counter_8bit(
    clk,
    rst_n,
    i_set,
    i_count_en,
    i_data,
    number
);
input clk;
input rst_n;
input i_set;
input i_count_en;
input [7:0] i_data;
output [7:0] number;

reg [7:0] reg_counter;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_counter <= 8'b0;
    end else if (i_set) begin
        reg_counter <= i_data;
        end else if (i_count_en) begin
            reg_counter <= reg_counter+8'h01;
    end
end

assign number = reg_counter;
endmodule
