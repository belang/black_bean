==================
Action Instruction 
==================

Introduction
============

Action Instruction Set(AIS) realize the arithmetic by control the data flow.
The action instruction set is to control the data goto and outof memory.
The ALU get data from data registers,
the instruction address is from PC,
and branch instruction is realize by setting the PC,
value of which is caculated in a special ALU: jump_condition.
To config the ALU, read data to the config register.

Action Instruction Code
=======================

Action instruction consists of three parts: action, target, address.
Action is read or write the memory,
source is the read address or the ALU data
target is the write address or register to store the read data.

There are two types of memory address source:
one is the next line address stored in the PC, and
the other is a direct address stored in a register(AR).
To support many addressing mode, caculate the address and save it to PC.

When write, the target is fixed and address is always in AR, and
when read, the address is from the AR storing direct address or
PC storing next program address.
So to left more codes for units, the instruction is shorten to two parts:
action and units address.

Action:

  It is the action of read and write memory.
  It includs fetch IR, read data and write data.
==========  ======  =========================================================
type        code    discription
==========  ======  =========================================================
action      00      PAUSE, no read and write, used for multi-cycle arithmetic
                    and stop
            01      WRITE, write data to memory
            10      READ_AR, read data from AR
            11      READ_PC, read data from PC
==========  ======  =========================================================

Read:

==========  ======  ==================================
type        code    discription
==========  ======  ==================================
action      10      READ_DA
            11      READ_IN
d_target    000000  IR
            000001  AR
            000010  DR0
            000011  DR1
            000101  PC
==========  ======  ==================================

Write:

==========  ======  ==================================
type        code    discription
==========  ======  ==================================
action      10      WRITE
d_source    000000  IR
            000001  AR
            000010  DR0
            000011  DR1
            000100  CR config
            000101  PC
            1xxx    ALU
==========  ======  ==================================



For Efficiency
==============

- Store write data(ALU result) in a result_regist.

  If the read address is the same with the last writing address,
  it read data from the result register directly,
  without read memory.

  It is very usefull for jump address caculation.
