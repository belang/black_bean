
`define PORT_WIDTH 4
`define DATA_WIDTH 8
`define IRR_WIDTH `DATA_WIDTH
`define DATA_ADDR_WIDTH 8
`define IR_ADDR_WIDTH `DATA_ADDR_WIDTH
`define CTRL_BUS 16

// CONTROLLER
`define RESET                         8'h00
`define CONTINUE                      8'h01
`define EMPTY                         8'h02
`define RAW_BUS_0                     8'h03
`define RAW_BUS_1                     8'h04
`define OPERAND_W_ADDR                8'h05
`define OPERAND_R_BUS_0               8'h06
`define OPERAND_R_BUS_1               8'h07
`define TRANSFER_ADDR                 8'h08
`define TRANSFER_CONDITION            8'h09
`define STORE_RAW_BUS_0               8'h0a
`define STORE_RAW_BUS_1               8'h0b
// END CONTROLLER


// device
`define DEVICE_IR_REGFILE_READ      8'h01
`define DEVICE_IR_REGFILE_WRITE     8'h02
`define DEVICE_DATA_REGFILE_READ    8'h03
`define DEVICE_DATA_REGFILE_WRITE   8'h04
`define DEVICE_COMPUTING            8'h05
`define DEVICE_OUT_DEVICE           8'h06
`define DEVICE_CONTROLLER           8'h07
`define DEVICE_DATA_CASH            8'h08

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
