`timescale 1ns/1ps
// file name: ir_decoder.v
// author: lianghy
// time: 2017-4-11 17:08:36

`include define.h

`define LOAD_IR_LINES 8'hff

// assembly command encode
`define IDLE  8'b00000000
`define JUMP  8'b00000010 
`define STOP  8'b00001110 
`define LOAD  8'b10000000 
`define STORE 8'b10000001 
`define RESET 8'b00001111 
`define SET_D 8'b00010000 
`define SET_R 8'b00010001 
`define SET_A 8'b00010010 
`define ADD   8'b00100000 
`define SUB   8'b00100001 
`define MOD   8'b00100010 
`define DIV   8'b00100011 
`define LARGE 8'b00101000 
`define SMALL 8'b00101001 
`define EQUAL 8'b00101010 
                
// instructor execution encode
`define IR_FETCH        4'H0
`define IR_FETCH_P0     4'H0
`define IR_FETCH_P1     4'H0
`define IR_FETCH_P2     4'H0
`define IR_EXECUTE      4'H2


module ir_decoder(
input clk,
input rst_n,
input cash_init_load_finished,
input [`DATA_WIDTH-1:0] data_in,
input [`IRR_WIDTH-1:0] ir,
output [`IR_ADDR_WIDTH-1:0] irp,
output [`DATA_WIDTH-1:0] data_out,
output [`CTRL_BUS-1:0] ctrl_bus
);

reg [`DATA_WIDTH-1:0] reg_data_in_l1, reg_data_in_l2;
reg [`IRR_WIDTH-1:0] reg_ir;
reg reg_init;
reg reg_counter;
reg [`DATA_WIDTH-1:0] ir, p0, p1, p2;
reg ir_exe_state
reg ir_exe_state_next

[`DATA_WIDTH-1:0] ir_mux;
init_signal;
start_counter

// input reg
always @(posedge clk) begin
    if (!rst_n) begin
        reg_data_in_l1 <= `DATA_WIDTH'b0;
        reg_data_in_l2 <= `DATA_WIDTH'b0;
    end else begin
        reg_data_in_l1 <= data_in;
        reg_data_in_l2 <= reg_data_in_l1;
    end
end

always @(posedge clk) begin
    if (!rst_n) begin
        reg_ir <= `DATA_WIDTH'b0;
    end else begin
        reg_ir <= ir_mux;
    end
end
assign ir_mux = reg_init ? ((reg_data_in_l1==reg_data_in_l2) ? 
                  reg_data_in_l2 : `DATA_WIDTH'b0 )
              : ir;

// state
always @(posedge clk) begin
    if (!rst_n) begin
        reg_init <= 1'b0;
    end else begin
        reg_init <= init_signal;
    end
end

assign init_signal = !reg_init && reg_counter==`LOAD_IR_LINES;
// FSM: state transfer
always @(posedge clk) begin
    if (!rst_n) begin
        ir <= `IDLE;
    end else begin
        ir <= ir_next;
    end
end

// FSM: state control logic
always @(ir or ir_exe_state) begin
    case (ir) begin
        `IDLE: begin
            if (cash_init_load_finished) begin
                ir_next = `RESET;
            end else begin
                ir_next = ir;
            end
        end
        `RESET: begin
            if (ir_load_finished) begin
                ir_next = ir_load_ir_next;
            end else begin
                ir_next = ir;
            end
        end
        `LOAD: begin
            if (ir_load_finished) begin
                ir_next = ir_load_ir_next;
            end else begin
                ir_next = ir;
            end
        end
        default: ir_next = ir;
    end
end

// FSM_load:
        ir_exe_state <= ir_exe_state_next;
always @(ir or ir_exe_state) begin
    case (ir) begin
        `RESET: begin
            ir
            if (init_finished) begin
                ir_next = `LOAD;
                ir_exe_state_next = `IR_EXECUTE;
            end else begin
                ir_next = `RESET;
                ir_exe_state_next = ir_exe_state;
            end
        end
        `LOAD: begin
            ir_next = load_ir_state;
            ir_exe_state_next = load_ir_exe_state;
        end
        default: np=next;
    end
end
always @(ir or ir_exe_state) begin
    if (ir==`LOAD) begin
        ir_load_p0 = p0;
        ir_load_p1 = p1;
        ir_load_p2 = p2;
    end
    else begin
    end
    case (ir_excute_state) begin
        `IR_FETCH: begin
            ir_next = ir;
            ir_exe_state_next = `IR_FETCH_P0;
        end
        `IR_FETCH_P0: begin
            ir_next = ir;
            ir_exe_state_next = `IR_FETCH_P1;
        end
        `IR_FETCH_P1: begin
            ir_next = ir;
            ir_exe_state_next = `IR_FETCH_P2;
        end
        `IR_FETCH_P2: begin
            ir_next = ir;
            ir_exe_state_next = `IR_EXECUTE;
        end
        `IR_EXECUTE: begin
        // NEXT
            if (p2==8'h00) begin
                ir_next = data_in;
                ir_exe_state_next = `IR_FETCH;
            end
                ir_next = ir;
                ir_exe_state_next = `IR_EXECUTE;
            else begin
            end
        end
        default: 
    end
end

// FSM: output
        p1 <= `DATA_WIDTH'b0;
        p2 <= `DATA_WIDTH'b0;
        p3 <= `DATA_WIDTH'b0;
        p1 <= p1_next;
        p2 <= p2_next;
        p3 <= p3_next;
                p1_next = `DATA_WIDTH'h00;
                p2_next = `DATA_WIDTH'h00;
                p3_next = `DATA_WIDTH'hff;
                p1_next = `DATA_WIDTH'h00;
                p2_next = `DATA_WIDTH'h00;
                p3_next = `DATA_WIDTH'h00;

always @(posedge clk) begin
    if (!rst_n) begin
        reg_counter <= `DATA_WIDTH'b0;
    end else if (start_counter) begin
        reg_counter <= reg_counter+1'b1;
    end
end


endmodule
