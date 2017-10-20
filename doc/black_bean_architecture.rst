============
Architecture
============

Introduction
============

Black Bean is a computer name.

The basic parts are the memory and processor.
The Black Bean processor consist of three parts: core, skin and interface of sore and skin(ISC).

Core is the main process unit,
skin is the outside device controller,
ISC is the connection between them, has bean addressed in the instruction set.

A Central Process Unit(CPU) has thress parts: register, controller and arithmetic unit.
The process of excuting a program is that read data from memory, send them to ALU, and save data from ALU.
Each sub-circuit of ALU has a certain function maybe with some configuration.
Assume that the sub-circuit has a fix function, so it does not need control information.
The controller will only control the read and write action with the right address.
When read, it sets the memory read address, read enable, and target register or modules,
when write, it sets the memory write address, write enbale, and the write data by selecte the right ALU.
So, black bean instruction set architercure(BBISA) is designed by this throught.

The word width of BBISA_v01 is 8bits.

DATA Register
=============

Some ALU needs two operands once, but the BB processor read one word once.
The BBP use data register 0 and 1(DR0/1) to store the operands.

Some ALU has more than one function mode,
so the BBP use config register(CR) to store the config information.

To read data from a direct address,
there is a address register(AR) to store the address.

Data Flow
=========

Instruction Source
------------------

The instruction is only from the IOSC_MEM or from other location such as IOSC_OTH, Core_output?
Currentlly, it is from all place.

Addressing
==========

Current is direct addressing.

TODO: Support diplacement addressing

Interrupt
=========

null

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
