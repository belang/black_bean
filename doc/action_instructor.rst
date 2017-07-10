==================
Action Instruction 
==================

Introduction
============
这里设计的指令是硬件执行的指令。它是传统意义的指令集编译之后的指令。

Design
======

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

Actions
=======

Load Instruction/Data
---------------------

==============  ===============================
command         action
==============  ===============================
set_data        set reading address to data bus
w_load_addr     enable load address
==============  ===============================

Save Instruction/Data
---------------------

==============  ===============================
command         action
==============  ===============================
set_data        set writing data to data bus
w_save_addr     enable save data 
==============  ===============================

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
