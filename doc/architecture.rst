============
Architecture
============

Basic Concept
=============

According to the fucntion, a processor is classed as two modules: storage and
computing. So the Black Bean processor is designed from a two parts structure,
which all signals are stored in storage module, and the other module is
computing.

Data Width
----------

The data width of Black Bean is 8bits.

Data Bus Width
--------------

Because some computing needs two or more input, so the bus width is 16 bits or
more.

Data Storage Mapping
--------------------

The storage has two lines data_data_out pins, and each of them is connected to
some specified pins modules. For example, data_data_out[0] is connected to adder
input pins i_data_0, and data_data_out[1] is connected to the i_data_1.

Storage
=======

Pin List
--------

Instruction
~~~~~~~~~~~

- Input:

  + ir_ren
  + ir_addr_next

- Output:

  + ir_addr_cur
  + ir

Data
~~~~

- Input:

  + data_ren
  + data_addr_next
  + data_wen
  + data_w_data

- Output:

  + data_addr_cur
  + data_bus_1
  + data_bus_0

Computing
=========

IR Decoder
----------

1. Read memory data to data_bus[1,0].
2. Set data_bus[1,0] from IR.
2. Select the write back data from all computing module.
