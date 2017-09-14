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

==============  =======  =======
unit            encode   china  
==============  =======  =======
CORE_NULL       0000     空白   
CORE_IR         0001     指令   
CORE_PC         0010     程序   
CORE_AR         0011     地址   
CORE_DR0        0100     第一   
CORE_DR1        0101     第二   
CORE_CR         0110     算术   
EMPTY           0111     保留   
ALU_RE          1000     结果   
ALU_AD          1001     例外   
EMPTY           1010     保留   
EMPTY           1011     保留   
==============  =======  =======
IOSC_INS_PC     1100     控制   
IOSC_INS_AR     1101     原材   
IOSC_OTH        1110     其它   
IOSC_NULL       1111     外空   
==============  =======  =======

Computing Module Instruction
============================

Computing Module Instruction(CMI) is the encode of the computing module.
It is related to the realize of the processor.
If the input and output of different processors are the same,
the CMI is universal.
So an important thing is defining the operation.

==============  ========  =====================
ALU             encode    china
==============  ========  =====================
ALU_COMPARER    00000000  比较
ALU_JUMP_CON    00000001  分支
==============  ========  =====================

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


