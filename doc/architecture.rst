============
Architecture
============

Introduction
============

Black bean processor is the stored program structure.

A program or an algorithm consists of some computation and the organization.
Nowadays, computation units maybe very complex and can afford some computaion task.
So a Central Process Unit(CPU) has thress parts: inner storage, controller and
arithmetic unit.
The process of excuting a program is read data from memory, send them to ALU,
and save data from ALU.
Each sub-circuit of ALU has a certain function maybe with some configuration.
Let assume that the sub-circuit has a fix function, so it does not need
control information.
The controller will control the read and write action with the write address.
When read, it sets the memory read address, read enable, and target register or
modules,
when write, it sets the memory write address, write enbale, and the write data
by selecte the right ALU.
So, black bean instruction set architercure(BBISA) is designed by this throught.
The black bean instruction consist of memory action, source address and target
address.

The word width of BBISA_v01 is 8bits.


DATA Register
=============

Some ALU needs two operands once, but the BB processor read one word once.
The BBP use data register 0 and 1(DR0/1) to store the operands.

Some ALU has more than one function mode,
so the BBP use config register(CR) to store the config information.

To read data from a direct address,
there is a address register(AR) to store the address.

.. for efficiency: AR and CR may share a register.

Features
========

1. The processor can excute some instructions stored in other places in program.
   That is the PC is still in the program,
   and current instruction can read instructions from a direct address,
   and excute them.
   That also is the processor don't jump to another section of instructions to
   excute them
