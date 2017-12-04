
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
`define REG_NULL        4'h0
`define REG_IR          4'h1
`define REG_PC          4'h2
`define REG_AR          4'h3
`define REG_DR0         4'h4
`define REG_DR1         4'h5
`define REG_CR          4'h6
`define REG_NULL1       4'h7
`define ALU_RE          4'h8
`define ALU_AD          4'h9
`define MEM_NULL2       4'ha
`define MEM_NULL3       4'hb
`define MEM_PC          4'hc
`define MEM_AR          4'hd
`define MEM_OTH         4'he
`define MEM_NULL        4'hf

`define INDEX_EN_NULL    0
`define INDEX_EN_IR      1
`define INDEX_EN_PC      2
`define INDEX_EN_AR      3
`define INDEX_EN_DR0     4
`define INDEX_EN_DR1     5
`define INDEX_EN_CR      6
`define INDEX_EN_NULL1   7
`define INDEX_EN_ALU_RE  8
`define INDEX_EN_ALU_AD  9
`define INDEX_EN_NULL2  10
`define INDEX_EN_NULL3  11
`define INDEX_EN_MEM_PC 12
`define INDEX_EN_MEM_AR 13
`define INDEX_EN_OTH    14
`define INDEX_EN_NULL4  15

// Config Register --  ALU encode
`define ALU_ADD         8'h01
`define ALU_COMPARER    8'h10
`define ALU_JUMP_CON    8'h11



