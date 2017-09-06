==============
Implementation
==============

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
READ_IR     the reading data is an instruction
READ_DA     the reading data is a data
WRITE       write data to memory
==========  ========================================

state transfer
--------------

==========  ==========================================================
state       next instruction(STATE)
==========  ==========================================================
IDLE        READ_IR
PAUSE       PAUSE
READ_IR     input instruction
            PAUSE    << n_source = ISC_INS_NULL, n_target = CORE_NULL
            READ_IR  << n_source = ISC_INS_PC/AR, n_target = CORE_IR
            READ_DA  << n_source = ISC_INS_PC/AR, n_target = CORE_DR
            WRITE    << n_source = CORE_*, n_target = ISC_INS_AR
READ_DA     READ_IR
WRITE       READ_IR
DEFAUL      PAUSE
==========  ==========================================================

Output
------

The decode exports enable signals and selection signals.

Because the read in data is ready on the next circle,
the flag_target is needed to delay on circle, decoded from state.
If the instruction width is 16 bits,
which means the reading instruction and data are readed in in one circle,
the flag_target is decoded directly from the i_target.

But the flag_source is decoded from n_source, because when read instruction, the n_source is the readed in instruction.

==========  ==============================================
state       next instruction output
==========  ==============================================
IDLE        n_source = ISC_INS_PC, n_target = CORE_IR
PAUSE       n_source = ISC_INS_NULL, n_target = CORE_NULL
READ_IR     n_source = i_source, n_target = i_target
READ_DA     n_source = ISC_INS_PC, n_target = CORE_IR
WRITE       n_source = ISC_INS_PC, n_target = CORE_IR
==========  ==============================================


Data Register
=============

PC
--

Program Counter is a 8 bits counter.
It counts the number of the program by the next instruction.
(Another methord is by the current state, not used here.)

1. set PC to input data plus 1

   - ISC_INS_AR/PC CORE_PC : means jump where address is from PC or AR

2. hold current value

   - ISC_INS_AR !CORE_PC        : means read data
   - CORE_*      ISC_INS_*      : means write
   - CORE_NULL   ISC_INS_NULL   : means write

3. current PC plus 1

   - ISC_INS_PC !CORE_PC    : means read instruction

ALU
===

Comparer
--------

Compare dr_0 and dr_1 datas, result is the relationship of dr_0
and dr_1. 
For example, if dr_0 is 1 and dr_1 is 20, the result is large.
The result is the ascii of >, <, =, and their combination.

