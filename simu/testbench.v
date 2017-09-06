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
wire [`DATA_WIDTH-1:0] memory_address, mem_r_addr, mem_w_addr;
wire memory_write_enable;
wire memory_read_enable;

assign memory_address = memory_read_enable ? mem_r_addr : 
        memory_write_enable ? mem_w_addr : `DATA_WIDTH'h00 ;

regfile memory(
    .clk (clk),
    .rst_n (rst_n),
    .i_data (memory_write_data),
    .i_address (memory_address),
    .i_write_en (memory_write_enable),
    .o_data (memory_read_data)
);

black_bean black_bean_0(
    .clk (clk),
    .rst_n (rst_n),
    .mem_r_data (memory_read_data),
    .mem_r_addr (mem_r_addr),
    .mem_w_data (memory_write_data),
    .mem_w_addr (mem_w_addr),
    .mem_r_en (memory_read_enable),
    .mem_w_en (memory_write_enable)
);

always #5 clk = !clk;

initial begin
    $readmemb("test_case/test_case3.bmb", memory.reg_stored_data);
    clk = 1'b0;
    rst_n = 1'b0;
    #22 rst_n = 1'b1;
    #10000 $finish;
end

endmodule
