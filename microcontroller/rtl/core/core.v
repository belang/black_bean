`timescale 1ns/1ps
// file name: core.v
// author: lianghy
// time: 2018/1/8 16:19:19

`include "define.v"

module core(
    clk,
    rst_n,
    addr_bus,
    data_bus_in,
    data_bus_out,
    re
);

input  clk, rst_n;
input  [`DATA_WIDTH-1:0] addr_bus;
input  [`DATA_WIDTH-1:0] data_bus_in;
output [`DATA_WIDTH-1:0] data_bus_out;
output [`DATA_WIDTH-1:0] re;

wire  [`DATA_WIDTH-1:0] op0, op1, cr;
wire  [`ROM_ADDR_WIDTH-1:0] ram_addr;
wire [`DATA_WIDTH-1:0] data_out_alu0, data_out_cr0, data_out_ram0, data_out_ar_0;

assign data_bus_out = data_out_alu0 | data_out_cr0 | data_out_ram0 | data_out_ar_0;

alu ALU0(
    .clk         (clk),
    .rst_n       (rst_n),
    .op0         (op0),
    .op1         (op1),
    .cr          (cr),
    .addr_bus    (addr_bus),
    .data_bus_out    (data_out_alu0),
    .alu_re      (re)
);

common_registers common_registers0(
    .clk         (clk),
    .rst_n       (rst_n),
    .addr_bus    (addr_bus),
    .data_bus_in    (data_bus_in),
    .data_bus_out    (data_out_cr0),
    .dr0         (op0),
    .dr1         (op1),
    .cr           (cr)
);

ar ar_0(
    .clk         (clk),
    .rst_n       (rst_n),
    .addr_bus    (addr_bus),
    .data_bus_in    (data_bus_in),
    .data_bus_out    (data_out_ar_0),
    .ram_addr    (ram_addr)
);

ram RAM0(
    .clk         (clk),
    .rst_n       (rst_n),
    .addr_bus    (addr_bus),
    .ram_addr    (ram_addr),
    .data_bus_in    (data_bus_in),
    .data_bus_out    (data_out_ram0)
);

endmodule
