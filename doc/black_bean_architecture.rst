Introduction
============

BBISA is desined by the idea of data flow control.
The instruction is a data flow: source to target.
BBISA addresses each register and device ports.
The source and target are the core registers and MEM ports.
The outside device controller is connected to the MEM, so has the same address with the MEM.

Core Registers
==============

The arithmatic logic unit get its operands from data registers.
All ALUs share the same registers.
To config the ALU, read data to the config register.
The instruction address is from PC, and branch instruction is realize by setting the PC.
Target address is caculated in a special ALU: jump_condition.

There are two types of memory address source:
one is the next line address stored in the PC, and
the other is a direct address stored in a register(AR).
To support many addressing mode, caculate the address and save it to PC.

When read, the address is from address register(AR) or PC,
when write, the address is always in AR.

Instruction Set
===============

8-bit IS Encode
---------------

==============  =======  =======  =========================================================
unit            encode   china    discription
==============  =======  =======  =========================================================
REG_NULL       0000     空白     zero as source, null as target.
REG_IR         0001     指令     instruction register
REG_PC         0010     程序     program counter
REG_AR         0011     地址     address register
REG_DR0        0100     第一     operand register 0
REG_DR1        0101     第二     operand register 1
REG_CR         0110     算术     config register, not export data in it.
REG_BR         0111     分支     RESERVED 【branch config (relation, not full code)】
ALU_RE          1000     结果     ALU normal result
ALU_AD          1001     例外     ALU additional result
EMPTY           1010     保留     RESERVED
EMPTY           1011     保留     RESERVED
==============  =======  =======  =========================================================
MEM_PC     1100     控制     address from PC
MEM_AR     1101     原材     address from AR
MEM_OTH        1110     其它     another MEM ports.
MEM_NULL       1111     外空     no io action, used for multi-cycle arithmetic
==============  =======  =======  =========================================================

One 8-bit instruction consists of 4-bit source code and 4-bit target code.
The first 4-bit is the source, and last is the target.
The data flow from source to target.
For example, instruction 'MEM_PC/AR REG_DA0' means read data from MEM to data register 0,
and the address is in PC/AR.
Instruction 'REG_DA0 MEM_AR' means write value of data register 0 to MEM,
and the target address is in AR.

Not all combinations of instructions are valid, MEM_* to MEM_* is not supported now.
Because two outside devices io operation needs two address.

Machine Instruction
-------------------

====  ===================  ===============================================
type  machine instruction  description
====  ===================  ===============================================
0     source target        read source and send data to target
1     MEM_* REG_*        read MEM, write register
2     REG_* MEM_*        read register, write MEM
3     ALU_*  MEM_*        write ALU result to MEM
4     REG_* REG_*        register to register
5     ALU_*  REG_*        ALU result to register
6     MEM_* MEM_*        RESERVED
====  ===================  ===============================================
0.1   REG_PC REG_PC      hold, redo 
0.2   REG_CR *            special instruction.
0.3   MEM_NULL            RESERVED
0.4   *  ALU_*             RESERVED
0.5   *  REG_CR           config the ALU and enable its export.
1.1   MEM_AR REG_*   the address is from AR
1.2   MEM_PC REG_*   the address is from PC
2.1   REG_* MEM_AR   the address is from AR, 
2.2   REG_* MEM_PC   RESERVED
2.3   REG_* MEM_OTH      the address is from AR
3.1   ALU_*  MEM_*        the same as the REG_*

spcecial instruction:

===================  ===============================================
REG_NULL REG_NULL  stop
x_x      REG_IR     read instruction
x_x      REG_PC     jump
REG_CR  REG_PC     branch
REG_DR0 REG_DR0    DR0 <=  DR0 + 1
===================  ===============================================

Branch
------

Branch instruction is "REG_CR  REG_PC".
The full operation is that check if two datas match some relationship,
and according the result to select one of the target address as the output.
There are 6 inputs:

================  ====  =================
input             term  source
================  ====  =================
data0             D0    DR0
data1             D1    DR1
codition          CO    CR
branch address    BA    AR
next PC           NP    Program Counter
================  ====  =================

So the expression is if (D0 CO D1) then NP else BA.

Condition encode:

=======  ========
Type     Encode
=======  ========
<        8'h01
==       8'h02
>        8'h03
!<       8'h04
!=       8'h05
!>       8'h06
=======  ========

ALU config
----------

To secify ALU funtion, write data to CR.

==============  =======  =========================================================
ALU             encode   discription
==============  =======  =========================================================
ALU_ADD         8'h01    interge add
ALU_COMPARER    8'h00    en
ALU_JUMP_CON    8'h01    en
==============  =======  =========================================================

Addressing 
===========

Only surpport directly addressing currently.


DATA and Instruction are seved in the same memory.
This type structure is easier than the seperately saved structure.

PC Caculater only caculates the PC,
and the MEM selecte one of PC and AR as the address.
When write address is the PC, it changes the origin proram!

The address of other devices is only from AR.

The indirect addressing mode is only for function call.

The program is organized in page.
So to access one line, the target address is address in the program puls the base address of the page.

:TODO: add a base address register to store the base address.

Memory Management
=================

Cause of the data width of the architeture, the memory address is limited.
8 bits can only address 256 lines.
In currunt system, if the memory size exceeds the address space,
the exceeded space can not be used to run the program.

In Bean architeture, it supports unlimited memory size.
The technics are:

1. Use chip selection signals to select active memory core.
2. In one memory core, if the address width is wider than the data width,
   the processor core address register stores the lowest 8 bits,
   and the higher bits are writen to memory controller by a special instruction--
   "select memory(* MEM_PC)". 
   This instruction configs the memory address in the following sequence:
   A. memory chip selection
   B. base address 15:8
   C. base address 23:16

Features
========

1. The processor can excute some instructions stored in other places in program.
   That is the PC is still in the program,
   and current instruction can read instructions from a direct address,
   and excute them.
   That also is the processor don't jump to another section of instructions to
   excute them

2. Each instruction excutes in one cycle.
   That is every cycle, there is an instruction. The program is large.
3. Change the program dynamiclly.

   An instruction can write data to change the origin program.

TODO
====

1. PC relative addressing mode for control flow instrucitons.
