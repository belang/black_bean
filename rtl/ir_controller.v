`timescale 1ns/1ps
// file name: ir_controller.v
// author: lianghy
// time: 2017-6-14 11:21:06

`include "define.v"

`define  L_IDLE             3'b001
`define  L_LOAD_IR          3'b010
`define  L_EXCUTE           3'b100

module ir_controller(
    clk,
    rst_n,
    i_ir,
    i_data,
    i_cash_data,
    o_ir,
    o_data,
    o_cash_data
);
input clk, rst_n;
input [`IR_WIDTH-1:0] i_ir;
input [`DATA_WIDTH-1:0] i_data, i_cash_data;
output [`IR_WIDTH-1:0] o_ir;
output [`DATA_WIDTH-1:0] o_data,o_cash_data;

// 8bits X 8rows
reg [`IR_WIDTH-1:0] reg_ir_queue[7:0];
reg [8:0] reg_queue_export_pointer;
reg [`DATA_WIDTH-1:0] reg_i_data, reg_o_data;
reg reg_last_ir_is_set, reg_queue_pointer_en,
    reg_fifo_write_pointer, reg_fifo_read_pointer,
    next_fifo_write_location, next_fifo_read_location;

reg [2:0] state;

//wire
reg [2:0] next_state;
wire [`IR_WIDTH-1:0] next_ir_queue[7:0], ir_loader[7:0];
wire en_load, data_ready, en_sequence, en_transfer;
wire [`IR_WIDTH-1:0] ir_block[7:0];
wire [`IR_WIDTH-1:0] ex_ir;
wire f_ir_is_set, next_last_ir_is_set;
wire ['DATA_WIDTH-1:0] next_o_data;
wire [8:0] next_queue_export_pointer;
reg [`IR_WIDTH-1:0] queue_out_ir;
wire load_ir_block_en, set_data, ir_hit;
reg next_fifo_write_pointer, next_fifo_read_pointer;

// cash loader
// cash loader: FIFO
// cash loader: FIFO -> command
always @(posedge clk) begin
    if (!rst_n) begin
        reg_fifo_write_pointer <= 1'b0;
        reg_fifo_read_pointer <= 1'b0;
    end else begin
        reg_fifo_write_pointer <= next_fifo_write_pointer;
        reg_fifo_read_pointer <= next_fifo_read_pointer;
    end
end

assign next_fifo_write_pointer = 
    (wen && (next_fifo_write_location!=reg_fifo_read_pointer)) ?
    next_fifo_write_location : reg_fifo_write_pointer;

always @(posedge clk) begin
    case (reg_fifo_write_pointer)
        0: begin
            next_fifo_write_location = 1;
        end
        1: begin
            next_fifo_write_location = 0;
        end
        default: begin
            next_fifo_write_location = 0;
        end
    endcase
end

always @(posedge clk) begin
    case (reg_fifo_read_pointer)
        0: begin
            next_fifo_read_location = 1;
        end
        1: begin
            next_fifo_read_location = 0;
        end
        default: begin
            next_fifo_read_location = 0;
        end
    endcase
end

//assign next_fifo_read_pointer = 
//    (reg_fifo_write_pointer != reg_fifo_read_pointer) ?
 //   next_fifo_read_location : reg_fifo_read_pointer;
// state machine
always @(posedge clk) begin
    if (!rst_n) begin
        state <= `L_LOAD_IR;
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case (state)
        `L_IDLE: begin
            next_state = state;
        end
        `L_LOAD_IR: begin
            if (data_ready) begin
                next_state = `L_EXCUTE;
            end else begin
                next_state = state;
            end
        end
        `L_EXCUTE: begin
            if (jump_ir) begin
                next_state = `L_LOAD_IR;
            end else if (stop_ir) begin
                next_state = `L_IDLE;
            end else begin
                next_state = state;
            end
        end
        default: begin
            next_state = `L_IDLE;
        end
    endcase
end

always @(*) begin
    case (state)
        `L_IDLE: begin
            en_load = 1'b1;
            en_export = 1'b0;
        end
        `L_LOAD_IR: begin
            en_load = 1'b1;
            en_export = 1'b0;
        end
        `L_EXCUTE: begin
            en_load = 1'b0;
            en_export = 1'b1;
        end
        default: begin
            en_load = 1'b0;
            en_export = 1'b0;
        end
    endcase
end

// ** ir decoder *****
load_ir_block_en = i_ir == `LOAD_IR_BLCOK;
set_data         = i_ir == `SET_DATA;
ir_hit = load_ir_block_en;

// ** data bus input data *****
always @(posedge clk) begin
    if (!rst_n) begin
        reg_i_data <= `DATA_WIDTH'h0;
    end else begin
        reg_i_data <= ir_hit ? i_data : reg_i_data;
    end
end

// ** cash loader *****


// ** ir queue *****
// signals: loader_data_ready,

always @(posedge clk) begin
    if (!rst_n) begin
        reg_ir_queue[0] <= `LOAD_IR_BLCOK;
        reg_i_data <= `DATA_WIDTH'h0;
        reg_queue_export_pointer <= 9'b000000010;
    end else begin
        reg_ir_queue <= next_ir_queue;
        reg_i_data <= i_data;
        reg_queue_export_pointer <= next_queue_export_pointer;
        reg_queue_pointer_en <= !load_ir_block_en && (loader_data_ready ||
            reg_queue_pointer_en);
    end
end

// load ir block
assign next_ir_queue = loader_data_ready ? ir_block : reg_ir_queue;
// ir pointer controller
assign next_queue_export_pointer = load_ir_block_en ? 9'h001 :
    reg_queue_pointer_en ? reg_queue_export_pointer<<1 : reg_queue_export_pointer;

// select export ir
always @(reg_queue_export_pointer) begin
    case (reg_queue_export_pointer)
        9'b000000001: begin
            queue_out_ir = `IR_WIDTH'h0;
        end
        9'b000000010: begin
            queue_out_ir = reg_ir_queue[0];
        end
        9'b000000100: begin
            queue_out_ir = reg_ir_queue[1];
        end
        9'b000001000: begin
            queue_out_ir = reg_ir_queue[2];
        end
        9'b000010000: begin
            queue_out_ir = reg_ir_queue[3];
        end
        9'b000100000: begin
            queue_out_ir = reg_ir_queue[4];
        end
        9'b001000000: begin
            queue_out_ir = reg_ir_queue[5];
        end
        9'b010000000: begin
            queue_out_ir = reg_ir_queue[6];
        end
        9'b100000000: begin
            queue_out_ir = reg_ir_queue[7];
        end
        default: begin
            queue_out_ir = `IR_WIDTH'h0;
        end
    endcase
end

// ir_laucher : set_data

assign ex_ir = (reg_last_ir_is_set || f_ir_is_set) ? IR_WIDTH'h0 : queue_out_ir;
assign f_ir_is_set = queue_out_ir == `ACTION_SET_DATA;
assign o_data = reg_o_data;
assign next_last_ir_is_set = !reg_last_ir_is_set && f_ir_is_set;
assign next_o_data = reg_last_ir_is_set ? queue_out_ir : DATA_WIDTH'h0;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_last_ir_is_set <= 1'b0;
        reg_o_data <= `IR_WIDTH'h0;
    end else begin
        reg_last_ir_is_set <= next_last_ir_is_set;
        reg_o_data <= next_o_data;
    end
end

endmodule
