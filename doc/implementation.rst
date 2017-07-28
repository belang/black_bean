==============
Implementation
==============

Decoder
=======
There two types instructions, one is context-independent, the other is
context-dependent.
The first version of BlackBean is the former for simplicity.

**Input : IR**

All nets connect to output pins have a prefix *ling_*,
which classes these net as coming from decoder.

Signals Specification
---------------------

==============================  ==============================================
output signals                  value [default value is the first value]
==============================  ==============================================
                memory read and write control
------------------------------------------------------------------------------
memory_address_source           0: ip, 1: raw bus 0
memory_read_enable              1: read, 0: do not read
memory_write_enable             0: do not write, 1: write
==============================  ==============================================
                   instruction pointer(ip) caculator
------------------------------------------------------------------------------
hold_ip_flag                    0: memory address +1, 1: hold, 
reset_ip                        0: ip, 1: 00000000
select_jump_address             0: normal, 1: cur_ip+1 or cur_ip+2
==============================  ==============================================
ir_enable                       1: active, 0: stop
raw_bus_0/1_wen                 0: stop, 1: active 
raw_bus_0/1_ren                 0: stop, 1: active 
(module)_output_enable          0: value is no use, 1: value is valid
==============================  ==============================================

Instruction Specification
-------------------------

======================  ==============================  =====
instruction             signals                         value
======================  ==============================  =====
reset                   reset_ip                        1
continue                DEFAULT
empty                   memory_read_enable              0
                        hold_ip_flag                    1
                        ir_enable                       0
raw_bus_0/1             raw_bus_0/1_wen                 1
                        ir_enable                       0
operand_w_addr          memory_address_source           1
                        memory_write_enable             1
                        memory_read_enable              0
operand_r_bus0/1        memory_address_source           1
                        hold_ip_flag                    1
                        raw_bus_0/1_wen                 1
transfer_addr           memory_address_source           1
transfer_condition      select_jump_address             1
store_module*           (module)_output_enable          1
======================  ==============================  =====

address caculator
=================
Caculate memory read and write address.

Input:

======================  ==================  =====================
name                    source              function
======================  ==================  =====================
target_address          raw_bus_0
object                  raw_bus_0
condition               raw_bus_1
hold_ip_flag            decoder             control ip caculating
memory_address_source   decoder
select_jump_address     decoder
======================  ==================  =====================

Output:

==================  ======================  =====================
name                target                  function
==================  ======================  =====================
memory_address      memory : address        
==================  ======================  =====================

