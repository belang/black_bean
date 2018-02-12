`timescale 1ns/1ps
// file name: ar.v
// author: lianghy
// time: 2018/1/8 10:37:54

`include "define.v"

`define IDLE 4'h0
`define SET_DATA_ONE 4'h1

module ar(
    clk,
    rst_n,
    addr_bus,
    data_bus_in,
    data_bus_out,
    ram_addr
);

input  clk, rst_n;
input  [`DATA_WIDTH-1:0] addr_bus;
input  [`DATA_WIDTH-1:0] data_bus_in;
output [`DATA_WIDTH-1:0] data_bus_out;
output [`ROM_ADDR_WIDTH-1:0] ram_addr;

reg [`ROM_ADDR_WIDTH-1:0] reg_AR;
reg [3:0] reg_state, reg_out_state;
reg [3:0] next_state, next_out_state;
wire set_ar, source_ar;
reg [`ROM_ADDR_WIDTH-1:0] ar_out;

assign set_ar = addr_bus[3:0]==`AR;
assign source_ar = addr_bus[7:4]==`AR;
assign ram_addr = reg_AR;
assign data_bus_out = (source_ar) ? ar_out : `DATA_WIDTH'b0;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_state <= `IDLE;
        reg_out_state <= `IDLE;
    end else begin
        reg_state <= next_state;
        reg_out_state <= next_out_state;
    end
end

always @(reg_state, set_ar) begin
    case (reg_state)
        `IDLE: begin
            if (set_ar) begin
                next_state = `SET_DATA_ONE;
            end else begin
                next_state = reg_state;
            end
        end
        `SET_DATA_ONE: begin
            next_state = `IDLE;
        end
        default: begin
            next_state = `IDLE;
        end
    endcase
end

always @(posedge clk) begin
    if (!rst_n) begin
        reg_AR <= `RAM_ADDR_WIDTH'h00;
    end
    else begin
        case (reg_state)
            `IDLE: begin
                if (set_ar) begin
                    reg_AR <= {reg_AR[15:8], data_bus_in};
                end
            end
            `SET_DATA_ONE: begin
                if (set_ar) begin
                    reg_AR <= {reg_AR[7:0], data_bus_in};
                end
            end
            default: begin
                reg_AR <= reg_AR;
            end
        endcase
    end
end

always @(reg_out_state, source_ar) begin
    case (reg_out_state)
        `IDLE: begin
            if (source_ar) begin
                next_out_state = `SET_DATA_ONE;
            end else begin
                next_out_state = reg_out_state;
            end
        end
        `SET_DATA_ONE: begin
            next_out_state = `IDLE;
        end
        default: begin
            next_out_state = `IDLE;
        end
    endcase
end
always @(reg_out_state, source_ar, reg_AR) begin
    case (reg_out_state)
        `IDLE: begin
            if (source_ar) begin
                ar_out = reg_AR[7:0];
            end
        end
        `SET_DATA_ONE: begin
            if (source_ar) begin
                ar_out = reg_AR[15:8];
            end
        end
        default: begin
            ar_out = reg_AR;
        end
    endcase
end

endmodule
