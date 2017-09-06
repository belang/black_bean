============================
Instruction Set Architecture
============================

Introduction
============

BBISA is desined by the idea of data flow control.
The instruction is a data flow: source to target.
BBISA addresses each register and device ports.
The source and target are the core registers and ISC ports.
The outside device controller is connected to the ISC, so has the same address with the ISC.

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

==============  =========================================================
unit            discription
==============  =========================================================
CORE_NULL       no io action, used for multi-cycle arithmetic
CORE_IR         instruction register
CORE_PC         program counter
CORE_AR         address register
CORE_DA0        operand register 0
CORE_DA1        operand register 1
CORE_CR         ALU config register
CORE_ALU_*      ALU result
==============  =========================================================
ISC_INS_NULL    no io action, used for multi-cycle arithmetic
ISC_INS_AR      instruction program address from AR
ISC_INS_PC      instruction program address from PC
ISC_OTHERS_AR   other ISC ports.
==============  =========================================================

The instruction is source_target.
For example, instruction 'ISC_INS_PC CORE_DA0' means read data from ISC_INS to data register 0,
and the address is from PC.
Instruction 'CORE_DA0 ISC_INS_AR' means write value of data register 0 to ISC_INS,
and the target address is from AR.


For Efficiency
==============

- Store write data(ALU result) in a result_regist.

  If the read address is the same with the last writing address,
  it read data from the result register directly,
  without read memory.

  It is very usefull for jump address caculation.

- AR auto increment.
  When READ_AR, AR auto increment one row.

- Each ALU has a special registers.

- Surpport more ALUs.
  Use config register and CORE_ALU_* to select ALU result.
