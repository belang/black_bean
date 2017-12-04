==============
Implementation
==============

General
=======

All instructions execute in one clock.

Memory
======

When read enbale and address is ready, the memory export readed data in the same clock.
So the action is the same as the core exportion, becasue the core exportion is that
select one of the register value.

Decoder
=======

The decoder decodes the instruction according to current state,
decides the next state and export control signals.
Not all instructions is decoded in Decoder.
Some convenient instructions are realized in the related function moduls.

The input and state decide the next state and output.
Here let n_source and n_target indicate the next excuting instruction.
The input and state decide the n_source and n_target,
and the next state is decided by n_source,
and the output is decided by both state and n_source/n_target.


State
-----

==========  ========================================
state       discription
==========  ========================================
IDLE        initial state, hard reset
PAUSE       do not deal with input
READ_IR     read instruction
TRANS_DA    access the memory or move core data [1]_
==========  ========================================

.. [1] The data bus and the enable signals are unique,
   and DECODER get instruction from reg_IR.

.. MOVE        data transfers between core regs and ALU
   SET_CR      set ALU config
   SET_AR      set address

state transfer
--------------

see pic decoder_state

Instruction Decode
------------------

The decoder exports enable signals for core regs and INS.
device_ien means the device get the input data,
and device_oen means the device export its value.

When the unit is the source, the unit exports data,
and is the target, it receives the data.
So the decode logic is devided to source_decode and target_decode.

Because read data 8 bits each clock, the data is ready in next clock,
so, the ioen signals must be stored for one clock.
If the data width is 16 bits,
which means the reading instruction and data are readed in in one circle,
the ioen is decoded directly from the i_target.

==========  ====================================================
state       output instruction
==========  ====================================================
IDLE        MEM, REG_IR
PAUSE       Null
READ_IR     input instruction
TRANS_DA    MEM, REG_IR
==========  ====================================================

Data Register
=============

Convenient Instruction
----------------------

Plus 1
~~~~~~

- Instruction: *REG_DR0 REG_DR0*

- Realize: If the source and target are both reg_DR0, then the o_reg_value is reg_DR0+1.

Branch Instruction
------------------

- Instruction: *REG_CR REG_PC*

- Realize: The o_reg_value is set to brancher.

Program Counter
---------------

Program Counter is a 8 bits counter.
It counts the number of the program by the next instruction.
(Another methord is by the current state, not used here.)

1. set PC from input data

   - * REG_PC : means jump where address is from PC or AR

2. current PC plus 1

   - MEM_PC !REG_PC    : means read instruction

3. hold current value

   other conditions:

   - MEM_AR    !REG_PC        : means read data
   - REG_*     MEM_*      : means write
   - REG_NULL  MEM_NULL   : means pause


ALU
===

Decode CR config infor locally.

Comparer
--------

Compare dr_0 and dr_1 datas, result is the relationship of dr_0
and dr_1. 
For example, if dr_0 is 1 and dr_1 is 20, the result is large.
The result is the ascii of >, <, =, and their combination.

MEM_AR
===========

Instruction interface has two address port, for addressing.
MEM_AR/PC deside using which address.

DATA BUS
========

:TODO:

Question
========

1. How to deal with multi clock reading and writing action?
   For example, read a memory need 5 clocks, and write to a register need 3 clocks,
   but in another type of memory, it needs only 4 clocks to read, and the writing clocks are the same.
   For decoder, it gives the read enable and write enable at the same time, or at different times?

