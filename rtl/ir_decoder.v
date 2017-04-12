`timescale 1ns/1ps
// file name: ir_decoder.v
// author: lianghy
// time: 2017-4-11 17:08:36

`include define.h

`define LOAD_IR_LINES 8'hff

// assembly command encode
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
`define IR_FETCH	4'H0
`define IR_FETCH_P0	4'H0
`define IR_FETCH_P1	4'H0
`define IR_FETCH_P2	4'H0
`define IR_DECODE	4'H1
`define IR_EXECUTE	4'H2


module ir_decoder(
input clk,
input rst_n,
input load_finished,
input [`DATA_WIDTH-1:0] data_in,
input [`IRR_WIDTH-1:0] ir,
output [`IR_ADDR_WIDTH-1:0] irp,
output [`DATA_WIDTH-1:0] data_out,
output [`CTRL_BUS-1:0] ctrl_bus
);

reg [`DATA_WIDTH-1:0] reg_data_in_l1, reg_data_in_l2;
reg [`IRR_WIDTH-1:0] reg_ir;
reg reg_init;
reg_counter;
reg [`DATA_WIDTH-1:0] ir, p0, p1, p2;

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
reg ir_run_state
reg ir_run_state_next
// FSM: state transfer
always @(posedge clk) begin
    if (!rst_n) begin
        ir <= `RESET;
	ir_run_state <= `IR_FETCH;
    end else begin
        ir <= ir_next;
	ir_run_state <= ir_run_state_next;
    end
end

// FSM: state control logic
always @(ir or ir_run_state) begin
    case (ir) begin
        `RESET: begin
            if (init_finished) begin
                ir_next = `LOAD;
                ir_run_state_next = `IR_RUN;
            end else begin
                ir_next = `RESET;
                ir_run_state_next = ir_run_state;
            end
        end
        `LOAD: begin
            case (ir_excute_state) begin
                `IR_FETCH: begin
                    ir_next = ir;
		    ir_run_state_next = `IR_FETCH_P0;
                end
		// NEXT
                default: 
            end
        end
        default: np=next;
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
