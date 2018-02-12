add wave -position insertpoint  \
sim:/testbench/ref_clk \
sim:/testbench/chip_rst_n \
sim:/testbench/IO_CLK_P2 \
sim:/testbench/IO_P0 \
sim:/testbench/IO_P1 \
sim:/testbench/IO_P2 \
sim:/testbench/a

add wave -divider rom
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/controller0/ROM0/data_bus_in \
sim:/testbench/bean_mc_top0/controller0/ROM0/data_bus_out

add wave -divider top
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/clk \
sim:/testbench/bean_mc_top0/rst_n \
sim:/testbench/bean_mc_top0/addr_bus \
sim:/testbench/bean_mc_top0/controller_data_out \
sim:/testbench/bean_mc_top0/controller_data_in \
sim:/testbench/bean_mc_top0/core_data_out \
sim:/testbench/bean_mc_top0/core_data_in \
sim:/testbench/bean_mc_top0/interface_data_out \
sim:/testbench/bean_mc_top0/interface_data_in

add wave -divider controller
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/controller0/instructor \
sim:/testbench/bean_mc_top0/controller0/rom_addr
add wave -divider decoder
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/controller0/decoder_0/instructor \
sim:/testbench/bean_mc_top0/controller0/decoder_0/interrupt \
sim:/testbench/bean_mc_top0/controller0/decoder_0/addr_bus \
sim:/testbench/bean_mc_top0/controller0/decoder_0/data_bus_out \
sim:/testbench/bean_mc_top0/controller0/decoder_0/reg_state \
sim:/testbench/bean_mc_top0/controller0/decoder_0/reg_IR \
sim:/testbench/bean_mc_top0/controller0/decoder_0/next_state


add wave -divider pc
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/controller0/pc_0/reg_PC_latch \
sim:/testbench/bean_mc_top0/controller0/pc_0/reg_PC \
sim:/testbench/bean_mc_top0/controller0/pc_0/reg_state \
sim:/testbench/bean_mc_top0/controller0/pc_0/next_state \
sim:/testbench/bean_mc_top0/controller0/pc_0/next_pc \
sim:/testbench/bean_mc_top0/controller0/pc_0/set_pc \
sim:/testbench/bean_mc_top0/controller0/pc_0/jump

add wave -divider core
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/core0/data_out_alu0 \
sim:/testbench/bean_mc_top0/core0/data_out_counter0 \
sim:/testbench/bean_mc_top0/core0/data_out_cr0 \
sim:/testbench/bean_mc_top0/core0/data_out_ram0 \
sim:/testbench/bean_mc_top0/core0/data_out_ar_0

add wave -divider ram
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/core0/RAM0/ren \
sim:/testbench/bean_mc_top0/core0/RAM0/wen

add wave -divider register
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/core0/common_registers0/reg_DR0 \
sim:/testbench/bean_mc_top0/core0/common_registers0/reg_DR1 \
sim:/testbench/bean_mc_top0/core0/common_registers0/reg_DR2 \
sim:/testbench/bean_mc_top0/core0/common_registers0/reg_DR3 \
sim:/testbench/bean_mc_top0/core0/common_registers0/reg_CR

add wave -divider ar
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/core0/ar_0/reg_AR \
sim:/testbench/bean_mc_top0/core0/ar_0/reg_state \
sim:/testbench/bean_mc_top0/core0/ar_0/reg_out_state \
sim:/testbench/bean_mc_top0/core0/ar_0/next_state \
sim:/testbench/bean_mc_top0/core0/ar_0/next_out_state \
sim:/testbench/bean_mc_top0/core0/ar_0/set_ar \
sim:/testbench/bean_mc_top0/core0/ar_0/source_ar \
sim:/testbench/bean_mc_top0/core0/ar_0/ar_out

add wave -divider interface
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/interface0/latched_port0 \
sim:/testbench/bean_mc_top0/interface0/latched_port1 \
sim:/testbench/bean_mc_top0/interface0/latched_port2 \
sim:/testbench/bean_mc_top0/interface0/device_value \
sim:/testbench/bean_mc_top0/interface0/ren \
sim:/testbench/bean_mc_top0/interface0/wen \
sim:/testbench/bean_mc_top0/interface0/reg_port_addr

add wave -divider alu
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/core0/ALU0/alu_re \
sim:/testbench/bean_mc_top0/core0/ALU0/alu_ad \
sim:/testbench/bean_mc_top0/core0/ALU0/compare_addition \
sim:/testbench/bean_mc_top0/core0/ALU0/compare_result \
sim:/testbench/bean_mc_top0/core0/ALU0/add_addition \
sim:/testbench/bean_mc_top0/core0/ALU0/add_result \
sim:/testbench/bean_mc_top0/core0/ALU0/compare_en

add wave -divider counter
add wave -position insertpoint  \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/reg_counter \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/reg_start_value \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/reg_stop_value \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/reg_mode \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/next_mode \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/reg_auto_reach_stop_value \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/reg_trigger \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/reset \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/set_count \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/set_auto \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/set_stop \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/set_start \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/trigger \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/reach_max \
sim:/testbench/bean_mc_top0/core0/ALU0/counter0/export

