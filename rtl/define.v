
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

// core reg encode
`define CORE_NULL       4'h0
`define CORE_IR         4'h1
`define CORE_PC         4'h2
`define CORE_AR         4'h3
`define CORE_DR0        4'h4
`define CORE_DR1        4'h5
`define CORE_CR         4'h6
//`define CORE_EMPTY      4'h7
`define ALU_RE          4'h8
`define ALU_AD          4'h9
//`define CORE_EMPTY      4'ha
//`define CORE_EMPTY      4'hb
`define IOSC_INS_PC     4'hc
`define IOSC_INS_AR     4'hd
`define IOSC_OTH        4'he
`define IOSC_NULL       4'hf

// Config Register --  ALU encode
`define ALU_COMPARER    8'h01
`define ALU_JUMP_CON    8'h02



// core Decode
`define DC_AR               6'b000001
`define DC_CR               6'b000010
`define DC_PC               6'b000100
`define DC_DR0              6'b001000
`define DC_DR1              6'b010000
`define DC_NULL             6'b000000

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
