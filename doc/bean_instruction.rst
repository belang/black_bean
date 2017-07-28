======================================
bean instruction program specification
======================================


==================  =============================================
term                specification
==================  =============================================
value file          from which initial the memory.
instruction file    the file written in string type instruction
==================  =============================================

Instruction List
================

======================  =======
instruction             operand
======================  =======
RESET                         
CONTINUE                      
EMPTY                         
RAW_BUS_0               0x** 
RAW_BUS_1               0x** 
OPERAND_W_ADDR                
OPERAND_R_BUS_0               
OPERAND_R_BUS_1               
TRANSFER_ADDR                 
TRANSFER_CONDITION            
STORE_RAW_BUS_0               
STORE_RAW_BUS_1               
======================  =======

Writing instruction
===================

- EMPTY is not realized.
- RAW_BUS_0 and RAW_BUS_1 have operands, and the operands take one clock to
  read but can be in the same line following them.

Abuut Address
=============

Some numbers in the instruction are the memory address, which the data store.
For some reason, the line counts in the instruction files may be different from
that in the value files.
So the bean instruction compiler will change the address value.
