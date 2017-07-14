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
some module may have two or more process, and depend some config information.

==================  ========  =======  =================  ============  ============================================
instruction         mem_addr  mem_ren  reg_mem_data_type  reg_ir_p      actions               
==================  ========  =======  =================  ============  ============================================
reset               0         1        => 0:ir            =>mem_addr+1                  
immediate           irp       1        => 1:data          =>mem_addr+1  reg_ir <= empty/data  
empty/data          irp       1        => 0:ir            =>mem_addr+1                  
raw_bus_0           irp       1        => 0               =>mem_addr+1  en_reg_raw_data_bus_0 
c_module*           irp       1        => 0               =>mem_addr+1  select data to the result data          
mem_w_data          irp       1        => 0               =>mem_addr+1  en_reg_mem_w_data     
mem_w_addr          result    0        => 2:null          =>self        =>write data to memory, reg_ir <= empty 
mem_r_addr          result    1        => 1               =>self        =>read data, reg_ir <= empty
transfer_addr       result    1        => 0               =>mem_addr+1  set the memory address as result data [jump]
transfer_condition  result    1        => 0               =>mem_addr+1  select next ir address [jump]
==================  ========  =======  =================  ============  ============================================

IR List
-------

==========  ==========  ==============
ir control  data bus    memory control
==========  ==========  ==============
reset       raw_bus_0   mem_w_data
immediate   raw_bus_1   mem_w_addr
empty                   mem_r_addr
                        mem_r_ir
==========  ==========  ==============

Module List
-----------

NEXT:  adder


单动作指令设计灵活，更能体现硬件信号传输过程，所以以单动作指令进行设计。

硬件基本操作是读和写。操作内容是地址（端口）和数据。操作对象有内存、寄存器、运算器、外设。
由此设计单动作指令格式为：读、写，对象，地址（立即数）。
无论读写，默认数据在对应的数据总线中。
每一对读写动作完成一次数据搬运。因为读写之间的数据缓存在数据总线上，
所以读写操作必须成对出现，而且连续读写。如果不连续，则需要缓存。

单动作指令通过向器件某些端口发送使能来实现，简称动作。
每个动作由7位构成。

动作列表:

    Action is instruction, and the data port exports data to or imports data
    from the data bus.

+-------------+-------------+-------------------+-----------------+--------------------------------+
| 类型type    | 器件device  | data port         | 动作action      | 功能function                   |
+=============+=============+===================+=================+================================+
| bus device  | memory      | ren               | r_mem           |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             | wen               | w_mem           |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
| check state | validtiy    | memory read_valid | c_memery_read   | multi circle needed            |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             | addition carry    | c_carry_add     |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
| computing   | addition    | addend1           | w_addition_a1   |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             | addend2           | w_addition_a2   |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             | summary           | r_addition_sum  |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             | comparator  | data1             | w_comparator_d1 |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             | data2             | w_comparator_d2 |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             | result            | r_comparator_re |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
| controller  | ir_pointer  | address           | w_transfer_addr | jump address                   |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             | condition         | w_transfer_cond | data a                         |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             | target            | w_transfer_tar  | data b                         |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             | relationship      | w_transfer_rel  | =,>,<,...                      |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             | cash loader | loader_addr       | w_load_addr     | load one ir block from IR cash |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             | cash writer | writer_addr       | w_save_addr     |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             | writer_data       | w_save_data     |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             | launcher    |                   | set_data        | set data to data bus from ir   |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             |                   |                 |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+
|             |             |                   |                 |                                |
+-------------+-------------+-------------------+-----------------+--------------------------------+

说明::

    switch: next ir_address is the 'address' when the raltionship of 
    'condition' and 'target' matches the requirement--'relationship'.

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

==================  =================================
command             action
==================  =================================
000000000           read data
raw_bus_0           to compare data a 
000000000
raw_bus_1           to compare data b 
compare_result
raw_bus_0           compare_result
transfer_condition
000000000           true address
000000000           false address or continue process
==================  =================================

