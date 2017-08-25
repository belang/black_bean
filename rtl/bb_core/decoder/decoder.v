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
    o_action_read_addr_source,
    o_pc_counter_en
);
input clk, rst_n;
input [`DATA_WIDTH-1:0] i_ir;

output [1:0] o_mem_action             ;
output [5:0] o_unit_reg_input_en ;
output [5:0] o_unit_reg_output_en;
output [5:0] o_unit_alu_output_en;
output o_action_read_addr_source, o_pc_counter_en;

reg [4:0] reg_state;
reg [5:0] reg_state_unit;
reg [5:0] reg_data_regs_input_en;

wire [4:0] next_state;
wire [1:0] next_action, i_action;
wire [4:0] n_unit, i_unit;
reg [5:0] data_reg_decoded_value, next_data_regs_input_en;
reg [5:0] o_unit_reg_output_en;
reg [5:0] o_unit_alu_output_en;
reg o_read_addr_source, o_pc_counter_en;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_state       <= 5'b00000;
        reg_state_unit  <= 6'b000000;
        reg_data_regs_input_en <= `DU_NULL;
    end else begin
        reg_state       <= next_state;
        reg_state_unit  <= next_state_unit;
        reg_data_regs_input_en <= next_data_regs_input_en;
    end
end


// input decode -- generate next_action and n_unit
always @(reg_state, i_action, i_unit) begin
    case (reg_satte)
        `STATE_IDLE: begin
            next_action = `ACTION_READ_PC;
            n_unit   = `UNIT_IR;
        end
        `STATE_PAUSE: begin
            next_action = `ACTION_PAUSE;
            n_unit   = `UNIT_NULL;
        end
        `STATE_READ_IR: begin
            next_action = i_action;
            n_unit   = i_unit;
        end
        `STATE_READ_DA: begin
            next_action = `ACTION_READ_PC;
            n_unit   = `UNIT_IR;
        end
        `STATE_WRITE: begin
            next_action = `ACTION_READ_PC;
            n_unit   = `UNIT_IR;
        end
        default: begin
            next_action = `ACTION_PAUSE;
            n_unit   = `UNIT_NULL;
        end
    endcase
end

// state transfer
always @(next_action, n_unit) begin
    case (next_action)
        `ACTION_PAUSE: begin
            next_state = `STATE_PAUSE;
        end
        `ACTION_WRITE: begin
            next_state = `STATE_WRITE;
        end
        `ACTION_READ_PC: begin
            if (n_unit == `RU_IR) next_state = `STATE_READ_IR;
            else next_state = `STATE_READ_DA;
        end
        `ACTION_READ_AR: begin
            if (n_unit == `RU_IR) next_state = `STATE_READ_IR;
            else next_state = `STATE_READ_DA;
        end
        default: begin
            next_state = `STATE_PAUSE;
        end
    endcase
end

// unit decode for data registers
always @(n_unit) begin
    case (n_unit)
        `UNIT_IR: begin
            data_reg_decoded_value = `DU_IR;
        end
        `UNIT_AR: begin
            data_reg_decoded_value = `DU_AR;
        end
        `UNIT_DR0: begin
            data_reg_decoded_value = `DU_DR0;
        end
        `UNIT_DR1: begin
            data_reg_decoded_value = `DU_DR1;
        end
        `UNIT_MR: begin
            data_reg_decoded_value = `DU_MR;
        end
        `UNIT_PC: begin
            data_reg_decoded_value = `DU_PC;
        end
        default: begin
            data_reg_decoded_value = `DU_NULL;
        end
    endcase
end

// output -- data register flag
always @(next_action) begin
    case (next_action)
        `ACTION_READ_PC: begin
            next_data_regs_input_en = data_reg_decoded_value;
            o_read_addr_source      = `ADDR_FROM_PC;
            o_unit_reg_output_en    = `DU_NULL;
            o_unit_alu_output_en    = `DU_NULL;
            o_pc_counter_en         = 1'b1;
            o_mem_action            = `MEM_READ;
        end
        `ACTION_READ_AR: begin
            next_data_regs_input_en = data_reg_decoded_value;
            o_read_addr_source      = `ADDR_FROM_AR;
            o_unit_reg_output_en    = `DU_NULL;
            o_unit_alu_output_en    = `DU_NULL;
            o_pc_counter_en           = 1'b0;
            o_mem_action            = `MEM_READ;
        end
        `ACTION_WRITE: begin
            next_data_regs_input_en = `DU_NULL;
            o_read_addr_source      = `ADDR_FROM_AR;
            o_unit_reg_output_en    = data_reg_decoded_value;
            o_unit_alu_output_en    = n_unit;
            o_pc_counter_en         = 1'b0;
            o_mem_action            = `MEM_WRITE;
        end
        `ACTION_PAUSE: begin
            next_data_regs_input_en = `DU_NULL;
            o_read_addr_source      = `ADDR_FROM_AR;
            o_unit_reg_output_en    = `DU_NULL;
            o_unit_alu_output_en    = `DU_NULL;
            o_pc_counter_en         = 1'b0;
            o_mem_action            = `MEM_PAUSE;
        end
        default: begin
            next_data_regs_input_en = `DU_NULL;
            o_read_addr_source      = `ADDR_FROM_AR;
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
assign o_mem_action = next_action;
assign o_unit_reg_input_en  = reg_data_regs_input_en;

endmodule
