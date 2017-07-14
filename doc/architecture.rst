============
Architecture
============

Basic Concept
=============

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

Total Architecture
==================

Memory
------
Store both data and instruction. It is one read and one write. It's data width
is 8bits.

IR Queue
--------
Store the instruction to excute.

Raw Bus
-------
Store the data to process.

Memory Trigger
--------------
Select address, select and latch writing data.

Ir Caculator
------------
Caculate the ir address.

Result Bus
----------
Select the data result from all computing modules.
