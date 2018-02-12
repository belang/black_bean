`timescale 1ns/1ps
// file name: bean_mc_top.v
// author: lianghy
// time: 2017-5-17 10:21:01

`include "define.v"

module bean_mc_top(
    ref_clk,
    chip_rst_n,
    IO_CLK_P2,
    IO_P0,
    IO_P1,
    IO_P2
);

input ref_clk, chip_rst_n;
input IO_CLK_P2;
input [`DATA_WIDTH-1:0]  IO_P0;
inout [`DATA_WIDTH-1:0]  IO_P1;
inout [`DATA_WIDTH-1:0]  IO_P2;

wire clk, rst_n;
wire [`DATA_WIDTH-1:0] controller_data_out, controller_data_in, core_data_out, core_data_in, interface_data_out, interface_data_in;
wire [`DATA_WIDTH-1:0] data_bus_inner_right_0, data_bus_inner_left_0;
wire [`DATA_WIDTH-1:0] data_bus_inner_right_1, data_bus_inner_left_1;
wire [`DATA_WIDTH-1:0] data_bus_inner_right_2, data_bus_inner_left_2;
wire [`DATA_WIDTH-1:0] data_bus_inner_right_3, data_bus_inner_left_3;
wire [`DATA_WIDTH-1:0] addr_bus;
wire [`DATA_WIDTH-1:0] re;

assign data_bus_inner_left_3 = `DATA_WIDTH'h0;
assign data_bus_inner_right_0 = `DATA_WIDTH'h0;

controller controller0(
    .ref_clk       (ref_clk),
    .chip_rst_n    (chip_rst_n),
    .clk           (clk),
    .rst_n         (rst_n),
    .interrupt     (IO_P0),
    .re            (re),
    .addr_bus      (addr_bus),
    .data_bus_in   (controller_data_in),
    .data_bus_out  (controller_data_out)
);

core core0(
    .clk         (clk),
    .rst_n       (rst_n),
    .addr_bus    (addr_bus),
    .data_bus_in   (core_data_in),
    .data_bus_out  (core_data_out),
    .re          (re)
);

interface interface0(
    .clk             (clk),
    .rst_n           (rst_n),
    .clk_p2          (IO_CLK_P2),
    .device_port0    (IO_P0),
    .device_port1    (IO_P1),
    .device_port2    (IO_P2),
    .addr_bus        (addr_bus),
    .data_bus_in     (interface_data_in),
    .data_bus_out    (interface_data_out)
);

data_bus data_bus_controller_0(
    .data_bus_left_in      (data_bus_inner_left_1),
    .data_bus_right_in     (data_bus_inner_right_0),
    .data_bus_left_out     (data_bus_inner_left_0),
    .data_bus_right_out    (data_bus_inner_right_1),
    .module_data_in        (controller_data_out),
    .module_data_out        (controller_data_in)
);

data_bus data_bus_core_0(
    .data_bus_left_in      (data_bus_inner_left_2),
    .data_bus_right_in     (data_bus_inner_right_1),
    .data_bus_left_out     (data_bus_inner_left_1),
    .data_bus_right_out    (data_bus_inner_right_2),
    .module_data_in        (core_data_out),
    .module_data_out        (core_data_in)
);

data_bus data_bus_interface_0(
    .data_bus_left_in      (data_bus_inner_left_3),
    .data_bus_right_in     (data_bus_inner_right_2),
    .data_bus_left_out     (data_bus_inner_left_2),
    .data_bus_right_out    (data_bus_inner_right_3),
    .module_data_in        (interface_data_out),
    .module_data_out        (interface_data_in)
);

endmodule
