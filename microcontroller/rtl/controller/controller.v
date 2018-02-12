`timescale 1ns/1ps
// file name: controller.v
// author: lianghy
// time: 2018/1/4 10:47:00

`include "define.v"

module controller(
    ref_clk,
    chip_rst_n,
    clk,
    rst_n,
    interrupt,
    re,
    addr_bus,
    data_bus_in,
    data_bus_out
);

input  ref_clk, chip_rst_n;
output clk, rst_n;
input  [`DATA_WIDTH-1:0] interrupt;
input  [`DATA_WIDTH-1:0] re;
output [`IR_WIDTH-1:0] addr_bus;
input [`DATA_WIDTH-1:0] data_bus_in;
output [`DATA_WIDTH-1:0] data_bus_out;

wire [`IR_WIDTH-1:0] instructor;
wire [`ROM_ADDR_WIDTH-1:0] rom_addr;
wire clk, rst_n;

decoder decoder_0(
    .ref_clk        (ref_clk),
    .chip_rst_n     (chip_rst_n),
    .core_clock     (clk),
    .core_rst_n     (rst_n),
    .instructor     (instructor),
    .interrupt      (interrupt),
    .addr_bus       (addr_bus),
    .data_bus_out   (data_bus_out)
);

pc pc_0(
    .clk         (clk),
    .rst_n       (rst_n),
    .addr_bus    (addr_bus),
    .data_bus_in (data_bus_in),
    .re          (re),
    .rom_addr     (rom_addr)
);

rom ROM0(
    .clk          (clk),
    .rst_n        (rst_n),
    .addr_bus     (addr_bus),
    .rom_addr     (rom_addr),
    .data_bus_in  (data_bus_in),
    .instructor    (instructor)
);

endmodule
