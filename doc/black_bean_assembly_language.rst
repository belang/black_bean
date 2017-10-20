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
IOSC_MEM_PC     1100 c   指令存储   
IOSC_MEM_AR     1101 d   地址存储
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
RE          ALU result
AD          ALU addition info
==========  ===========

CORE_NULL1      4'h7
ALU_RE          4'h8
ALU_AD          4'h9
SKIN_NULL2      4'ha
SKIN_NULL3      4'hb
SKIN_MEM_PC     4'hc
SKIN_MEM_AR     4'hd
SKIN_OTH        4'he
SKIN_NULL       4'hf



Bean Assembly Instrution
========================

=======  ===========
Terms    Description
=======  ===========
reg      register name, include all ports defined in machine instructions.
data     immediate data in string format such as 8'h01
label    a user define string
v1       varialbe 1, maybe data or register
rel      relation: <, ==, >, !<, !=, !>
=======  ===========

============================  ================  ===========
Instrution                    Action            Description
============================  ================  ===========
set reg data                  Reg <= Data       set immediate data to register
add1                          Reg0 <= Reg0+1    register data0 add 1
load reg addr                 Reg <= Mem(addr)
save addr reg                 Mem(addr) <= Reg
if v1 rel v2                                    if v1 is a variable, set the value to DR0,
                                                is a data, set to DR0,
                                                is reg, set to DR0,
                                                is DR0, no action;
                                                v2 is saved at DR1.
endif
while v1 rel v2                                 v1/v2 is processed the same as if.
endwhile
exit                          00
v1                            excute v1         if v1 is a function, call function
print v                                         load to oth.
v = v+v
============================  ================  ===========

=========================  =============  ======================================================
data                       8'h**          datas are written in hexadecimal.
veriable                   [_0-9a-zA-Z]   veriable names and keys.
expr                                      expression of bean assembly instruction
=========================  =============  ======================================================
