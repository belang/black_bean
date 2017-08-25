======================
bean assembly language
======================

Introduction
============

When simulate the verilog, write hexadecimal data is sophisticated and hard to
remember the data.
For convenient, testers write bean instruction and this compiler convert the
file to hexadecimal format line by line.

For jump address, the target address must be clear in the program.
If the address is writen in direct format such as 0xf0,
when the program is changed, the address must be chagned correspondingly.
For this reason and maybe some other writing proram convenient,
a bean assembly language is designed.

Bean assembly language consits of two parts: bean machine instruction and 
Bean assembly instruction.

Bean Machine Instruction
========================

Bean Machine Instruction(BMI) map the instruction list defined in define.v.

==========  ======================  ==========================  =====
Chinese     Assembly language       Maching instruction         Value
==========  ======================  ==========================  =====
复位        reset                   RESET                       8'h00
继续        continue                CONTINUE                    8'h01
空          empty                   EMPTY                       8'h02
转去        jump_directly           JUMP_DIRECTLY               8'h03
选择        jump_condition          JUMP_CONDITION              8'h04
存储        write_memory            WRITE_MEMORY                8'h05
取甲        read_memory_to_bus_0    READ_MEMORY_TO_BUS_0        8'h06
取乙        read_memory_to_bus_1    READ_MEMORY_TO_BUS_1        8'h07
置甲        next_ins_to_bus_0       NEXT_INS_TO_BUS_0           8'h08
置乙        next_ins_to_bus_1       NEXT_INS_TO_BUS_1           8'h09
择甲        result_of_bus_0         RESULT_OF_BUS_0             8'h0a
择乙        result_of_bus_1         RESULT_OF_BUS_1             8'h0b
==========  ======================  ==========================  =====

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


