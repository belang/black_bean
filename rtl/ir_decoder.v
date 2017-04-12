`timescale 1ns/1ps
// file name: ir_decoder.v
// author: lianghy
// time: 2017-4-11 17:08:36

`include define.h

module ir_decoder(
input clk,
input rst_n,
input [`DATA_WIDTH-1:0] data_in,
input [`IRR_WIDTH-1:0] ir,
output [`IR_ADDR_WIDTH-1:0] irp,
output [`DATA_WIDTH-1:0] data_out,
output [`CTRL_BUS-1:0] ctrl_bus
);

reg [`DATA_WIDTH-1:0] reg_data_in_l1, reg_data_in_l2;
reg [`IRR_WIDTH-1:0] reg_ir;
reg reg_init;

[`DATA_WIDTH-1:0] ir_mux;
init_signal;

// input reg
always @(posedge clk) begin
    if (!rst_n) begin
        reg_data_in_l1 <= `DATA_WIDTH'b0;
        reg_data_in_l2 <= `DATA_WIDTH'b0;
    end else begin
        reg_data_in_l1 <= data_in;
        reg_data_in_l2 <= reg_data_in_l1;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        reg_ir <= `DATA_WIDTH'b0;
    end else begin
        reg_ir <= ir_mux;
    end
end
ir_mux = reg_init ? ((reg_data_in_l1==reg_data_in_l2) ? 
                  reg_data_in_l2 : `DATA_WIDTH'b0 )
              : ir;

// state
always @(posedge clk) begin
    if (!rst_n) begin
        reg_init <= 1'b0;
    end else begin
        reg_init <= init_signal;
    end
end

endmodule
