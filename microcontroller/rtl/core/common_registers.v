`timescale 1ns/1ps
// file name: common_registers.v
// author: lianghy
// time: 2018/1/11 15:02:50

`include "define.v"

module common_registers(
    clk,
    rst_n,
    addr_bus,
    data_bus_in,
    data_bus_out,
    dr0,
    dr1,
    cr
);

input  clk, rst_n;
input  [`DATA_WIDTH-1:0] addr_bus;
input  [`DATA_WIDTH-1:0] data_bus_in;
output [`DATA_WIDTH-1:0] data_bus_out;
output [`DATA_WIDTH-1:0] dr0, dr1, cr;

reg [`DATA_WIDTH-1:0] reg_DR0, reg_DR1, reg_DR2, reg_DR3;
reg [`DATA_WIDTH-1:0] reg_CR;

assign data_bus_out = (addr_bus[7:4]==`DR0) ? reg_DR0 :
                  (addr_bus[7:4]==`DR1) ? reg_DR1 :
                  (addr_bus[7:4]==`DR2) ? reg_DR2 :
                  (addr_bus[7:4]==`DR3) ? reg_DR3 :
                  (addr_bus[7:4]==`CR)  ? reg_CR  : `DATA_WIDTH'b0;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_DR0 <= `DATA_WIDTH'h00;
        reg_DR1 <= `DATA_WIDTH'h00;
        reg_DR2 <= `DATA_WIDTH'h00;
        reg_DR3 <= `DATA_WIDTH'h00;
        reg_CR  <= `DATA_WIDTH'h00;
    end else begin
        reg_DR0 <= (addr_bus[3:0]==`DR0) ? data_bus_in : reg_DR0;
        reg_DR1 <= (addr_bus[3:0]==`DR1) ? data_bus_in : reg_DR1;
        reg_DR2 <= (addr_bus[3:0]==`DR2) ? data_bus_in : reg_DR2;
        reg_DR3 <= (addr_bus[3:0]==`DR3) ? data_bus_in : reg_DR3;
        reg_CR  <= (addr_bus[3:0]==`CR)  ? data_bus_in : reg_CR ;
    end
end

assign dr0 = reg_DR0;
assign dr1 = reg_DR1;
assign cr  = reg_CR ;
endmodule
