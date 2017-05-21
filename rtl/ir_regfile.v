`timescale 1ns/1ps
// file name: ir_regfile.v
// author: lianghy
// time: 2017-5-12 11:11:45

`include "define.v"

`define LINIT 4'h0
`define LREAD_MEM 4'h0
`define LREAD_MEM 4'h0
`define LWORK 4'h0

module ir_regfile(
    clk,
    rst_n,
    i_regfile_en,
    i_regfile_selection,
    i_read_or_write_en,
    i_device,
    i_address,
    //i_data,
    o_data
);
input clk, rst_n;
input i_regfile_en, i_regfile_selection, i_read_or_write_en;
input  [`DATA_WIDTH-1:0] i_device, i_address;
output [`DATA_WIDTH-1:0] o_data;

reg state;

wire init_finished;

// state -- 0:init
always @(clk) begin
    if (!rst_n) begin
        state <= 1'b0;
    end else begin
        state <= init_finished;
    end
end


regfile_ir regfile_ir_0(
.clk (clk),
.rst_n (rst_n),
.data_in (data_in),
.address (address),
.mode (mode),
.data_out (data_out)
);

endmodule


