`timescale 1ns/1ps
// file name: counter_parameter.v
// author: lianghy
// time: 2017-4-12 14:18:39
/*
    set is prior to count_en
*/

module counter_parameter(
    clk,
    rst_n,
    i_set_en,
    i_count_en,
    i_data,
    number
);

parameter width = 8;

input clk;
input rst_n;
input i_set_en;
input i_count_en;
input [width-1:0] i_data;
output [width-1:0] number;

reg [width-1:0] reg_counter;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_counter <= 0;
    end else if (i_set_en) begin
        reg_counter <= i_data;
        end else if (i_count_en) begin
            reg_counter <= reg_counter+1;
    end
end

assign number = reg_counter;
endmodule
