`timescale 1ns/1ps
// file name: pc.v
// author: lianghy
// time: 2018/1/5 15:11:42

`include "define.v"

`define IDLE 4'b0000
`define SET_DATA_ONE 4'b0001

module pc(
    clk,
    rst_n,
    addr_bus,
    data_bus_in,
    re,
    rom_addr
);

input  clk, rst_n;
input  [`DATA_WIDTH-1:0] addr_bus;
input [`DATA_WIDTH-1:0] data_bus_in;
input  [`DATA_WIDTH-1:0] re;
output [`ROM_ADDR_WIDTH-1:0] rom_addr;

reg [`ROM_ADDR_WIDTH-1:0] reg_PC_latch;
reg [`ROM_ADDR_WIDTH-1:0] reg_PC;
reg [3:0] reg_state;
reg [3:0] next_state;
wire [`DATA_WIDTH-1:0] next_pc;
wire set_pc, jump;

assign jump = addr_bus=={`PC, `PC};
assign set_pc = (addr_bus[7:4]!=`PC)&&(addr_bus[3:0]==`PC);
assign rom_addr = reg_PC;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_state <= `IDLE;
    end else begin
        reg_state <= next_state;
    end
end

always @(*) begin
    case (reg_state)
        `IDLE: begin
            if (set_pc) begin
                next_state = `SET_DATA_ONE;
            end
        end
        `SET_DATA_ONE: begin
            if (set_pc || jump) begin
                next_state = `IDLE;
            end
        end
        default: begin
            next_state = `IDLE;
        end
    endcase
end
always @(posedge clk) begin
    if (!rst_n) begin
        reg_PC_latch <= `ROM_ADDR_WIDTH'h00;
    end
    else begin
        case (reg_state)
            `IDLE: begin
                if (set_pc) begin
                    reg_PC_latch[7:0] <= data_bus_in;
                end else begin
                    reg_PC_latch <= reg_PC_latch;
                end
            end
            `SET_DATA_ONE: begin
                if (set_pc) begin
                    reg_PC_latch <= {reg_PC_latch[7:0], data_bus_in};
                end else begin
                    reg_PC_latch <= reg_PC_latch;
                end
            end
            default: begin
                reg_PC_latch <= reg_PC;
            end
        endcase
    end
end

// pc = pc+1

always @(posedge clk) begin
    if (!rst_n) begin
        reg_PC <= `DATA_WIDTH'h00;
    end
    else begin
        reg_PC <= next_pc;
    end
end

assign next_pc = (jump && (re[0]==1'b0)) ? reg_PC_latch : reg_PC+`DATA_WIDTH'h01;

endmodule
