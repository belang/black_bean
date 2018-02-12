`timescale 1ns/1ps
// file name: testbench.v
// author: lianghy
// time: 2017-7-27 15:32:54

`include "define.v"

//`define TESTCASE "idle"
`define TESTCASE "counter"
//`define TESTCASE "idle"

module testbench(
);
reg ref_clk, chip_rst_n;

reg IO_CLK_P2;
reg [`DATA_WIDTH-1:0] IO_P0, reg_IO_P1, reg_IO_P2;
wire [`DATA_WIDTH-1:0] IO_P1, IO_P2;

bean_mc_top bean_mc_top0(
    .ref_clk       (ref_clk),
    .chip_rst_n    (chip_rst_n),
    .IO_CLK_P2     (IO_CLK_P2),
    .IO_P0         (IO_P0),
    .IO_P1         (IO_P1),
    .IO_P2          (IO_P2)
);



always #5 ref_clk = !ref_clk;

initial begin
    $readmemh("D:/lhy/project/black_bean/microcontroller/rtl/testbench/tc.bmh", bean_mc_top0.controller0.ROM0.regfile0.reg_stored_data);
    ref_clk = 1'b0;
    chip_rst_n = 1'b0;
    #22 chip_rst_n = 1'b1;
    #10000 $finish;
end

//// test case: counter
initial begin
    if (`TESTCASE == "idle") begin
        IO_P0 = 8'h00;
    end
    else if (`TESTCASE == "counter") begin
        IO_P0 = 8'h00;
        #30 IO_P0 = 8'h81;
    end
end
//// test case: counter

wire a;
assign a = chip_rst_n ? 1'b1:1'bz;
assign a = !chip_rst_n ? 1'b0:1'bz;

endmodule
