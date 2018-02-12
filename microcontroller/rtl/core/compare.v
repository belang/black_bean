`timescale 1ns/1ps
// file name: compare.v
// author: lianghy
// time: 2018/1/8 16:21:21

`include "define.v"

module compare(
    op0,
    op1,
    relation,
    compare_result,
    compare_addition
);

input  [`DATA_WIDTH-1:0] op0, op1, relation;
output [`DATA_WIDTH-1:0] compare_result;
output [`DATA_WIDTH-1:0] compare_addition;

reg [`DATA_WIDTH-1:0] reg_compare_result;
reg compare_en;

assign compare_addition = 0;
assign compare_result = compare_en ? {7'b0, reg_compare_result[0]};

always @(op0, op1, relation) begin
    case (relation)
        `ALU_SMALLER: begin
            reg_compare_result[0] = (op0< op1);
            compare_en = 1;
        end                                         
        `ALU_EQUAL: begin                               
            reg_compare_result[0] = (op0==op1);
            compare_en = 1;
        end                                         
        `ALU_LARGER: begin                              
            reg_compare_result[0] = (op0> op1);
            compare_en = 1;
        end                                         
        `ALU_NSMALLER: begin                            
            reg_compare_result[0] = !(op0<op1);
            compare_en = 1;
        end                                         
        `ALU_NEQUAL: begin                              
            reg_compare_result[0] = (op0!=op1);
            compare_en = 1;
        end                                         
        `ALU_NLARGER: begin                             
            reg_compare_result[0] = !(op0>op1);
            compare_en = 1;
        end
        default: begin
            reg_compare_result[0] = 1'b0;
            compare_en = 0;
        end
    endcase
end
endmodule
