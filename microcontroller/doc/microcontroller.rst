
Contents:

.. toctree::
   :maxdepth: 2

   next.rst
   testcase.rst

Introduction
============

This is a 8 bits microcontroller, designed taking 8051 as a reference.

Architecture
============

ROM   address width  16
RAM   address width  16

Data Bus
--------

Three state data bus has very risk of being undriven or multi driven.
Use a bus module to control all data flow.

IO
--

Interrupt(Port 0)
~~~~~~~~~~~~~~~~~

==========  =======  =======
Type        Encode   Action
==========  =======  =======
immedieate  1x       
delayed     8x
stop        10       lock the PC
reset       11       set rst_n to 1'b0 for one clock
pause       12       lock the PC, waiting for exception
==========  =======  =======


Assembly Coding
===============

====  =============  ========
code  abbreviation   function
====  =============  ========
00    NULL           0000
01    ROM            program rom
02    RAM            data ram
03    PC             program counter
04    AR             address low
05    CR             ALU configure register
06    RE             ALU output, result.
07    AD             ALU output, additional data, such as overflow
08    PA             port address
09    PD             port data
0a    DR0            common register, alu data 0
0b    DR1            common register, alu data 1
0c    DR2            common register, off chip address L
0d    DR3            common register, off chip address H
0e    AP             RESERVED append. APxxxx, append some info to the prior target.
0f                   
====  =============  ========


ALU
---

Submodules: counter, comparer, adder.


CR code

=======  =========  
Encode   Type     
=======  ========  
8'h00    re is 8'h00        
8'h01    <        
8'h02    ==       
8'h03    >        
8'h04    !<       
8'h05    !=       
8'h06    !>       
8'h0e    
8'h0f    
8'h10    `+`      
8'h11    `-`      
8'h12    `*`      
8'h13    `/`      
8'h20    set counter mode
8'h21    set auto mode
8'h22    trigger counter, in counter mode, triggered by rise edge.
8'h23    reset counter
8'h24    counter output
8'hff    re is 8'hff
=======  ================

Counter
~~~~~~~

====  ===========
DR0   start value
DR1   stop  value, 0 means no stop.
====  ===========

In counter mode, the stop value is no use. #if stop value is not 8'h00, count in circle, else stop at the stop value.

Export
~~~~~~

The counter has one port but two types of value:
in counter mode, it is the current value in reg_counter,
in auto counte mode, it is that if it reach the max value.

Port
----

=======  =========
addr     type
=======  =========
8'h00    Port0: Intrrupt 
8'h01    Port1 
8'h02    Port2 
=======  =========

Port1
~~~~~

active port. It is controller by the core to read or write a data.
The chip only catches the signls on pins when reading the port.

Port2
~~~~~

Half active port. There is a data cash in the port, so outside device can write data to the cash of port2.


Assembly Instruction
====================

General Assembly Instruction
----------------------------

==========  ===========
assembly    description
==========  ===========
NULL NULL   stop
DR0  NULL   next, read next instrutor
PC   PC     jump, set PC as the latched data or PC+1, according to CR(RE)
CR   CR     config some unit
xxxx ROM    RESERVED
xxxx NULL   RESERVED
xxxxxxxxx   to consider more.
PD   NULL   pause, wait for wakeup from interrupt.
==========  ===========


Memory Addressing
-----------------

To support larger memory space and more device, the address width must be wide enough, and much wider than the data.
For extendable, setting address mothed is designed as a same instruction--xx+AR.
One instruction only move the same bits of addrees as the data bus.
To config all address, if there are more than one continuous setting address instruction,
the AR shifts input address as a step of the width of data.
For example, set that AR width is 16 bits, and data width is 8 bit.
Current AR is 16'h0101.
The first instruction is DR0+AR, and data in DR0 is 8'h0a, the AR is set as 16'h010a.
The second instruction is DR1+AR, and data in DR1 is 8'h1f, the AR shifts data as 16'h0a1f.
If the second instruction is DR0+AR, the AR is set as 16'h0a0a then.
To save the address has a similar operation.
AR+DR0, copy AR lower 8 bits to DR0, and AR+DR0 straight after it copy AR higher 8 bits to DR1.

The PC has similar mode.
When "!PC PC", set PC_latch, when "PC PC", update PC with PC_latch.
Set DR0 is ff, DR1 is 11, DR2 is 22:

==========  ================  ===
ir          PC_Latched        PC 
==========  ================  ===
DR0 PC      16'h00ff          16'h0001
DR1 PC      16'hff11          16'h0002
PC  PC                        16'hff11
----------------
DR0 PC      16'h00ff          16'h0001
DR0 PC      16'hffff          16'h0002
PC  PC                        16'hffff
----------------
DR0 PC      16'h00ff          16'h0001
ROM DR0                       16'h0002
8'h11                         16'h0003
DR0 PC      16'hff11          16'h0004
PC PC                         16'hff11
==========  ================  ===

Port Addressing
---------------

Port is addressed by the PA and PD.

Brancher
--------

For if statement, the jump address is stored in AR.
When jump, just input instruction "AR PC" once or twice, according to the distance of the offset address.
The jump instruction is:

* set PC(direct address)
* set PC(base address)
* set data
* set relation
* PC PC

The "PC PC" take the result of compare(saved in RE) as the indication of update or not.
If the result is true, it executes next instruction, or else load the instruction by address that set to PC(PC_latch).

Program
=======

Memory Location
---------------

Each function is placed at the start of a page whose address width is 8 bits.

Reset
-----

There are three types of reset: hard reset - reset by the reset pin;
soft reset - by reset command; inter reset - by interrupt.
Both latter two types only reset the PC value to 00.

Bean Language
-------------

Supported
~~~~~~~~~

* y = a+b*(c+d)
* if x > y, if 10 > 100, if a
* while x > y; while true; while a
* m.f(a, 10)
* counter start stop
* counter 8'he8

Next
~~~~

* y = x.value() + b

Bean Assembly
-------------

1. Data: All data must be written in hexadecimal type with the width of the data bus.

Compiler
--------

.bea is bean program in bean language, with number in verilog format.
.bai is bean assembly program with number in hexadecimal format.

* add stop to the end of each program file.

Lexer
~~~~~

In token, data is in verilog format

Parser
~~~~~~

When get a immediate data, change format to hexadecimal format without prefix.

* The end of program: call self.state_end_block(lex.Token(0, "end", "true"))
* set: set the device as the immediate data.
* load: set the device as the value of other device.
* jump: each target place set a label to the line_label_dict,
  each jump place point to a line_label_dict object.
  line_label_dict = {"lable_num":(line_num, type, name)}
  line_label_dict = {"10":(8'h08, "function", "hello")}
* if: create a "Cite Line" line at if statement;
  append current line num to cite_line_stack as a link to this line;
  replace the cite_line_stack.pop() line as current line num, at else or end of if.
* while: 
  store line num to line_num_stack;
  append "Cite Line" line num to cite_line_stack;
  at the end of while, set go back target as line_num_stack;
  replace line with number of cite_line_stack.pop() as current line num.

Test Case
---------

1. write a data to ram. write ef to ram[1].
2. jump. P0: write ef to ram[1]; P1: jump to P3; P2: write ab to ram[2]; P3: write ff to ram[3],  
3. counter(program counter.bea). set interrupt is 8'h81, the counter should count every two clock.
