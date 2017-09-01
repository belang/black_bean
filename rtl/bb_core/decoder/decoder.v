`timescale 1ns/1ps
// file name: decoder.v
// author: lianghy
// time: 2017-7-25 17:08:55

`include "define.v"

`define STATE_IDLE          5'b00000
`define STATE_READ_IR       5'b00001
`define STATE_READ_DA       5'b00010
`define STATE_WRITE         5'b00100
`define STATE_PAUSE         5'b01000

module decoder(
    clk,
    rst_n,
    i_ir,
    o_mem_action,
    o_unit_reg_input_en,
    o_unit_reg_output_en,
    o_unit_alu_output_en,
    o_mem_addr_source,
    o_pc_counter_en
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_ir;

output [1:0] o_mem_action             ;
output [5:0] o_unit_reg_input_en ;
output [5:0] o_unit_reg_output_en;
output [5:0] o_unit_alu_output_en;
output o_mem_addr_source, o_pc_counter_en;

reg [4:0] reg_state;
reg [5:0] reg_data_regs_input_en;

wire [1:0] i_action;
wire [4:0] i_unit;
reg [4:0] next_state;
reg [1:0] n_action;
reg [4:0] n_core_reg;
reg [5:0] unit_decoded_value, core_regs_input_en;
reg [5:0] o_unit_reg_output_en;
reg [5:0] o_unit_alu_output_en;
reg o_mem_addr_source, o_pc_counter_en;
reg [1:0] o_mem_action             ;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_state       <= 5'b00000;
    end else begin
        reg_state       <= next_state;
    end
end


// input decode -- generate n_action and n_core_reg
always @(reg_state, i_action, i_unit) begin
    case (reg_state)
        `STATE_IDLE: begin
            n_action = `ACTION_READ_PC;
            n_core_reg   = `UNIT_IR;
        end
        `STATE_PAUSE: begin
            n_action = `ACTION_PAUSE;
            n_core_reg   = `UNIT_NULL;
        end
        `STATE_READ_IR: begin
            n_action = i_action;
            n_core_reg   = i_unit;
        end
        `STATE_READ_DA: begin
            n_action = `ACTION_READ_PC;
            n_core_reg   = `UNIT_IR;
        end
        `STATE_WRITE: begin
            n_action = `ACTION_READ_PC;
            n_core_reg   = `UNIT_IR;
        end
        default: begin
            n_action = `ACTION_PAUSE;
            n_core_reg   = `UNIT_NULL;
        end
    endcase
end

// state transfer
always @(n_action, n_core_reg) begin
    case (n_action)
        `ACTION_PAUSE: begin
            next_state = `STATE_PAUSE;
        end
        `ACTION_WRITE: begin
            next_state = `STATE_WRITE;
        end
        `ACTION_READ_PC: begin
            if (n_core_reg == `UNIT_IR) next_state = `STATE_READ_IR;
            else next_state = `STATE_READ_DA;
        end
        `ACTION_READ_AR: begin
            if (n_core_reg == `UNIT_IR) next_state = `STATE_READ_IR;
            else next_state = `STATE_READ_DA;
        end
        default: begin
            next_state = `STATE_PAUSE;
        end
    endcase
end

// unit decode for data registers
always @(n_core_reg) begin
    case (n_core_reg)
        `UNIT_IR: begin
            unit_decoded_value = `DU_IR;
        end
        `UNIT_AR: begin
            unit_decoded_value = `DU_AR;
        end
        `UNIT_DR0: begin
            unit_decoded_value = `DU_DR0;
        end
        `UNIT_DR1: begin
            unit_decoded_value = `DU_DR1;
        end
        `UNIT_CR: begin
            unit_decoded_value = `DU_CR;
        end
        `UNIT_PC: begin
            unit_decoded_value = `DU_PC;
        end
        default: begin
            unit_decoded_value = `DU_NULL;
        end
    endcase
end

// output -- data register flag
always @(n_action, n_core_reg) begin
    case (n_action)
        `ACTION_READ_PC: begin
            core_regs_input_en = unit_decoded_value;
            o_mem_addr_source      = `ADDR_FROM_PC;
            o_unit_reg_output_en    = `DU_NULL;
            o_unit_alu_output_en    = `DU_NULL;
            o_pc_counter_en         = 1'b1;
            o_mem_action            = `MEM_READ;
        end
        `ACTION_READ_AR: begin
            core_regs_input_en = unit_decoded_value;
            o_mem_addr_source      = `ADDR_FROM_AR;
            o_unit_reg_output_en    = `DU_NULL;
            o_unit_alu_output_en    = `DU_NULL;
            o_pc_counter_en           = 1'b0;
            o_mem_action            = `MEM_READ;
        end
        `ACTION_WRITE: begin
            core_regs_input_en = `DU_NULL;
            o_mem_addr_source      = `ADDR_FROM_AR;
            o_unit_reg_output_en    = unit_decoded_value;
            o_unit_alu_output_en    = n_core_reg;
            o_pc_counter_en         = 1'b0;
            o_mem_action            = `MEM_WRITE;
        end
        `ACTION_PAUSE: begin
            core_regs_input_en = `DU_NULL;
            o_mem_addr_source      = `ADDR_FROM_AR;
            o_unit_reg_output_en    = `DU_NULL;
            o_unit_alu_output_en    = `DU_NULL;
            o_pc_counter_en         = 1'b0;
            o_mem_action            = `MEM_PAUSE;
        end
        default: begin
            core_regs_input_en = `DU_NULL;
            o_mem_addr_source      = `ADDR_FROM_AR;
            o_unit_reg_output_en    = `DU_NULL;
            o_unit_alu_output_en    = `DU_NULL;
            o_pc_counter_en         = 1'b0;
            o_mem_action            = `MEM_PAUSE;
        end
    endcase
end

// input
assign i_action  = i_ir[7:6];
assign i_unit    = i_ir[5:0];

// ouptut
assign o_unit_reg_input_en  = core_regs_input_en;

endmodule
