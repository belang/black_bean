==============
Implementation
==============

Decoder
=======

The decoder decodes the instruction according to current state,
decides the next state and export control signals.

The input and state decide the next state and output.
Here let n_action and n_unit indicate the next excuting instruction.
The insput and state decide the n_action and n_unit,
and the next state is decided by n_action,
and the output is decided by both state and n_action/n_unit.

State
-----

==========  ==================================
state       discription
==========  ==================================
IDLE        initial state, hard reset
PAUSE       do not deal with input
READ_IR     the reading data is an instruction
READ_DA     the reading data is a data
WRITE       write data to memory
==========  ==================================

Instruction
-----------

Action:

==================  ========  ============
action              encode    decode(flag)
==================  ========  ============
ACTION_PAUSE        2'b00     3'b000      
ACTION_WRITE        2'b01     3'b001      
ACTION_READ_AR      2'b10     3'b010      
ACTION_READ_PC      2'b11     3'b100      
==================  ========  ============

Unit:

==============  ==============================================================
unit            discription
==============  ==============================================================
UNIT_NULL       stop
UNIT_IR         instruction register
UNIT_AR         address register
UNIT_DR0        operand 0 register
UNIT_DR1        operand 1 register
UNIT_CR         config register
UNIT_PC         program counter register
UNIT_ALU        wait the finished signal from the special ALU
==============  ==============================================================

ACTION_PAUSE:

==============  =========  ============
unit            encode     decode(flag)   
==============  =========  ============
UNIT_NULL       6'b000000  6'b000000
UNIT_IR         6'b000000  6'b000001
UNIT_AR         6'b000001  6'b000010
UNIT_DR0        6'b000010  6'b000100
UNIT_DR1        6'b000011  6'b001000
UNIT_CR         6'b000100  6'b010000
UNIT_PC         6'b000101  6'b100000
UNIT_ALU        6'b1*****  
==============  =========  ============

Output
------

The data register is controlled by the output flags o_unit_reg,
and the ALU modules is seleted by the output o_unit_alu.

The register is controlled by an enable signal which is decoded by module decoder,
but the ALU must decode the address by itself.
So the ALU module has a small units address decoder.

Because the read in data is ready on the next circle,
the flag_unit is needed to delay on circle, realized by one flag register.
If the instruction width is 16 bits,
which means the reading instruction and data are readed in in one circle,
the flag_unit is decoded directly from the i_unit.



Data Register
=============

PC
--

Program Counter is a 8 bits counter.
It counts the number of the program by the next instruction.
(Another methord is by the current state, not used here.)

The PC counts numbers when the instruction is:

1. The action is ACTION_READ_PC and the unit is not UNIT_PC.

The PC holds current value when the instruction is:

1. The action is ACTION_READ_AR and the unit is not UNIT_PC.

2. The action is ACTION_WRITE.

3. The action is ACTION_PAUSE.

The PC set the value as the input data when the instruction is:

1. The action is ACTION_READ_AR/PC and the unit is UNIT_PC.

In following situation,
the processor will excute some instructions stored in other places.

1. The action is ACTION_READ_AR and the unit is UNIT_IR.


ALU
===

Comparer
--------

Compare dr_0 and dr_1 datas, result is the relationship of dr_0
and dr_1. 
For example, if dr_0 is 1 and dr_1 is 20, the result is large.
The result is the ascii of >, <, =, and their combination.

