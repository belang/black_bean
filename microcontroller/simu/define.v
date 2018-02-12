
`define PORT_WIDTH 4
`define DATA_WIDTH 8
`define IR_WIDTH `DATA_WIDTH
`define DATA_ADDR_WIDTH 16
`define IR_ADDR_WIDTH `DATA_ADDR_WIDTH
`define ROM_ADDR_WIDTH `DATA_ADDR_WIDTH
`define RAM_ADDR_WIDTH `DATA_ADDR_WIDTH

// action encode
`define ACTION_PAUSE    2'b00
`define ACTION_WRITE    2'b01
`define ACTION_READ_AR  2'b10
`define ACTION_READ_PC  2'b11

// core reg encode
`define NULL      4'h0
`define ROM       4'h1
`define RAM       4'h2
`define PC        4'h3
`define AR        4'h4
`define CR        4'h5
`define RE        4'h6
`define AD        4'h7
`define PA        4'h8
`define PD        4'h9
`define DR0       4'ha
`define DR1       4'hb
`define DR2       4'hc
`define DR3       4'hd
`define AP        4'he
`define CO        4'hf

// port encode
`define PORT0    8'h00
`define PORT1    8'h01
`define PORT2    8'h02


`define INDEX_EN_NULL    0
`define INDEX_EN_IR      1
`define INDEX_EN_PC      2
`define INDEX_EN_AR      3
`define INDEX_EN_DR0     4
`define INDEX_EN_DR1     5
`define INDEX_EN_CR      6
`define INDEX_EN_DR2     7
`define INDEX_EN_RE      8
`define INDEX_EN_AD      9
`define INDEX_EN_NULL2  10
`define INDEX_EN_NULL3  11
`define INDEX_EN_MEM_PC 12
`define INDEX_EN_MEM_AR 13
`define INDEX_EN_OTH    14
`define INDEX_EN_NULL4  15

// Config Register --  ALU encode
`define ALU_TRUE        8'hff
`define ALU_FALSE       8'h00
`define ALU_SMALLER     8'h01
`define ALU_EQUAL       8'h02
`define ALU_LARGER      8'h03
`define ALU_NSMALLER    8'h04
`define ALU_NEQUAL      8'h05
`define ALU_NLARGER     8'h06
`define ALU_ADD         8'h10
`define ALU_MINUS       8'h11
`define ALU_MUL         8'h12
`define ALU_MOD         8'h13
`define ALU_COUNTER     8'h20
`define ALU_COUNTER_AUTO        8'h21
`define ALU_COUNTER_TRIGGER     8'h22
`define ALU_COUNTER_RESET       8'h23
`define ALU_COUNTER_OUT         8'h24
`define ALU_COUNTER_AD          8'h25

// interrupt decode
`define INTERRUPT_STOP         8'h10
`define INTERRUPT_RESET        8'h11
`define INTERRUPT_PAUSE        8'h12


