`timescale 1ns/1ps
// file name: data_bus.v
// author: lianghy
// time: 2018/2/9 15:06:33

`include "define.v"

module data_bus(
    data_bus_left_in,
    data_bus_right_in,
    data_bus_left_out,
    data_bus_right_out,
    module_data_in,
    module_data_out
);

input [`DATA_WIDTH-1:0] data_bus_left_in, data_bus_right_in;
input [`DATA_WIDTH-1:0] data_bus_left_out, data_bus_right_out;
input [`DATA_WIDTH-1:0] module_data_in;
output [`DATA_WIDTH-1:0] module_data_out;

assign module_data_out = data_bus_right_out | data_bus_left_out;
assign data_bus_left_out = module_data_in | data_bus_left_in;
assign data_bus_right_out = module_data_in | data_bus_right_in;
endmodule
