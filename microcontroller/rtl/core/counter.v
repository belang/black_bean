`timescale 1ns/1ps
// file name: counter.v
// author: lianghy
// time: 2018/1/12 11:04:15

`include "define.v"

`define COUNT    2'b00
`define AUTO     2'b01
`define AUTO_RUN 2'b10

module counter(
    clk,
    rst_n,
    dr0,
    dr1,
    cr,
    addr_bus,
    counter_result,
    counter_addition
);

input  clk, rst_n;
input  [`DATA_WIDTH-1:0] dr0, dr1, cr;
input  [`DATA_WIDTH-1:0] addr_bus;
output [`DATA_WIDTH-1:0] counter_result, counter_addition;


reg  [`DATA_WIDTH-1:0] reg_counter, reg_start_value, reg_stop_value;
reg  [1:0] reg_mode;
reg  [1:0] next_mode;
reg reg_auto_reach_stop_value, reg_trigger;
wire reset, set_count, set_auto, set_stop, set_start, trigger, reach_max, export;


always @(posedge clk) begin
    if (!rst_n) begin
        reg_mode <= `COUNT;
        reg_trigger <= 1'b0;
    end
    else begin
        reg_mode <= next_mode;
        reg_trigger <= cr==`ALU_COUNTER_TRIGGER;
    end
end

always @(cr) begin
    case (reg_mode)
        `COUNT: begin
            if (set_auto) begin
                next_mode = `AUTO;
            end else begin
                next_mode = reg_mode;
            end
        end
        `AUTO: begin
            if (trigger) begin
                next_mode = `AUTO_RUN;
            end else if (set_count) begin
                next_mode = `COUNT;
            end else begin
                next_mode = reg_mode;
            end
        end
        `AUTO_RUN: begin
            if (trigger || reset) begin
                next_mode = `AUTO_RUN;
            end else if (set_count) begin
                next_mode = `COUNT;
            end else if (set_auto) begin
                next_mode = `AUTO;
            end else if (reg_counter==reg_stop_value) begin
                next_mode = `AUTO;
            end else begin
                next_mode = reg_mode;
            end
        end
        default: begin
            next_mode = reg_mode;
        end
    endcase
end

always @(posedge clk) begin
    if (!rst_n) begin
        reg_counter <= `DATA_WIDTH'h00;
        reg_start_value <= `DATA_WIDTH'h00;
        reg_stop_value <= `DATA_WIDTH'h00;
        reg_auto_reach_stop_value <= `DATA_WIDTH'h00;
    end else begin
        reg_start_value <= set_start ? dr0 : reg_start_value;
        reg_stop_value <= set_stop ? dr1 : reg_stop_value;
        reg_auto_reach_stop_value <= ((reg_mode==`AUTO_RUN)&&reach_max) ? `DATA_WIDTH'h01 :
            (set_auto||trigger||reset) ? `DATA_WIDTH'h00 : reg_auto_reach_stop_value;
        case (reg_mode)
            `COUNT: begin
                if (trigger) begin
                    reg_counter <= reg_counter+`DATA_WIDTH'h01;
                end else if (set_count||set_auto) begin
                    reg_counter <= dr0;
                end else if (reset) begin
                    reg_counter <= reg_start_value;
                end else begin
                    reg_counter <= reg_counter;
                end
            end
            `AUTO: begin
                if (set_count||set_auto) begin
                    reg_counter <= dr0;
                end else if (reset) begin
                    reg_counter <= reg_start_value;
                end else begin
                    reg_counter <= reg_counter;
                end
            end
            `AUTO_RUN: begin
                if (set_count||set_auto) begin
                    reg_counter <= dr0;
                end else if (reset||trigger||reach_max) begin
                    reg_counter <= reg_start_value;
                end else begin
                    reg_counter <= reg_counter+`DATA_WIDTH'h01;
                end
            end
            default: begin
                reg_counter <= reg_counter;
            end
        endcase
    end
end


assign set_count    = (cr==`ALU_COUNTER);
assign set_auto     = (cr==`ALU_COUNTER_AUTO);
assign trigger      = (cr==`ALU_COUNTER_TRIGGER)&&(!reg_trigger);
assign reset        = (cr==`ALU_COUNTER_RESET);
assign export       = (cr==`ALU_COUNTER_OUT);
assign set_start    = set_count || set_auto;
assign set_stop     = set_count || set_auto;
assign reach_max    = (reg_counter==reg_stop_value)&&(|reg_stop_value);
assign counter_result = export ? reg_counter : `DATA_WIDTH'h0;
assign counter_addition = export ? {7'h01, reg_auto_reach_stop_value} : `DATA_WIDTH'h0;
//(cr==`ALU_COUNTER_OUT) ? reg_counter : `DATA_WIDTH'bz;
                  //(cr==`ALU_COUNTER_AD) ? reg_auto_reach_stop_value : `DATA_WIDTH'bz;


endmodule
