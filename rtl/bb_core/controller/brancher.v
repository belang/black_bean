`timescale 1ns/1ps
// file name: brancher.v
// author: lianghy
// time: 2017-9-27 14:54:32

`include "../../define.v"
`define SMALLER     8'h01
`define EQUAL       8'h02
`define LARGER      8'h03
`define NSMALLER    8'h04
`define NEQUAL      8'h05
`define NLARGER     8'h06

module brancher(
    clk,
    rst_n,
    i_program_count,
    i_address_reg,
    i_operand0,
    i_operand1,
    i_config_reg,
    o_branch_addr
);

input  clk, rst_n;
input [`DATA_WIDTH-1:0] i_program_count, i_address_reg, i_operand0, i_operand1, i_config_reg;
output [`DATA_WIDTH-1:0] o_branch_addr;

reg [`DATA_WIDTH-1:0] o_branch_addr;

always @(clk) begin
    case (i_config_reg)
        `SMALLER: begin
            o_branch_addr = (i_operand0< i_operand1) ? i_program_count:i_address_reg;
        end                                                                         
        `EQUAL: begin                                                               
            o_branch_addr = (i_operand0==i_operand1) ? i_program_count:i_address_reg;
        end                                                                         
        `LARGER: begin                                                              
            o_branch_addr = (i_operand0> i_operand1) ? i_program_count:i_address_reg;
        end                                                                         
        `NSMALLER: begin                                                            
            o_branch_addr = !(i_operand0<i_operand1) ? i_program_count:i_address_reg;
        end                                                                         
        `NEQUAL: begin                                                              
            o_branch_addr = (i_operand0!=i_operand1) ? i_program_count:i_address_reg;
        end                                                                         
        `NLARGER: begin                                                             
            o_branch_addr = !(i_operand0>i_operand1) ? i_program_count:i_address_reg;
        end
        default: begin
            o_branch_addr = i_program_count;
        end
    endcase
end
endmodule
