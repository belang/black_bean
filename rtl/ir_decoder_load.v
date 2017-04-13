`timescale 1ns/1ps
// file name: ir_decoder_load.v
// author: lianghy
// time: 2017-4-13 15:58:23

// read p2 == write ir regfile
`define IDLE                4'H0
`define READ_P0             4'H0
`define READ_P1             4'H0
`define WRITE_IR_REGFILE    4'H0

`define INIT_IR_LINES        `DATA_WIDTH'hff

module ir_decoder_load(
input clk,
input rst_n,
init,
en,
data_in,
);

state, state_next;

// FSM: state reg
always @(posedge clk) begin
    if (!rst_n) begin
        state <= `IDLE;
    end else begin
        state <= state_next;
    end
end

// FSM: state transfer
always @(init or en or state) begin
    if (init) begin
        case (state) begin
            `IDLE: state_next = `READ_CASH;
            `READ_CASH: state_next = `WRITE_IR_REGFILE;
            `WRITE_IR_REGFILE: begin
                if (counter==`INIT_IR_LINES) begin
                    state_next = `IDLE;
                end else begin
                    state_next = `READ_CASH;
                end
            end
            default: state_next = state;
        end
    end else begin
    if (en) begin
        case (state) begin
            `IDLE: state_next = `READ_P0;
            `READ_P0: state_next = `READ_P1;
            `READ_P1: state_next = `WRITE_IR_REGFILE;
            `READ_CASH: state_next = `WRITE_IR_REGFILE;
            `WRITE_IR_REGFILE: begin
                if (counter==`INIT_IR_LINES) begin
                    state_next = `IDLE;
                end else begin
                    state_next = `READ_CASH;
                end
            end
            default: state_next = state;
        end
    end else begin
        state_next = state;
    end
end

// FSM: state output NEXT
always @(init or en or state) begin
    if (init) begin
        case (state) begin
            `IDLE: begin
                p0_next = `DATA_WIDTH'h00;
                p1_next = `DATA_WIDTH'h00;
                p2_next = `INIT_IR_LINES;
                counter_in = `DATA_WIDTH'h00;
                counter_set = 1'b1;
                counter_trigger = 1'b0;
                addr_next = `DATA_WIDTH'h00;
                cash_ren = 1'b0;
                ir_regfile_ren = 1'b0;
                ir_regfile_wen = 1'b0;
            end
            `READ_CASH: begin
                p0_next = p0;
                p1_next = p1;
                p2_next = p2;
                counter_in = `DATA_WIDTH'h00;
                counter_set = 1'b0;
                counter_trigger = 1'b0;
            end
            `WRITE_IR_REGFILE: begin
                p0_next = p0;
                p1_next = p1;
                p2_next = p2;
                counter_in = `DATA_WIDTH'h00;
                counter_set = 1'b0;
                counter_trigger = 1'b1;
                if (counter==`INIT_IR_LINES) begin
                    counter_next = `DATA_WIDTH'h00;
                end else begin
                    counter_next = counter+`DATA_WIDTH'h01;
                end
            end
            default: state_next = state;
        end
    end else if (en) begin
        case (state) begin
            `IDLE: state_next = `READ_CASH;
            `READ_CASH: state_next = `WRITE_IR_REGFILE;
            `WRITE_IR_REGFILE: begin
                if (counter==`INIT_IR_LINES) begin
                    state_next = `IDLE;
                end else begin
                    state_next = `READ_CASH;
                end
            end
        end
    end else begin
        default: state_next = state;
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

endmodule
