`timescale 1ns/1ps
// file name: regfile_data.v
// author: lianghy
// time: 2017-3-13 15:01:59

`include define.h

module regfile_data(
input clk,
input rst_n,
input [`DATA_WIDTH-1:0] data_in,
input [`DATA_ADDR_WIDTH-1:0] address,
input mode,
output [`DATA_WIDTH-1:0] data_out
);

reg mode;
reg [`DATA_ADDR_WIDTH-1:0] reg_address ;
reg [`DATA_WIDTH-1:0] reg_input_data   ;
reg [`DATA_WIDTH-1:0] reg_output_data  ;

reg [`DATA_WIDTH-1:0] reg_stored_data[2**`DATA_ADDR_WIDTH-1:0];

// wire
reg [`DATA_WIDTH-1:0] readed_data[2**`DATA_ADDR_WIDTH-1:0];
reg inner_current_line_pointer[2**`DATA_ADDR_WIDTH-1:0];
//wire [`DATA_WIDTH-1:0] readed_data_or;

// input 
always @(posedge clk) begin
    if (!rst_n) begin
        mode <= 1'b0;
        reg_address       <= `DATA_WIDTH'b0      ;
        reg_input_data    <= `DATA_WIDTH'b0    ;
        //reg_output_data   <= `DATA_WIDTH'b0   ;
    end else begin
        mode <= state_control;
        reg_address       <= address      ;
        reg_input_data    <= input_data    ;
        //reg_output_data   <= readed_data_or   ;
    end
end

//store data
integer i,j;
always @(posedge clk) begin
    if (mode) begin
        for (i=0;i<2**`DATA_ADDR_WIDTH;i=i+1) begin
            reg_stored_data[i] <= inner_current_line_pointer[i] ? reg_input_data:reg_stored_data[i];
        end
    end 
end


//read data
always @(*) begin
    for (i=0;i<2**`DATA_ADDR_WIDTH-1;i=i+1) begin
        readed_data[i] =  inner_current_line_pointer[i]? reg_stored_data[i]:`DATA_WIDTH'b0;
    end
end

//decoder
always @(*) begin
    for (j=0;j<2**`DATA_ADDR_WIDTH;j=j+1) begin
        inner_current_line_pointer[j] = reg_address[`DATA_WIDTH-1]==j ;
    end
end

assign data_out = |readed_data;


endmodule
