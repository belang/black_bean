`timescale 1ns/1ps
// file name: decoder.v
// author: lianghy
// time: 2017-7-25 17:08:55

`include "define.v"

`define STATE_IDLE          5'h00
`define STATE_PAUSE         5'h01
`define STATE_READ_IR       5'h02
`define STATE_TRANS_DA      5'h03
`define STATE_WRITE         5'h04
`define STATE_SET_PC        5'h05

`define CORE_EN_NULL       16'b0000000000000000
`define CORE_EN_IR         16'b0000000000000001
`define CORE_EN_PC         16'b0000000000000010
`define CORE_EN_AR         16'b0000000000000100
`define CORE_EN_DR0        16'b0000000000001000
`define CORE_EN_DR1        16'b0000000000010000
`define CORE_EN_CR         16'b0000000000100000
//`define CORE_EN_NULL       16'b0000000001000000
`define ALU_EN_RE          16'b0000000010000000
`define ALU_EN_AD          16'b0000000100000000
//`define CORE_EN_NULL       16'b0000001000000000
//`define CORE_EN_NULL       16'b0000010000000000
`define IOSC_EN_INS_PC     16'b0000100000000000
`define IOSC_EN_INS_AR     16'b0001000000000000
`define IOSC_EN_OTH        16'b0010000000000000
`define IOSC_EN_NULL       16'b0100000000000000

module decoder(
    clk,
    rst_n,
    i_ins,
    o_unit_ien,
    o_unit_oen
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_ins;
output [15:0] o_unit_ien, o_unit_oen;
//output [15:0] o_core_ien, o_iosc_ien;
//output [15:0] o_core_oen, o_iosc_oen;

reg [4:0] reg_state;
//reg [15:0] reg_core_ien, reg_iosc_ien;

reg [4:0] next_state;
reg [3:0] unit_source, unit_target;
reg [15:0] n_unit_ien, n_unit_oen;
//reg [15:0] n_core_ien, o_core_oen;
//reg [15:0] n_iosc_ien, o_iosc_oen;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_state       <= 5'b00000;
    end else begin
        reg_state       <= next_state;
    end
end

// state transfer
always @(reg_state, unit_source, unit_target) begin
    case (reg_state)
        `STATE_IDLE: begin
            next_state = `STATE_READ_IR;
        end
        `STATE_PAUSE: begin
            next_state = `STATE_PAUSE;
        end
        `STATE_TRANS_DA: begin
            next_state = `STATE_READ_IR;
        end
        `STATE_READ_IR: begin
            if (unit_source == `CORE_NULL) begin
                next_state = `STATE_PAUSE;
            end else if (unit_target == `CORE_IR) begin
                next_state = `STATE_READ_IR;
            end else begin
                next_state = `STATE_TRANS_DA;
            end
        end
        default: begin
            next_state = `STATE_PAUSE;
        end
    endcase
end

// state output
always @(reg_state, i_ins) begin
    case (reg_state)
        `STATE_IDLE: begin
            unit_source = `IOSC_INS_PC;
            unit_target = `CORE_IR;
        end
        `STATE_PAUSE: begin
            unit_source = `IOSC_INS_PC;
            unit_target = `CORE_IR;
        end
        `STATE_READ_IR: begin
            unit_source = i_ins[7:4];
            unit_target = i_ins[3:0];
        end
        `STATE_TRANS_DA: begin
            unit_source = `IOSC_INS_PC;
            unit_target = `CORE_IR;
        end
        default: begin
            unit_source = `CORE_NULL;
            unit_target = `CORE_NULL;
        end
    endcase
end

// Instruction Decode
always @(unit_target) begin
    case (unit_target)
        `IOSC_INS_PC: begin
            n_unit_ien = `IOSC_EN_INS_PC;
            //n_core_ien = `CORE_EN_NULL;
            //n_iosc_ien = `IOSC_EN_INS_PC;
        end
        `IOSC_INS_AR: begin
            n_unit_ien = `IOSC_EN_INS_AR;
            //n_core_ien = `CORE_EN_NULL;
            //n_iosc_ien = `IOSC_EN_INS_AR;
        end
        `IOSC_OTH: begin
            n_unit_ien = `IOSC_EN_OTH;
            //n_core_ien = `CORE_EN_NULL;
            //n_iosc_ien = `IOSC_EN_OTH;
        end
        `CORE_NULL: begin
            n_unit_ien = `CORE_EN_NULL;
            //n_core_ien = `CORE_EN_NULL;
            //n_iosc_ien = `IOSC_EN_NULL;
        end
        `CORE_IR: begin
            n_unit_ien = `CORE_EN_IR;
            //n_core_ien = `CORE_EN_IR;
            //n_iosc_ien = `IOSC_EN_NULL;
        end
        `CORE_PC: begin
            n_unit_ien = `CORE_EN_PC;
            //n_core_ien = `CORE_EN_PC;
            //n_iosc_ien = `IOSC_EN_NULL;
        end
        `CORE_AR: begin
            n_unit_ien = `CORE_EN_AR;
            //n_core_ien = `CORE_EN_AR;
            //n_iosc_ien = `IOSC_EN_NULL;
        end
        `CORE_DR0: begin
            n_unit_ien = `CORE_EN_DR0;
            //n_core_ien = `CORE_EN_DR0;
            //n_iosc_ien = `IOSC_EN_NULL;
        end
        `CORE_DR1: begin
            n_unit_ien = `CORE_EN_DR1;
            //n_core_ien = `CORE_EN_DR1;
            //n_iosc_ien = `IOSC_EN_NULL;
        end
        `CORE_CR: begin
            n_unit_ien = `CORE_EN_CR;
            //n_core_ien = `CORE_EN_CR;
            //n_iosc_ien = `IOSC_EN_NULL;
        end
        default: begin
            n_unit_ien = `CORE_EN_NULL;
            //n_core_ien = `CORE_EN_NULL;
            //n_iosc_ien = `IOSC_EN_NULL;
        end
    endcase
end

always @(unit_source) begin
    case (unit_source)
        `IOSC_INS_PC: begin
            n_unit_oen = `IOSC_EN_INS_PC;
            //o_core_oen = `CORE_EN_NULL;
            //o_iosc_oen = `IOSC_EN_INS_PC;
        end
        `IOSC_INS_AR: begin
            n_unit_oen = `IOSC_EN_INS_AR;
            //o_core_oen = `CORE_EN_NULL;
            //o_iosc_oen = `IOSC_EN_INS_AR;
        end
        `IOSC_OTH: begin
            n_unit_oen = `IOSC_EN_OTH;
            //o_core_oen = `CORE_EN_NULL;
            //o_iosc_oen = `IOSC_EN_OTH;
        end
        `CORE_NULL: begin
            n_unit_oen = `CORE_EN_NULL;
            //o_core_oen = `CORE_EN_NULL;
            //o_iosc_oen = `IOSC_EN_NULL;
        end
        `CORE_IR: begin
            n_unit_oen = `CORE_EN_IR;
            //o_core_oen = `CORE_EN_IR;
            //o_iosc_oen = `IOSC_EN_NULL;
        end
        `CORE_PC: begin
            n_unit_oen = `CORE_EN_PC;
            //o_core_oen = `CORE_EN_PC;
            //o_iosc_oen = `IOSC_EN_NULL;
        end
        `CORE_AR: begin
            n_unit_oen = `CORE_EN_AR;
            //o_core_oen = `CORE_EN_AR;
            //o_iosc_oen = `IOSC_EN_NULL;
        end
        `CORE_DR0: begin
            n_unit_oen = `CORE_EN_DR0;
            //o_core_oen = `CORE_EN_DR0;
            //o_iosc_oen = `IOSC_EN_NULL;
        end
        `CORE_DR1: begin
            n_unit_oen = `CORE_EN_DR1;
            //o_core_oen = `CORE_EN_DR1;
            //o_iosc_oen = `IOSC_EN_NULL;
        end
        `CORE_CR: begin
            n_unit_oen = `CORE_EN_CR;
            //o_core_oen = `CORE_EN_CR;
            //o_iosc_oen = `IOSC_EN_NULL;
        end
        default: begin
            n_unit_oen = `CORE_EN_NULL;
            //o_core_oen = `CORE_EN_NULL;
            //o_iosc_oen = `IOSC_EN_NULL;
        end
    endcase
end

// outside device can read or write in one clock, not both.
assign o_unit_ien = n_unit_ien;
assign o_unit_oen = n_unit_oen;
//assign o_core_ien = reg_core_ien
//assign o_iosc_ien = reg_iosc_ien;

endmodule
