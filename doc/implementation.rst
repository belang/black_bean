==============
Implementation
==============

Decoder
=======
All net connect to output pins has prefix `command_`, which classes these net
as coming from decoder.


input

reg     ir

output

Signals Specification
---------------------

==============================  ==============================================
signals                         value [default value is the first value]
==============================  ==============================================
                memory read and write control
------------------------------------------------------------------------------
memory_address_type             0: ip, 1: raw bus 0
memory_read_enable              1: read, 0: do not read
memory_write_enable             0: do not write, 1: write
==============================  ==============================================
                   instruction pointer(ip) caculator
------------------------------------------------------------------------------
next_ip_type                    0: memory address +1, 
                                1: hold, 
cur_ip                          0: ip, 1: 00000000
select_jump_address             0: normal, 1: cur_ip+1 or cur_ip+2
==============================  ==============================================
ir_enable                       1: active, 0: stop
raw_bus_0/1_enable              0: stop, 1: active 
(module)_output_enable          0: value is no use, 1: value is valid
==============================  ==============================================

Instruction Specification
-------------------------

======================  ==============================  =====
instruction             signals                         value
======================  ==============================  =====
reset                   cur_ip                          1
continue                DEFAULT
empty                   memory_read_enable              0
raw_bus_0/1             raw_bus_0/1_enable              1
                        ir_enable                       0
choice_module*          (module)_output_enable          1
operand_w_addr          memory_address_type             1
                        memory_write_enable             1
                        memory_read_enable              0
operand_r_addr          memory_address_type             1
                        next_ip_type                    1
transfer_addr           memory_address_type             1
transfer_condition      select_jump_address             1
======================  ==============================  =====
