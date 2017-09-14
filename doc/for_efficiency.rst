=======================
Efficiency Optimazation
=======================

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



Modules
-------

- Decoder: Decode the excuting ir for controller.
- Cash Loader: Load data from cash or memory to ir queue, when ir is
  LOAD_IR_BLOCK.
- Queue: Store one instruction block which is 8 lines, and export lines by
  sequence. 
- Launcher: Excute the ir SET_DATA.

Cash Loader
-----------
Cash Loader consists of three parts: core interface and cash interface.
Core interface receives the command from the core and respond the data, in deed
is a asychronous FIFO.
Cash interface communicates with the cash by `Cash Interface Protocal`_.

Function
~~~~~~~~

1. When FIFO is empty, catch new command.
   If ir is reading, core interface get the command and the data only one
   clock;
   if ir is writing, core interface get the command and the address first and
   then get the data at least once and less than nine clocks.
   When the writing address does not change, the later data is considered as
   the same row.

2. When FIFO has new command, cash interface excute the command.

queue
-----

Structure
~~~~~~~~~

IR queue uses regfile style to store instruction. One reason is the instruction
maybe reused, when in a circle, if the queue is large enough to store the whole
circle block. Another reason is low power(may need to test).

Fuction
~~~~~~~

1. Load instruction. From the IR cash loader get the instruction one by one.
   For efficiency, it may get 8 instruction once.

2. Export instruction. Export instruction to excuse in order in secquence.

3. The core start up here.

state
~~~~~
1. Reset. Excute the instruction LOAD_IR_BLOCK.
   
   - Set the queue 0 to LOAD_IR_BLOCK
   - Set the *queue_export_pointer* to queue 0
   - Set the ir_controller reg_i_data to 0(The IR block address.)

2. Upload ir from loader. Condition: loader has loaded the data block.
   When *loader_data_ready* is 1, upload ir to queue.
   set the queue pointer
   *queue_export_pointer* to 9'h1, which keeps output data stable.

   TODO: should_load = (ir==jump)&&(jump_addr!=cur_block_addr);
   en_load = should_load && (jump_addr_block_data_ready);
   
3. Export instruction. When *queue_export_en* is 1, *queue_export_pointer* will 
   If current instruction is LOAD_IR_BLOCK, next clock *queue_export_pointer*
   will jump to line 1, and export EMPTY instruction. At this time,
   *queue_export_pointer* will keep stop until block data is uploaded.



Cash Interface Protocal
=======================

Function
--------

Each action will have three state: action, response and finished.
When writing, action consistes of write addr and write data, response consistes
of cash valid, and then the controller goto finished state.
When reading, action consistes of read addr, response consistes of valid, read
addr and read data, and then the controller goto finished state.

Both writing and reading data will process 8 rows once command.

Bus  Function Signal
--------------------

==========  ========    ========    ========
signals     clock       control     data
==========  ========    ========    ========
write send  clk         w           addr
            clk         w           data1
            clk         w           data*
            clk         w           data8
receive     clk         valid       00000000
read send   clk         r           addr
receive     clk         valid       data1
            clk         valid       data*
            clk         valid       data8
==========  ========    ========    ========

The data and control signals are valid at the posedge of clock.


Asychronous FIFO
================

One Row FIFO
------------
One Row FIFO cash only one cycle data. Write part and read part have one
separate pointer. The work state is as fallow:

==========  ==========  ========
state       write P     read P
==========  ==========  ========
idle        0           0
write en    1           0
catch en    1           1
response    1           0
idle        0           0
==========  ==========  ========




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
set_data        set writing data[0] to data bus
w_save_addr     enable save data 
set_data        set writing data[1] to data bus
w_save_addr     enable save data 
.........       repeat set writing data
set_data        set writing data[7] to data bus
w_save_addr     enable save data 
set_data        set writing address to data bus
w_save_addr     enable save address
==============  ===============================

If the writing data are less than 8 lines, just set the valid data, the 
other data are set to 0. The data is writen to cash by the order of
setting. The first set data will be written to data[7:0]::

    cash one row:

    data[63] data[62] ... data[7] ... data[0]

When set the writing address, the cash interface will write 8 lines(one row),
no matter how many lines have been set. If setting data are more than 8 lines,
the core interface will store the data cycially from data[0].

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




Command Excute Sequence
=======================
If the port of one instruction will use is busy, how this instruction is
processed? To be hold, cancelled or jumped?
To realize the complete function, the instruction must be excuted, so the
excution must be paused. This requires every port with multi cycles
funcitons can feedback a busy signal.

Store write data(ALU result) in a result_regist.
================================================

  If the read address is the same with the last writing address,
  it read data from the result register directly,
  without read memory.

  It is very usefull for jump address caculation.

AR auto increment.
==================

When READ_AR, AR auto increment one row.

Each ALU has a special registers.
=================================

more address supports.

AR and CR may share a register
==============================

not sure.

IOs exchange data directly
==========================

exchange a large mount of data directly.
