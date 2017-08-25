`timescale 1ns/1ps
// file name: regfile.v
// author: lianghy
// time: 2017-05-19

`include "define.v"

module regfile(
    clk,
    rst_n,
    i_data,
    i_address,
    i_write_en,
    o_data
);
input clk;
input rst_n;
input [`DATA_WIDTH-1:0] i_data;
input [`DATA_ADDR_WIDTH-1:0] i_address;
input i_write_en;
output [`DATA_WIDTH-1:0] o_data;

reg [`DATA_ADDR_WIDTH-1:0] reg_address ;
reg [`DATA_WIDTH-1:0] reg_i_data   ;
reg [`DATA_WIDTH-1:0] reg_output_data  ;

reg [`DATA_WIDTH-1:0] reg_stored_data[2**(`DATA_ADDR_WIDTH-1):0];

// wire
reg [`DATA_WIDTH-1:0] readed_data[2**(`DATA_ADDR_WIDTH-1):0];
reg [`DATA_WIDTH-1:0] o_data_l1[2**(`DATA_ADDR_WIDTH-2):0];
reg [`DATA_WIDTH-1:0] o_data_l2[2**(`DATA_ADDR_WIDTH-4):0];
reg [`DATA_WIDTH-1:0] o_data_l3[2**(`DATA_ADDR_WIDTH-6):0];
reg inner_current_line_pointer[2**(`DATA_ADDR_WIDTH-1):0];
//wire [`DATA_WIDTH-1:0] readed_data_or;

// input 
always @(posedge clk) begin
    if (!rst_n) begin
        reg_address       <= `DATA_WIDTH'b0      ;
        reg_i_data    <= `DATA_WIDTH'b0    ;
        //reg_output_data   <= `DATA_WIDTH'b0   ;
    end else begin
        reg_address       <= i_address      ;
        reg_i_data    <= i_data    ;
        //reg_output_data   <= readed_data_or   ;
    end
end

//store data
integer i,j;
always @(posedge clk) begin
    if (i_write_en) begin
        for (i=0;i<2**`DATA_ADDR_WIDTH;i=i+1) begin
            reg_stored_data[i] <= inner_current_line_pointer[i] ? reg_i_data:reg_stored_data[i];
        end
    end 
end

//decoder
always @(*) begin
    for (j=0;j<2**`DATA_ADDR_WIDTH;j=j+1) begin
        inner_current_line_pointer[j] = reg_address[`DATA_WIDTH-1]==j ;
    end
end


assign o_data = reg_stored_data[reg_address];
endmodule
