`timescale 1ns/1ps
// file name: interface.v
// author: lianghy
// time: 2018/1/11 14:24:49

`include "define.v"

module interface(
    clk,
    rst_n,
    clk_p2,
    device_port0,
    device_port1,
    device_port2,
    addr_bus,
    data_bus_in,
    data_bus_out
);

input  clk, rst_n, clk_p2;
input  [`DATA_WIDTH-1:0] device_port0;
inout  [`DATA_WIDTH-1:0] device_port1, device_port2;
input  [`DATA_WIDTH-1:0] addr_bus;
input  [`DATA_WIDTH-1:0] data_bus_in;
output [`DATA_WIDTH-1:0] data_bus_out;

reg  [`DATA_WIDTH-1:0] latched_port0, latched_port1, latched_port2, reg_port_addr, reg_port_data;

wire [`DATA_WIDTH-1:0] device_value;
wire ren, wen;

assign ren = addr_bus[7:4]==`PD;
assign wen = addr_bus[3:0]==`PD;

assign device_value = (reg_port_addr==`PORT0) ? latched_port0 :
                      (reg_port_addr==`PORT1) ? latched_port1 :
                      (reg_port_addr==`PORT2) ? latched_port2 :
                      `DATA_WIDTH'h00;
//assign device_port0 = (addr_bus[3:0]==`PD) ? device_value : `DATA_WIDTH'hz;
// write to device
assign device_port1 = ((addr_bus[3:0]==`PD)&&(reg_port_addr==`PORT1) ? latched_port1 : `DATA_WIDTH'b0;
assign device_port2 = ((addr_bus[3:0]==`PD)&&(reg_port_addr==`PORT2) ? latched_port2 : `DATA_WIDTH'b0;
// read from device
assign data_bus_out = (addr_bus[7:4]==`PD) ? device_value :
                      (addr_bus[7:4]==`PA) ? reg_port_addr :
                      `DATA_WIDTH'b0;

// interface
always @(posedge clk) begin
    if (!rst_n) begin
        reg_port_addr <= `DATA_WIDTH'h00;
        reg_port_data <= `DATA_WIDTH'h00;
    end
    else begin
        reg_port_addr <= (addr_bus[3:0]==`PA) ? data_bus_in : reg_port_addr;
        reg_port_data <= (addr_bus[3:0]==`PD) ? data_bus_in : reg_port_data;
    end
end

// port 0
always @(posedge clk) begin
    if (!rst_n) begin
        latched_port0 <= `DATA_WIDTH'h00;
    end
    else begin
        latched_port0 <= device_port0;
    end
end

// port 1
always @(posedge clk) begin
    if (!rst_n) begin
        latched_port1 <= `DATA_WIDTH'h00;
    end
    else if (ren) begin
        latched_port1 <= device_port1;
    end
end

// port 2
always @(posedge clk_p2) begin
    latched_port2 <= device_port2;
end

endmodule
