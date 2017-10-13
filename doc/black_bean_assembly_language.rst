############
Introduction
############
Bean assembly language consits of two parts: bean machine instruction and bean assembly instruction.
A program can be writen in any one of the two instruction, or both.
The BAI do not have the same instruction as BMI.
A file with postfix .bmi is a BMI file, but that with .bai is mixed.

########################
Bean Machine Instruction
########################

Bean Machine Instruction(BMI) map the instruction list defined in define.v.

==============  =======  ========
unit            encode   china  
==============  =======  ========
CORE_NULL       0000 0   空白   
CORE_IR         0001 1   指令   
CORE_PC         0010 2   程序   
CORE_AR         0011 3   地址   
CORE_DR0        0100 4   第一   
CORE_DR1        0101 5   第二   
CORE_CR         0110 6   算术   
EMPTY           0111 7   保留   
ALU_RE          1000 8   结果   
ALU_AD          1001 9   例外   
EMPTY           1010 a   保留   
EMPTY           1011 b   保留   
==============  =======  ========
IOSC_INS_PC     1100 c   指令存储   
IOSC_INS_AR     1101 d   地址存储
IOSC_OTH        1110 e   其它   
IOSC_NULL       1111 f   外空   
==============  =======  ========

############################
Computing Module Instruction
############################

Computing Module Instruction(CMI) is the encode of the computing module.
It is related to the realize of the processor.
If the input and output of different processors are the same,
the CMI is universal.
So an important thing is defining the operation.

==============  ========  =====================
ALU             encode    china
==============  ========  =====================
ALU_COMPARER    00000000  比较
ALU_JUMP_CON    00000001  分支
==============  ========  =====================

#########################
Bean Assembly Instruction
#########################

Bean Assembly Instruction(BAI) is the instruction for convenient program.

Addressing Mode
===============

================  =======  =======
address type      example  compute
================  =======  =======
register          DR1      
immediate         8'h01
direct            (8'h01)  Mem[8'h01]
memory indirect   @8'h01   Mem[Mem[8'h01]]
================  =======  =======

Registers
=========

==========  ===========
name        description
==========  ===========
IR          instruction register
PC          program counter
AR          address register
DR0         data register 0
DR1         data register 1
CR          config register
==========  ===========

CORE_NULL1      4'h7
ALU_RE          4'h8
ALU_AD          4'h9
SKIN_NULL2      4'ha
SKIN_NULL3      4'hb
SKIN_INS_PC     4'hc
SKIN_INS_AR     4'hd
SKIN_OTH        4'he
SKIN_NULL       4'hf



Bean Assembly Instrution
========================

=======  ===========
Terms    Description
=======  ===========
reg      register name
data     immediate data in string format such as 8'h01
label    a user define string
v1       varialbe 1, maybe data or register
rel      relation: <, ==, >, !<, !=, !>
=======  ===========

============================  ================  ===========
Instrution                    Action            Description
============================  ================  ===========
let(reg, data)                Reg <= Data       set immediate data to register
add1                          Reg0 <= Reg0+1    register data0 add 1
set_block(label)                                set a line label
jump(label)                                     jump to label directly
branch(v1, v2, rel, label)                      The default value of v1 is DR0, of v2 is DR1.
                                                If they are set, then move data to DR0 and DR1.
============================  ================  ===========

=========================  =============  ======================================================
data                       8'h**          datas are written in hexadecimal.
veriable                   [_0-9a-zA-Z]   veriable names and keys.
expr                                      expretion of bean assembly instruction
=========================  =============  ======================================================
   
operations:

===================  ========================================================================================
A                    address
D                    data
R                    register
V                    veriable
A-V                  all addresses upside
r                    computing result
===================  ========================================================================================
*Data transfers*
load R    A          load data to register, A is the memory address.
let  R    D          load data to register, D is an immediate data.
move R/r  R          load data to register.
save R/A  R/r        save data to memory. 
jump V               jump to label with name V.
add  R/V/A A-V .     add data and write to register or veriable or immediate address
add1 DR0/V           use DR0 to realize.
===================  ========================================================================================
*compiler relative*
set V AD             set a memory address for a veriable.
block *veriable*     set a block label
===================  ========================================================================================


