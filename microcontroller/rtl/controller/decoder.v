`timescale 1ns/1ps
// file name: decoder.v
// author: lianghy
// time: 2018/1/4 10:47:00

`include "define.v"

`define LOAD_IR 4'h0
`define LOAD_DATA 4'h1
`define STOP    4'hf


module decoder(
    ref_clk,
    chip_rst_n,
    core_clock,
    core_rst_n,
    instructor,
    interrupt,
    addr_bus,
    data_bus_out
);

input  ref_clk, chip_rst_n;
output core_clock, core_rst_n;
input [`IR_WIDTH-1:0] instructor;
input  [`DATA_WIDTH-1:0] interrupt;
output [`IR_WIDTH-1:0] addr_bus;
output [`DATA_WIDTH-1:0] data_bus_out;

reg [3:0] reg_state;
reg [`IR_WIDTH-1:0] reg_IR;
reg [3:0] next_state;
reg core_reset_n, core_clock_en;

always @(posedge core_clock) begin
    if (!core_rst_n) begin
        reg_state <= `LOAD_IR;
    end else begin
        reg_state <= next_state;
    end
end

always @(instructor) begin
    case (reg_state)
        `LOAD_IR: begin
            if (instructor=={`NULL, `ROM}) begin  // next ir
                next_state = `LOAD_IR;
            end else if (instructor[7:4]==`ROM) begin  // source is ROM
                next_state = `LOAD_DATA;
            end else if (instructor=={`NULL, `NULL}) begin
                next_state = `STOP;
            end else begin
                next_state = `LOAD_IR;
            end
        end
        `LOAD_DATA: begin
            next_state = `LOAD_IR;
        end
        `STOP: begin
            next_state = `STOP;
        end
        default: begin
            next_state = `STOP;
        end
    endcase
end

always @(posedge core_clock) begin
    if (!core_rst_n) begin
        reg_IR <= {`NULL,`ROM}; // next
    end
    else begin 
        case (reg_state)
            `LOAD_IR: begin
                reg_IR <= instructor;
            end
            `LOAD_DATA: begin
                reg_IR <= reg_IR;
            end
            `STOP: begin
                reg_IR <= `IR_WIDTH'h00;
            end
            default: begin
                reg_IR <= `IR_WIDTH'h00;
            end
        endcase
    end
end

assign addr_bus = (reg_state==`LOAD_DATA) ? reg_IR :
                    (instructor[7:4]==`ROM) ? `DATA_WIDTH'b0 : instructor;
assign data_bus_out = (reg_state==`LOAD_DATA) ? instructor : `DATA_WIDTH'h0;

// interrupt decoder
always @(interrupt) begin
    case (interrupt)
        `INTERRUPT_STOP: begin
            core_clock_en = 1'b0;
            core_reset_n = 1'b1;
        end
        `INTERRUPT_PAUSE: begin
            core_clock_en = 1'b0;
            core_reset_n = 1'b1;
        end
        `INTERRUPT_RESET: begin
            core_clock_en = 1'b1;
            core_reset_n = 1'b0;
        end
        default: begin
            core_clock_en = 1'b1;
            core_reset_n = 1'b1;
        end
    endcase
end

assign core_rst_n = core_reset_n&&chip_rst_n; // both can reset
assign core_clock = (core_clock_en&&ref_clk); // hold low

endmodule
