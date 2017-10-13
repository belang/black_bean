`timescale 1ns/1ps
// file name: testbench.v
// author: lianghy
// time: 2017-7-27 15:32:54

`include "define.v"

module testbench(
);
reg clk, rst_n;

wire [`DATA_WIDTH-1:0] memory_read_data;
wire [`DATA_WIDTH-1:0] memory_write_data;
wire [`DATA_WIDTH-1:0] memory_addr;
wire memory_write_enable;
wire memory_read_enable;

regfile memory(
    .clk (clk),
    .rst_n (rst_n),
    .i_data (memory_write_data),
    .i_address (memory_addr),
    .i_write_en (memory_write_enable),
    .o_data (memory_read_data)
);

black_bean black_bean_0(
    .clk			(clk),
    .rst_n			(rst_n),
    .IO_MEM_R_DATA			(memory_read_data),
    .IO_MEM_W_DATA			(memory_write_data),
    .IO_MEM_ADDR			(memory_addr),
    .IO_MEM_R_EN			(),
    .IO_MEM_W_EN			(memory_write_enable)
);

always #5 clk = !clk;

initial begin
    $readmemh("test_case/tc_1.bmh", memory.reg_stored_data);
    clk = 1'b0;
    rst_n = 1'b0;
    #22 rst_n = 1'b1;
    #10000 $finish;
end

endmodule
