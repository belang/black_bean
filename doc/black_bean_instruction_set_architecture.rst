============================
Instruction Set Architecture
============================

Introduction
============

BBISA is desined by the idea of data flow control.
The instruction is a data flow: source to target.
BBISA addresses each register and device ports.
The source and target are the core registers and IOSC ports.
The outside device controller is connected to the IOSC, so has the same address with the IOSC.

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
CORE_NULL       0000     空白     no io action, used for multi-cycle arithmetic
CORE_IR         0001     指令     instruction register
CORE_PC         0010     程序     program counter
CORE_AR         0011     地址     address register
CORE_DR0        0100     第一     operand register 0
CORE_DR1        0101     第二     operand register 1
CORE_CR         0110     算术     ALU config register
EMPTY           0111     保留     RESERVED
ALU_RE          1000     结果     ALU normal result
ALU_AD          1001     例外     ALU additional result
EMPTY           1010     保留     RESERVED
EMPTY           1011     保留     RESERVED
==============  =======  =======  =========================================================
IOSC_INS_PC     1100     控制     address from PC
IOSC_INS_AR     1101     原材     address from AR
IOSC_OTH        1110     其它     another IOSC ports.
IOSC_NULL       1111     外空     no io action, used for multi-cycle arithmetic
==============  =======  =======  =========================================================

One 8-bit instruction consists of 4-bit source code and 4-bit target code.
The first 4-bit is the source, and last is the target.
The data flow from source to target.
For example, instruction 'IOSC_INS_PC/AR CORE_DA0' means read data from IOSC_INS to data register 0,
and the address is in PC/AR.
Instruction 'CORE_DA0 IOSC_INS_AR' means write value of data register 0 to IOSC_INS,
and the target address is in AR.

Not all combinations of instructions are valid, IOSC_* to IOSC_* is not supported now.
Because two outside devices io operation needs two address.

ALU config
----------

To secify ALU funtion, write data to CR.

==============  =======  =========================================================
ALU             encode   configuration
==============  =======  =========================================================
ALU_COMPARER    8'h00    en
ALU_JUMP_CON    8'h01    en
==============  =======  =========================================================

Addressing 
===========

DATA and Instruction are seved in the same memory.
This type structure is easier than the seperately saved structure.

PC Caculater only caculates the PC,
and the IOSC_INS selecte one of PC and AR as the address.
When write address is the PC, it changes the origin proram!

The address of other devices is only from AR.

Branch
======

==================  ===================================================================
IOSC_INS CORE_PC    jump directly
ALU_RE CORE_PC      jump conditionly when result is caculation by jump_condition module
==================  ===================================================================

