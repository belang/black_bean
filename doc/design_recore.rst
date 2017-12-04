=============
Design Record
=============

Record the daily work.

- 2017-08-24
  Adjust the structure. Consider that if the BBISA can be a universal ISA.
- 2017-08-25
  Write the project code from the structure. Next to simu the core.
- 2017-08-28
  bb_core is ready to simulate. Next to write assembly compiler for BBISA.
- 2017-08-29
  design part BB Assembly Language(BBA), of which are directly consponded to the instruction.
- 2017-08-30
  compiler for BMI file to bmb simu file.
- 2017-08-31
  simu the rtl. to be continue.

- 2017-09-01
  succeed in simulation in writing an data from the immediate data to special memory address.
- 2017-09-05
  succeed in jump. change action instruction to source-target instruction.
  next Data register -> PC
- 2017-09-08
  restructure the core, change the instruction type to source -> target.
  next add IOSC_OTH data input support.
- 2017-09-11
  prepare to simulation
- 2017-09-15
  next to analyse the bai file.
- 2017-09-20
  assembly language is designed as a python function.
- 2017-09-26
  simulate while true loop succeeded!
  todo : 1. move address caculator; 2. design bracher.
- 2017-09-27
  rechange the brancher to ALU as a submodule. todo: continue to change the doc and verilog.
- 2017-09-30
  change: decoder only decode the origin input enable signals,
  the convenient instructions are realized in special relatied modules.
  next: unique data bus of core.

- 2017-10-11
  change: adjust data bus to two parts: skin data and core data;
  realize: brancher in verilog
  designing: compiler doc
  next: doc and branche BAI.
- 2017-10-12
  question: how to support addressing mode in parse?
  each mode function get the one part(source or target) of the instruction
- 2017-10-13
  Considering that memory read and write are two ports of core,
  so the two action can be doing at the same time.
  But the IO count is not enough.
  So keep current design.
  Change: transfer data state in decoder is memory access action.
- 2017-10-31
  Use gcc to generate Assembly Program and write a assembler to realize the machine code.
- 2017-11-01
  The first step is to interpret the code, and the seconde is to optimize the code.
  The interpreted code can excute directly.
- 2017-11-15
  adjust the state machine of the tokenizer.
- 2017-11-21
  generate the assembly command.
  generate the simulation hexadecimal string code.
