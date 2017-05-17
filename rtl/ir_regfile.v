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
);
input clk, rst_n;

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
.data_out (data_out),
);
endmodule

`DEVICE_
`DEVICE_OUT_DEVICE
`

module regfile_ir(
input clk,
input rst_n,
input [`IRR_WIDTH-1:0] data_in,
input [`IR_ADDR_WIDTH-1:0] address,
input mode,
output [`IRR_WIDTH-1:0] data_out
);

reg reg_mode;
reg [`IR_ADDR_WIDTH-1:0] reg_address ;
reg [`IRR_WIDTH-1:0] reg_input_data   ;
reg [`IRR_WIDTH-1:0] reg_output_data  ;

reg [`IRR_WIDTH-1:0] reg_stored_data[2**`IR_ADDR_WIDTH-1:0];

// wire
reg [`IRR_WIDTH-1:0] readed_data[2**`IR_ADDR_WIDTH-1:0];
reg inner_current_line_pointer[2**`IR_ADDR_WIDTH-1:0];
//wire [`IRR_WIDTH-1:0] readed_data_or;

// input 
always @(posedge clk) begin
    if (!rst_n) begin
        reg_mode <= 1'b0;
        reg_address       <= `IRR_WIDTH'b0      ;
        reg_input_data    <= `IRR_WIDTH'b0    ;
        //reg_output_data   <= `IRR_WIDTH'b0   ;
    end else begin
        reg_mode <= state_control;
        reg_address       <= address      ;
        reg_input_data    <= input_data    ;
        //reg_output_data   <= readed_data_or   ;
    end
end

//store data
integer i,j;
always @(posedge clk) begin
    if (reg_mode) begin
        for (i=0;i<2**`IR_ADDR_WIDTH;i=i+1) begin
            reg_stored_data[i] <= inner_current_line_pointer[i] ? reg_input_data:reg_stored_data[i];
        end
    end 
end


//read data
always @(*) begin
    for (i=0;i<2**`IR_ADDR_WIDTH-1;i=i+1) begin
        readed_data[i] =  inner_current_line_pointer[i]? reg_stored_data[i]:`IRR_WIDTH'b0;
    end
end

//decoder
always @(*) begin
    for (j=0;j<2**`IR_ADDR_WIDTH;j=j+1) begin
        inner_current_line_pointer[j] = reg_address[`IRR_WIDTH-1]==j ;
    end
end

assign data_out = |readed_data;


endmodule
