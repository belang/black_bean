`timescale 1ns/1ps
// file name: ir_decoder.v
// author: lianghy
// time: 2017-4-11 17:08:36

`include define.h
`include ir.v

// instructor execution encode
`define RESET       3'H0
`define INIT        3'H1
`define READ_IR     3'H2
`define READ_P      3'H3
`define HOLD        3'H4


module ir_decoder(
input clk,
input rst_n,
input i_cash_init_done,
input [`DATA_WIDTH-1:0] i_data,
output [`IR_ADDR_WIDTH-1:0] o_irp,
output [`DATA_WIDTH-1:0] o_data_bus,
output [`CTRL_BUS-1:0] o_ctrl_bus
);

// parameter define
reg [`DATA_WIDTH-1:0] decoder_state;
reg [`DATA_WIDTH-1:0] decoder_state_next;

wire load_en,load_read_p,load_busy,load_init;
wire read_p,busy;
wire ir_match,hold;

// FSM: reg
always @(posedge clk) begin
    if (!rst_n) begin
        decoder_state <= `RESET;
    end else begin
        decoder_state <= decoder_state_next;
    end
end

// FSM: transfer
always @(decoder_state ) begin
    case (decoder_state) begin
        `RESET: if (i_cash_init_done) begin
            decoder_state_next = `INIT;
        end else begin
            decoder_state_next = decoder_state;
        end
        `INIT: if (!load_busy) begin
            decoder_state_next = `READ_IR;
        end else begin
            decoder_state_next = decoder_state;
        end
        `READ_IR: if (read_p) begin
            decoder_state_next = `READ_P;
        end else if (busy) begin
            decoder_state_next = `HOLD;
        end else begin
            decoder_state_next = decoder_state;
        end
        `READ_P: if (!read_p) begin
            decoder_state_next = `READ_IR;
        end else begin
            decoder_state_next = decoder_state;
        end
        `HOLD: if (!busy) begin
            decoder_state_next = `READ_IR;
        end else begin
            decoder_state_next = decoder_state;
        end
        default: decoder_state_next = decoder_state;
    end
end

// FSM: output
always @(decoder_state ) begin
    case (decoder_state) begin
        `INIT: load_init = 1'b1;
        `READ_IR: ir_match = 1'b1;
        `HOLD: hold = 1'b1;
        default: begin
            load_init = 1'b0;
            ir_match = 1'b0;
            hold = 1'b0;
        end
    end
end

// ir match
assign load_en = ir_match && (i_data == `LOAD);

assign read_p = load_read_p;
assign busy = load_busy;

endmodule
