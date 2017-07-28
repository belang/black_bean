`timescale 1ns/1ps
// file name: decoder.v
// author: lianghy
// time: 2017-7-25 17:08:55

`include "define.v"

module decoder(
    clk,
    rst_n,
    i_ir,
    o_memory_address_source,
    o_memory_read_enable,
    o_memory_write_enable,
    o_hold_ip_flag,
    o_reset_ip,
    o_select_jump_address,
    o_ir_enable,
    o_raw_bus_0_wen,
    o_raw_bus_1_wen,
    o_raw_bus_0_ren,
    o_raw_bus_1_ren
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_ir;

output o_memory_address_source  ;
output o_memory_read_enable     ;
output o_memory_write_enable    ;
output o_hold_ip_flag           ;
output o_reset_ip               ;
output o_select_jump_address    ;
output o_ir_enable              ;
output o_raw_bus_0_wen          ;
output o_raw_bus_1_wen          ;
output o_raw_bus_0_ren          ;
output o_raw_bus_1_ren          ;

//(module)_output_enable ;
reg o_memory_address_source  ;
reg o_memory_read_enable     ;
reg o_memory_write_enable    ;
reg o_hold_ip_flag           ;
reg o_reset_ip               ;
reg o_select_jump_address    ;
reg o_ir_enable              ;
reg o_raw_bus_0_ren          ;
reg o_raw_bus_1_ren          ;
reg o_raw_bus_0_wen          ;
reg o_raw_bus_1_wen          ;

reg [`DATA_WIDTH-1:0] reg_ir;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_ir <= `DATA_WIDTH'h00;
    end else begin
        reg_ir <= i_ir;
    end
end

always @(reg_ir) begin
    case (reg_ir)
        `RESET: begin
            o_memory_address_source = 1'b0  ;
            o_memory_read_enable    = 1'b0  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b0  ;
            o_reset_ip              = 1'b1  ;
            o_select_jump_address   = 1'b0  ;
            o_ir_enable             = 1'b0  ;
            o_raw_bus_0_ren         = 1'b0  ;
            o_raw_bus_1_ren         = 1'b0  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
        `CONTINUE: begin
            o_memory_address_source = 1'b0  ;
            o_memory_read_enable    = 1'b1  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b0  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b0  ;
            o_ir_enable             = 1'b1  ;
            o_raw_bus_0_ren         = 1'b0  ;
            o_raw_bus_1_ren         = 1'b0  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
        `EMPTY: begin
            o_memory_address_source = 1'b0  ;
            o_memory_read_enable    = 1'b0  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b1  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b0  ;
            o_ir_enable             = 1'b0  ;
            o_raw_bus_0_ren         = 1'b0  ;
            o_raw_bus_1_ren         = 1'b0  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
        `RAW_BUS_0: begin
            o_memory_address_source = 1'b0  ;
            o_memory_read_enable    = 1'b1  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b0  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b0  ;
            o_ir_enable             = 1'b0  ;
            o_raw_bus_0_ren         = 1'b1  ;
            o_raw_bus_1_ren         = 1'b0  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
        `RAW_BUS_1: begin
            o_memory_address_source = 1'b0  ;
            o_memory_read_enable    = 1'b1  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b0  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b0  ;
            o_ir_enable             = 1'b0  ;
            o_raw_bus_0_ren         = 1'b0  ;
            o_raw_bus_1_ren         = 1'b1  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
        `OPERAND_W_ADDR: begin
            o_memory_address_source = 1'b1  ;
            o_memory_read_enable    = 1'b0  ;
            o_memory_write_enable   = 1'b1  ;
            o_hold_ip_flag          = 1'b0  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b0  ;
            o_ir_enable             = 1'b1  ;
            o_raw_bus_0_ren         = 1'b0  ;
            o_raw_bus_1_ren         = 1'b0  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
        `OPERAND_R_BUS_0: begin
            o_memory_address_source = 1'b1  ;
            o_memory_read_enable    = 1'b1  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b1  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b0  ;
            o_ir_enable             = 1'b1  ;
            o_raw_bus_0_ren         = 1'b0  ;
            o_raw_bus_1_ren         = 1'b0  ;
            o_raw_bus_0_wen         = 1'b1  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
        `OPERAND_R_BUS_1: begin
            o_memory_address_source = 1'b1  ;
            o_memory_read_enable    = 1'b1  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b1  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b0  ;
            o_ir_enable             = 1'b1  ;
            o_raw_bus_0_ren         = 1'b0  ;
            o_raw_bus_1_ren         = 1'b0  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b1  ;
        end
        `TRANSFER_ADDR: begin
            o_memory_address_source = 1'b1  ;
            o_memory_read_enable    = 1'b1  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b0  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b0  ;
            o_ir_enable             = 1'b1  ;
            o_raw_bus_0_ren         = 1'b0  ;
            o_raw_bus_1_ren         = 1'b0  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
        `TRANSFER_CONDITION: begin
            o_memory_address_source = 1'b0  ;
            o_memory_read_enable    = 1'b1  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b0  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b1  ;
            o_ir_enable             = 1'b1  ;
            o_raw_bus_0_ren         = 1'b0  ;
            o_raw_bus_1_ren         = 1'b0  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
        `STORE_RAW_BUS_0: begin
            o_memory_address_source = 1'b0  ;
            o_memory_read_enable    = 1'b1  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b0  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b1  ;
            o_ir_enable             = 1'b1  ;
            o_raw_bus_0_ren         = 1'b1  ;
            o_raw_bus_1_ren         = 1'b0  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
        `STORE_RAW_BUS_1: begin
            o_memory_address_source = 1'b0  ;
            o_memory_read_enable    = 1'b1  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b0  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b1  ;
            o_ir_enable             = 1'b1  ;
            o_raw_bus_0_ren         = 1'b0  ;
            o_raw_bus_1_ren         = 1'b1  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
        default: begin
            o_memory_address_source = 1'b0  ;
            o_memory_read_enable    = 1'b1  ;
            o_memory_write_enable   = 1'b0  ;
            o_hold_ip_flag          = 1'b0  ;
            o_reset_ip              = 1'b0  ;
            o_select_jump_address   = 1'b0  ;
            o_ir_enable             = 1'b1  ;
            o_raw_bus_0_ren         = 1'b0  ;
            o_raw_bus_1_ren         = 1'b0  ;
            o_raw_bus_0_wen         = 1'b0  ;
            o_raw_bus_1_wen         = 1'b0  ;
        end
    endcase
end

endmodule
