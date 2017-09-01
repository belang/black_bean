======================
Bean Assembly Language
======================

Introduction
============

Bean assembly language consits of two parts: bean machine instruction and bean assembly instruction.
A program can be writen in any one of the two instruction, or both.
The BAI do not have the same instruction as BMI.
A file with postfix .bmi is a BMI file, but that with .bai is mixed.

Bean Machine Instruction
========================

Bean Machine Instruction(BMI) map the instruction list defined in define.v.

==============  =========
BMI             binary
==============  =========
ACTION_PAUSE    2'b00
ACTION_WRITE    2'b01
ACTION_READ_AR  2'b10
ACTION_READ_PC  2'b11
UNIT_NULL       6'b000000
UNIT_IR         6'b000001
UNIT_AR         6'b000010
UNIT_DR0        6'b000011
UNIT_DR1        6'b000100
UNIT_CR         6'b000101
UNIT_PC         6'b000110
ALU_COMPARER    6'b100001
ALU_JUMP_COND   6'b100010
==============  =========

Bean Assembly Instruction
=========================

Bean Assembly Instruction(BAI) is the instruction for convenient program.

==========  ======================  ===============================================
Chinese     Assembly language       Function         
==========  ======================  ===============================================
标志        lable_(*name*) *data*   set line label *name*, and the value *data*
==========  ======================  ===============================================

Program of Function
===================

Load Data
---------

==============  ===============================
command         action
==============  ===============================
immediate       set reading address to data bus
empty
mem_r_addr
dr_0
==============  ===============================

Save Data
---------

==============  ===============================
command         action
==============  ===============================
c_module*       set writing data to data bus
mem_w_data
mem_w_addr      enable save data 
==============  ===============================

JUMP
----

compare and jump condition

methord one:

compare two data a and b, save to c,
compare c and condition, save to d,
read d and address to jump_condition unit, save to e,
read e to AR
jump AR

jump_condition unit : if condition is Ture, then the address is exported, else
exports the PC+1.

methord three:

compare two data a and b, save to c,
read c and condition to address_caculator,
read address to AR
save address_caculator result to e
read e to AR
jump AR

methord two:

compare two data a and b, save to c,
read c and condition to address_caculator,
read address to AR
jump_condition

address_caculator : if match, then exports the address, else exports PC+1
==================  ==============================================
command             action
==================  ==============================================
set_ar              read data to compare data a 
'data'           
r_mem_to_dr0          
set_ar              read data to compare data a 
'data'           
r_mem_to_dr0        
result_of_comparer  get the relationship of a and b
set_ar              save relationship
'data'
w_memory
set_ar              read relationship
'data'
r_mem_to_dr0        
set_ar              read condition
'data'              
r_mem_to_dr1        
set_ar
'data'              true address
jump_condition
==================  ==============================================

jump directly

==================  ==============================================
set_ar
'data'              jump addr
jump_addr       
==================  ==============================================


