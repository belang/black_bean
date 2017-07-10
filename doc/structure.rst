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



Modules
-------

- Decoder: Decode the excuting ir for controller.
- Cash Loader: Load data from cash or memory to ir queue, when ir is
  LOAD_IR_BLOCK.
- Queue: Store one instruction block which is 8 lines, and export lines by
  sequence. 
- Launcher: Excute the ir SET_DATA.

