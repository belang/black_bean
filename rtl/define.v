
`define PORT_WIDTH 4
`define DATA_WIDTH 8
`define IR_WIDTH `DATA_WIDTH
`define DATA_ADDR_WIDTH 8
`define IR_ADDR_WIDTH `DATA_ADDR_WIDTH
`define CTRL_BUS 16

// action encode
`define ACTION_PAUSE    2'b00
`define ACTION_WRITE    2'b01
`define ACTION_READ_AR  2'b10
`define ACTION_READ_PC  2'b11

// data reg encode
`define UNIT_NULL       6'b000000
`define UNIT_IR         6'b000000
`define UNIT_AR         6'b000001
`define UNIT_DR0        6'b000010
`define UNIT_DR1        6'b000011
`define UNIT_MR         6'b000100
`define UNIT_PC         6'b000101

// alu encode
`define ALU_COMPARER    6'b100001
`define ALU_JUMP_COND   6'b100010

// data reg Decode
`define DU_IR               6'b000001
`define DU_AR               6'b000010
`define DU_DR0              6'b000100
`define DU_DR1              6'b001000
`define DU_CR               6'b010000
`define DU_PC               6'b100000
`define DU_NULL             6'b000000

// address Decode
`define ADDR_FROM_AR        1'b0
`define ADDR_FROM_PC        1'b1

// memory action
`define MEM_READ         2'b01
`define MEM_WRITE        2'b10
`define MEM_PAUSE        2'b00



// OUT_DEVICE
`define PORT_MEM_IR             8'h01
`define PORT_MEM_DATA_READ      8'h02
`define PORT_MEM_DATA_WRITE     8'h03

// COMPUTING
`define PORT_ADDED_DATA     8'h01 
`define PORT_ADD_DATA       8'h02 
`define PORT_ADD_RESULT     8'h03 
`define PORT_ADD_CARRY      8'h04 
`define PORT_MINUSED_DATA   8'h05 
`define PORT_MINUS_DATA     8'h06 
`define PORT_MINUS_RESULT   8'h07 
`define PORT_MINUS_CARRY    8'h08 
`define PORT_COMPARE_DATA   8'h09 
`define PORT_COMPARED_DATA  8'h0a 
`define PORT_COMPARE_RESULT 8'h0b 

// CONTROLLER
`define PORT_JUMP_LARGER    8'h01 
`define PORT_JUMP_SMALLER   8'h02 
`define PORT_JUMP_EQUAL     8'h03 
`define PORT_JUMP_UNEQUAL   8'h03 
`define PORT_JUMP_DIRECT    8'h04 
`define PORT_JUMP_ADDR      8'h04 
`define PORT_WAIT           8'h05 
`define PORT_STOP           8'h00 
