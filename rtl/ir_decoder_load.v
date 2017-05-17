`timescale 1ns/1ps
// file name: ir_decoder_load.v
// author: lianghy
// time: 2017-4-13 15:58:23

`define IDLE                3'h0
`define INIT                3'h1
`define READ_P0             3'h2
`define READ_P1             3'h3
`define READ_P2             3'h4
`define READ_CASH           3'h5
`define WRITE_IR_REGFILE    3'h6

`define INIT_IR_LINES       `DATA_WIDTH'hff

module ir_decoder_load(
input clk,
input rst_n,
input en,
input init,
input  [`DATA_WIDTH-1:0] i_data,
output [`DATA_WIDTH-1:0] o_addr_bus_next,
output o_cash_ren,
output o_ir_regfile_wen,
output o_busy,
output o_read_p
);

reg [`DATA_WIDTH-1:0] state,state_next;
reg [`DATA_WIDTH-1:0] p0,p1,p2;
reg [`DATA_WIDTH-1:0] p0_next,p1_next,p2_next;
reg [`DATA_WIDTH-1:0] counter_set_data;
reg counter_set,counter_trigger;

// FSM: state reg
always @(posedge clk) begin
    if (!rst_n) begin
        state <= `IDLE;
    end else begin
        state <= state_next;
    end
end

// FSM: state transfer
always @(init or state) begin
    case (state) begin
        `IDLE: begin
            if (init) begin
                state_next = `INIT;
            end else if (en) begin
                state_next = `READ_P0;
            end else begin
                state_next = state;
            end
        end
        `INIT: state_next = `READ_CASH;
        `READ_P0: state_next = `READ_P1;
        `READ_P1: state_next = `READ_P2;
        `READ_P2: state_next = `READ_CASH;
        `READ_CASH: state_next = `WRITE_IR_REGFILE;
        `WRITE_IR_REGFILE: begin
            if (counter==p2) begin
                state_next = `IDLE;
            end else begin
                state_next = `READ_CASH;
            end
        end
        default: state_next = state;
    end
end

// FSM: state output
always @(state) begin
    case (state) begin
        `IDLE: begin
            p0_next = `DATA_WIDTH'h00;
            p1_next = `DATA_WIDTH'h00;
            p2_next = `DATA_WIDTH'h00;
            counter_set_data = `DATA_WIDTH'h00;
            counter_set = 1'b0;
            counter_trigger = 1'b0;
            o_addr_bus_next = `DATA_WIDTH'h00;
            o_cash_ren = 1'b0;
            o_ir_regfile_wen = 1'b0;
            o_busy = 1'b0;
            o_read_p = 1'b0;
        end
        `INIT: begin
            p0_next = `DATA_WIDTH'h00;
            p1_next = `DATA_WIDTH'h00;
            p2_next = `INIT_IR_LINES;
            counter_set_data = `INIT_IR_LINES;
            counter_set = 1'b1;
            counter_trigger = 1'b0;
            o_addr_bus_next = `DATA_WIDTH'h00;
            o_cash_ren = 1'b0;
            o_ir_regfile_wen = 1'b0;
        end
        `READ_P0: begin
            o_read_p = 1'b1;
            p0_next = i_data;
        end
        `READ_P1: begin
            o_read_p = 1'b1;
            p1_next = i_data;
        end
        `READ_P2: begin
            o_read_p = 1'b1;
            p2_next = i_data;
            counter_set_data = i_data;
            counter_set = 1'b1;
        end
        `READ_CASH: begin
            p0_next = p0+`DATA_WIDTH'h01;
            o_addr_bus_next = p0;
            o_cash_ren = 1'b1;
            o_ir_regfile_wen = 1'b0;
        end
        `WRITE_IR_REGFILE: begin
            p1_next = p1+`DATA_WIDTH'h01;
            counter_trigger = 1'b1;
            o_addr_bus_next = p1;
            o_cash_ren = 1'b0;
            o_ir_regfile_wen = 1'b1;
        end
        default: begin
            p0_next = p0;
            p1_next = p1;
            p2_next = p2;
            counter_set_data = `DATA_WIDTH'h00;
            counter_set = 1'b0;
            counter_trigger = 1'b0;
            o_addr_bus_next = `DATA_WIDTH'h00;
            o_cash_ren = 1'b0;
            o_ir_regfile_wen = 1'b0;
            o_read_p = 1'b0;
            o_busy = 1'b1;
        end
    end
end

endmodule
