==================
Action Instruction 
==================

Introduction
============
The computing module do a compute by four steps: set input data, config the
state, compute, and give out the result. Except the computing step, the other
steps exchage datas with storages. The input data is from raw data bus, the
config information is from instructions, and the result is sent to result data
bus. So the instruction has at least three types: set raw data bus, config
module, select result data.

The instruction of Black Bean is seperate instruction, which means each
instruction is only one opration command with out oprands. The default oprands
data of most instruction is the data bus, and one excetion is `SET_DATA`, whose
oprand is the next instruction.  

Set Immediate Data
------------------
In the instruction, there are data. Most action instructions have no operands,
the data to be processed is on the data bus. So how to sent the data in
instruction queue to the data bus? There are two methods:

1. Use one bit of the instruction as a instruction or data flag.

2. *Set one action to indicate the next line is instruction or data.*

Here chooses the second method. The data width will grow fast than the
instruction. The data width is multiple of the instruction will be good,
because in this case, some instruction lines will consist of a data.

Design
======
The instruction has three types: data control, system control and module
config. Data control instruction controles read and write the memory, choice
proper datas to write and send the readed data to target modules. 
System control instruction set the system state, such as reset, empty etc.
Module config instruction used to config the caculating modules. For example,
some module may have two or more processes, and depend some config information.

IR List
-------

==================  ==========================================================
instruction         function
==================  ==========================================================
                flow_control
------------------------------------------------------------------------------
reset               Soft reset. 
                    It is the default command when start the controller. 
                    In this state, read the command in memory address 0.
immediate           ??Indicate the next instruction is a operand.
continue            Continue to read next raw instruction.
empty               No action. Waiting for some signal? 
==================  ==========================================================
                operand bus
------------------------------------------------------------------------------
raw_bus_0/1         Send current cached data to data bus 0/1.
store_module*       Selete module from which the result reg stores data.
==================  ==========================================================
                memory control
------------------------------------------------------------------------------
operand_to_write    ??Indicate the result bus data will be writen to memory.
operand_w_addr      Write data, address is on the result bus.
operand_r_bus0/1    Read operand to raw bus, address is on the result bus.
==================  ==========================================================
                transfer control
------------------------------------------------------------------------------
transfer_addr       Read instruction , address is on the result bus.
transfer_condition  Set next ip;
                    If the object value matches the condition, 
                    next ip is current ip plus 1,
                    else next ip is current ip plus 2.
==================  ==========================================================


Module List
-----------

Comparer
~~~~~~~~

Compare raw_bus_0 and raw_bus_1 datas, result is the relationship of raw_bus_0
and raw_bus_1. 
For example, if raw_bus_0 is 1 and raw_bus_1 is 20, the result is large.
The result is the ascii of >, <, =, and their combination.



Actions of Function
===================

Load Data
---------

==============  ===============================
command         action
==============  ===============================
immediate       set reading address to data bus
empty
mem_r_addr
raw_bus_0
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

==================  ==============================================
command             action
==================  ==============================================
immediate
000000000           read data
raw_bus_0           to compare data a 
immediate
000000000
raw_bus_1           to compare data b 
choice_compaire     get the relationship of a and b
operand_to_write    prepare to write the compare result
immediate
000000000           read write addr
choice_cache_data
operand_w_addr      write action
immediate
000000000           read compare result address
raw_bus_0
immediate
000000000           read transfer condition
raw_bus_1
transfer_condition  
000000000           next_ir : true address
000000000           next_ir : false address or continue process
==================  ==============================================
immediate
000000000           next ir address
choice_cache_data
transfer_addr       set the result_bus data as the next ir address
==================  ==============================================


