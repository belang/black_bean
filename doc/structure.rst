==================
Hardware Structure
==================

数据总线：8位
结构图：见总体结构

.. image:: image/structure.png

The jump address is sent to ir_loader through the data bus, not directly.
Because the address is valid in next clock posedge.

controller
==========

The ir_controller has following parts: 
  - ir loader
  - ir queue
  - ir luncher
  - ir decoder

1. The excusing instruction is not stored in the module.
2. The input data from data bus is stored in the module trigger by the matching
   instruction.

ir_queue
--------

IR queue stores one instruction block which is 8 lines. 

Structure
~~~~~~~~~

IR queue uses regfile style to store instruction. One reason is the instruction
maybe reused, when in a circle, if the queue is large enough to store the whole
circle block. Another reason is low power(may need to test).

Fuction
~~~~~~~

1. Load instruction. From the IR cash loader get the instruction one by one.
   For efficiency, it may get 4 instruction once.

2. Export instruction. Export instruction to excuse in order.

state
~~~~~
flow chart::

    prefetch

    reset
    |
    LOAD_IR -> store block address as cur_ir_block_addr
    |
    UPLOAD_IR -> en_export     <----------------------------------------------+
    |                                                                         |
    ?get one block                                                            |
    |-> en_export                                                             |
    |                                                                         |
    PRELOAD_SUBSEQUENT_BLOCK(give out an IR and go to next state)             |
    |                                                                         |
    ?the last IR of current excuting block is a transfer IR  --------+        |
    |                                                                |        |
    PRELAOD_TRANSFER_BLOCK(give out an IR and go to next state)      |        |
    |                                                                |        |
    NEXT_BLOCK       <-----------------------------------------------+        |
    |                                                                         |
    |-> if the excute queue is finished, the next block is subsequent block,  |
    |-> else if current IR is jump IR, the next is transfer one.              |
    |                                                                         |
    ?target IR block is loaded                                                |
    |                                                                         |
    |-------------------------------------------------------------------------|


取指器
======
当取出的指令是立即数时，将其输出到数据总线上。

指针计算器
==========
计算指令指针地址，实现跳转功能。

= 译码器 =
将汇编指令译成短操作指令。译码器越强大，汇编指令功能越强大，相应的应用软件规模就越小。
译码动作可以是硬件，也可以是软件，由软件配置译码，同样可以减小软件规模。

= 发射器（射） =
译码的结果是一系列短指令，由发射器调度，将指令发送到执行器中。


== 指令译码 ==
每个指令对应一个专门的功能译码模块。模块有两种数据控制方式：
1. 使能输入输出：当指令为此模块时，模块输入为当前指令，否则输入为0，输出为0。
2. 使用输出：当指令为此模块时，控制器输出选择此模块输出。

每个译码功能模块都是一个控制器。在执行指令时，选择相应控制器的输出。

向模块写入数据时，需要写使能，这样多个端口可以独立控制写入数据。
1. 令：指令寄存器


以工作顺序进行设计。

1. 初始化：加载指令。加载器从固定位置向令寄固定位置写入数据，完成后，向控制器发送完成信号。

# 信号说明

+--------------+--------------------+----------------------------------------------+
| 名称         | 线名               | 说明                                         |
+--------------+--------------------+----------------------------------------------+
| 取指使能     | fetch_en           | 指示令寄的输出是要执行的指令，防止跳转和误读 |
|              |                    | 保留。目前用不上。                           |
+--------------+--------------------+----------------------------------------------+
| 令寄使能     | regfiel_en         | 关闭时，令寄不工作                           |
+--------------+--------------------+----------------------------------------------+
| 目标端口标志 | target_device_flag | 指示当前输出设备是终点设备                   |
|              |                    |                                              |
+--------------+--------------------+----------------------------------------------+
