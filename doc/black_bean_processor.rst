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
TRANS_DA    read data or write data
==========  ========================================

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
IDLE        ISC_INS, CORE_IR
PAUSE       Null
READ_IR     input instruction
TRANS_DA    ISC_INS, CORE_IR
==========  ====================================================

==============  ==========  ==========
Instruction     source      target
==============  ==========  ==========
ISC_*           ins*_oen    ins*_ien
CORE_*          reg*_oen    reg*_ien
ALU_*           alu*_oen    RESERVED
==============  ==========  ==========

==================  =====================================================
output signals      discription
==================  =====================================================
o_isc_selection     select the ISC which export data to or read data from
==================  =====================================================

Data Register
=============

i_data_source_type      1: input data is from ISC

Address Caculater(PC)
=====================

Program Counter is a 8 bits counter.
It counts the number of the program by the next instruction.
(Another methord is by the current state, not used here.)

1. set PC to input data

   - * CORE_PC : means jump where address is from PC or AR

2. current PC plus 1

   - ISC_INS_PC !CORE_PC    : means read instruction

3. hold current value

   other conditions:

   - ISC_INS_AR !CORE_PC        : means read data
   - CORE_*      ISC_INS_*      : means write
   - CORE_NULL   ISC_INS_NULL   : means pause


ALU
===

Decode CR config infor locally.

Comparer
--------

Compare dr_0 and dr_1 datas, result is the relationship of dr_0
and dr_1. 
For example, if dr_0 is 1 and dr_1 is 20, the result is large.
The result is the ascii of >, <, =, and their combination.

ISC INS
=======

Instruction interface has two address port, for addressing.
ISC_INS_AR/PC deside using which address.


Question
========

1. How to deal with multi clock reading and writing action?
   For example, read a memory need 5 clocks, and write to a register need 3 clocks,
   but in another type of memory, it needs only 4 clocks to read, and the writing clocks are the same.
   For decoder, it gives the read enable and write enable at the same time, or at different times?

