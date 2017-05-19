`timescale 1ns/1ps
// file name: adder.v
// author: lianghy
// time: 2017-3-13 11:20:36

`include "define.v"

module adder (
clk,
rst_n,
i_data,
i_port,
o_data
);
input clk,rst_n;
input [`DATA_WIDTH-1:0] i_data, i_port;
output [`DATA_WIDTH-1:0] o_data;

wire en_add_data1, en_add_data2, en_add_datao;
wire en_minus_data1, en_minus_data2, en_minus_datao;
wire [`DATA_WIDTH-1:0] add_result;
wire carry;

reg [`DATA_WIDTH-1:0] reg_data_1, reg_data_2, reg_o_data;

assign en_add_data1 = i_port==`PORT_ADDED_DATA;
assign en_add_data2 = i_port==`PORT_ADD_DATA;
assign en_add_datao = i_port==`PORT_ADD_RESULT;
assign en_add_carry = i_port==`PORT_ADD_CARRY;
assign en_minus_data1 = i_port==`PORT_MINUSED_DATA;
assign en_minus_data2 = i_port==`PORT_MINUS_DATA;
assign en_minus_datao = i_port==`PORT_MINUS_RESULT;
assign en_minus_carry = i_port==`PORT_MINUS_CARRY;
assign op = !(en_add_data1 | en_add_data2 | en_add_datao | en_add_carry) && 
    (en_minus_data1 | en_minus_data2 | en_minus_datao | en_minus_carry);

assign o_data = reg_o_data;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_data_1 <= `DATA_WIDTH'h0;
        reg_data_2 <= `DATA_WIDTH'h0;
        reg_o_data <= `DATA_WIDTH'h0;
    end else begin
        if (en_add_data1 | en_minus_data1) begin
            reg_data_1 <= i_data;
        end else begin
            reg_data_1 <= reg_data_1;
        end
        if (en_add_data2 | en_minus_data2) begin
            reg_data_2 <= i_data;
        end else begin
            reg_data_2 <= reg_data_2;
        end
        if (en_add_datao | en_minus_datao) begin
            reg_o_data <= add_result;
        end else if (en_add_datac | en_minus_datac) begin
            reg_o_data <= {`DATA_WIDTH-1'h0,carry};
        end else begin
            reg_o_data <= `DATA_WIDTH'h0;
        end
    end
end

adder_logic adder_logic(
.clk (clk),
.rst_n (rst_n),
.i_data1 (reg_data_1),
.i_data2 (reg_data_2),
.op (op),
.o_data (add_result),
.carry (carry),
);
endmodule

module adder_logic(
clk,
rst_n,
i_data1,
i_data2,
op,
o_data,
carry
);
input clk;
input rst_n;
input [`DATA_WIDTH-1:0] i_data1;
input [`DATA_WIDTH-1:0] i_data2;
input op;
output [`DATA_WIDTH-1:0] o_data;
output carry;

reg [`DATA_WIDTH-1:0] reg_i_data1, reg_i_data2;
wire [`DATA_WIDTH-1:0] complement_i_data2;
wire in1_en, in2_en, op_en;

assign complement_i_data2 = ~reg_i_data2+`DATA_WIDTH'b1;
assign {carry, o_data} = op ? (reg_i_data1+complement_i_data2) :
    (reg_i_data1+reg_i_data2);

endmodule
