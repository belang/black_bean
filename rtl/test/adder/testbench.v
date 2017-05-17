`timescale 1ns/1ps
// file name: testbench.v
// author: lianghy
// time: 2017-3-31 15:54:52

module testbench(
);
reg clk, rst_n;

reg [7:0] test_data [7:0];
//reg [7:0] tc1_d1, tc1_d2, tc1_r1;
//reg [7:0] tc2_d1, tc2_d2, tc2_d3, tc2_d4, tc2_r1, tc2_r2, tc2_r3;

initial begin
    clk = 0
    rst_n = 1
    #11 rst_n = 0
    #11 rst_n = 1
end
initial begin
    $readmemb("test_case1.list", test_data);
    #24 data_bus = test_data[0]
    
end
    tc1_d1 = 8'b00110100;
    tc1_d2 = 8'b00110001;
    tc1_r1 = 8'b00110101;
    tc2_d1 = 8'b00110001;
    tc2_d2 = 8'b00110101;
    tc2_d3 = 8'b00110111;
    tc2_d4 = 8'b00110011;
    tc2_r1 = 8'b00110001;
    tc2_r2 = 8'b00110010;
    tc2_r3 = 8'b00110100;

always #5 clk = ~clk;
endmodule
