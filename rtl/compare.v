`timescale 1ns/1ps
// file name: compare.v
// author: lianghy
// time: 2017-5-8 16:31:33

`include "define.v"

module compare(
clk,
rst_n,
i_data,
i_port,
o_data
);
input clk,rst_n;
input [`DATA_WIDTH-1:0] i_data, i_port;
output [`DATA_WIDTH-1:0] o_data;

wire en_data1, en_data2, en_datao;
wire compare_result;

reg [`DATA_WIDTH-1:0] reg_data_1, reg_data_2, reg_data_o;

assign en_data1 = i_port==`PORT_COMPARE_DATA;
assign en_data2 = i_port==`PORT_COMPARED_DATA;
assign en_datao = i_port==`PORT_COMPARE_RESULT;

assign o_data = reg_data_o;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_data_1 <= `DATA_WIDTH'h0;
        reg_data_2 <= `DATA_WIDTH'h0;
        reg_data_o <= `DATA_WIDTH'h0;
    end else begin
        if (en_data1) begin
            reg_data_1 <= i_data;
        end else begin
            reg_data_1 <= reg_data_1;
        end
        if (en_data2) begin
            reg_data_2 <= i_data;
        end else begin
            reg_data_2 <= reg_data_2;
        end
        if (en_datao) begin
            reg_data_o <= compare_result;
        end else begin
            reg_data_o <= `DATA_WIDTH'h0;
        end
    end
end

compare_logic compare_logic_0(
.clk (clk),
.i_data1 (reg_data_1),
.i_data2 (reg_data_2),
.o_data (compare_result)
);
endmodule

module compare_logic(
clk,
i_data1,
i_data2,
o_data
);
input clk,rst_n;
input [`DATA_WIDTH-1:0] i_data1, i_data2;
output [`DATA_WIDTH-1:0] o_data;

// result: 01--1>2; 02--1<2; 03--1=2;
assign o_data = i_data1 > i_data2 ? `DATA_WIDTH'h01 :
        i_data1 < i_data2 ? `DATA_WIDTH'h02 : `DATA_WIDTH'h03;
endmodule
