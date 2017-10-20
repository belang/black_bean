Introduction
============

BBISA is desined by the idea of data flow control.
The instruction is a data flow: source to target.
BBISA addresses each register and device ports.
The source and target are the core registers and SKIN ports.
The outside device controller is connected to the SKIN, so has the same address with the SKIN.

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

Instruction Encode
==================

8-bit ISA
---------

==============  =======  =======  =========================================================
unit            encode   china    discription
==============  =======  =======  =========================================================
CORE_NULL       0000     空白     zero as source, null as target.
CORE_IR         0001     指令     instruction register
CORE_PC         0010     程序     program counter
CORE_AR         0011     地址     address register
CORE_DR0        0100     第一     operand register 0
CORE_DR1        0101     第二     operand register 1
CORE_CR         0110     算术     config register, not export data in it.
CORE_BR         0111     分支     RESERVED 【branch config (relation, not full code)】
ALU_RE          1000     结果     ALU normal result
ALU_AD          1001     例外     ALU additional result
EMPTY           1010     保留     RESERVED
EMPTY           1011     保留     RESERVED
==============  =======  =======  =========================================================
SKIN_MEM_PC     1100     控制     address from PC
SKIN_MEM_AR     1101     原材     address from AR
SKIN_OTH        1110     其它     another SKIN ports.
SKIN_NULL       1111     外空     no io action, used for multi-cycle arithmetic
==============  =======  =======  =========================================================

One 8-bit instruction consists of 4-bit source code and 4-bit target code.
The first 4-bit is the source, and last is the target.
The data flow from source to target.
For example, instruction 'SKIN_MEM_PC/AR CORE_DA0' means read data from SKIN_MEM to data register 0,
and the address is in PC/AR.
Instruction 'CORE_DA0 SKIN_MEM_AR' means write value of data register 0 to SKIN_MEM,
and the target address is in AR.

Not all combinations of instructions are valid, SKIN_* to SKIN_* is not supported now.
Because two outside devices io operation needs two address.

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

Machine Instruction
-------------------

====  ===================  ===============================================
type  machine instruction  description
====  ===================  ===============================================
0     source target        read source and send data to target
1     SKIN_* CORE_*        read SKIN, write register
2     CORE_* SKIN_*        read register, write SKIN
3     ALU_*  SKIN_*        write ALU result to SKIN
4     CORE_* CORE_*        register to register
5     ALU_*  CORE_*        ALU result to register
6     SKIN_* SKIN_*        RESERVED
====  ===================  ===============================================
0.1   CORE_PC CORE_PC      hold, redo 
0.2   CORE_CR *            special instruction.
0.3   SKIN_NULL            RESERVED
0.4   *  ALU_*             RESERVED
0.5   *  CORE_CR           config the ALU and enable its export.
1.1   SKIN_MEM_AR CORE_*   the address is from AR
1.2   SKIN_MEM_PC CORE_*   the address is from PC
2.1   CORE_* SKIN_MEM_AR   the address is from AR, 
2.2   CORE_* SKIN_MEM_PC   RESERVED
2.3   CORE_* SKIN_OTH      the address is from AR
3.1   ALU_*  SKIN_*        the same as the CORE_*

spcecial instruction:

===================  ===============================================
CORE_NULL CORE_NULL  stop
x_x      CORE_IR     read instruction
x_x      CORE_PC     jump
CORE_CR  CORE_PC     branch
CORE_DR0 CORE_DR0    DR0 <=  DR0 + 1
===================  ===============================================

Addressing 
===========

DATA and Instruction are seved in the same memory.
This type structure is easier than the seperately saved structure.

PC Caculater only caculates the PC,
and the SKIN_MEM selecte one of PC and AR as the address.
When write address is the PC, it changes the origin proram!

The address of other devices is only from AR.

Branch
======

Branch instruction is "CORE_CR  CORE_PC".
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

