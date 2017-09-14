add wave -position insertpoint  \
sim:/testbench/clk \
sim:/testbench/rst_n 

#add wave -divider core


add wave -divider decoder

add wave -position insertpoint  \
sim:/testbench/black_bean_0/bb_core_0/decoder_0/i_ins \
sim:/testbench/black_bean_0/bb_core_0/decoder_0/o_unit_ien \
sim:/testbench/black_bean_0/bb_core_0/decoder_0/o_unit_oen \
sim:/testbench/black_bean_0/bb_core_0/decoder_0/reg_state \
sim:/testbench/black_bean_0/bb_core_0/decoder_0/next_state \
sim:/testbench/black_bean_0/bb_core_0/decoder_0/unit_source \
sim:/testbench/black_bean_0/bb_core_0/decoder_0/unit_target \
sim:/testbench/black_bean_0/bb_core_0/decoder_0/n_unit_ien

#add wave -position insertpoint -type binary sim:/testbench/black_bean_0/bb_core_0/decoder_0/i_action

add wave -divider common_register

add wave -position insertpoint  \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/i_skin_data \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/i_core_data \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_address_reg \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_operand0 \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_operand1 \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_config_reg \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_program_count \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_instruction \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_reg_value \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_IR \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_AR \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_DR0 \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_DR1 \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_CR \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_PC \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/sc_data

#add wave -position insertpoint  \
#sim:/testbench/black_bean_0/bb_core_0/common_register_0/address_caculator_0/i_iosc_ins_pc_oen \
#sim:/testbench/black_bean_0/bb_core_0/common_register_0/address_caculator_0/i_pc_ien \
#sim:/testbench/black_bean_0/bb_core_0/common_register_0/address_caculator_0/i_dir_addr \
#sim:/testbench/black_bean_0/bb_core_0/common_register_0/address_caculator_0/o_pc \
#sim:/testbench/black_bean_0/bb_core_0/common_register_0/address_caculator_0/reg_PC \
#sim:/testbench/black_bean_0/bb_core_0/common_register_0/address_caculator_0/next_pc

add wave -divider alu

add wave -position insertpoint  \
sim:/testbench/black_bean_0/bb_core_0/alu_0/i_alu_re_oen \
sim:/testbench/black_bean_0/bb_core_0/alu_0/i_alu_ad_oen \
sim:/testbench/black_bean_0/bb_core_0/alu_0/i_operand0 \
sim:/testbench/black_bean_0/bb_core_0/alu_0/i_operand1 \
sim:/testbench/black_bean_0/bb_core_0/alu_0/i_address_reg \
sim:/testbench/black_bean_0/bb_core_0/alu_0/i_program_count \
sim:/testbench/black_bean_0/bb_core_0/alu_0/i_config \
sim:/testbench/black_bean_0/bb_core_0/alu_0/o_alu_output \
sim:/testbench/black_bean_0/bb_core_0/alu_0/comparer_relation \
sim:/testbench/black_bean_0/bb_core_0/alu_0/jump_addr \
sim:/testbench/black_bean_0/bb_core_0/alu_0/o_result

add wave -divider IOSC
add wave -position insertpoint  \
sim:/testbench/black_bean_0/iosc_ins_0/i_core_oen \
sim:/testbench/black_bean_0/iosc_ins_0/i_core_ien \
sim:/testbench/black_bean_0/iosc_ins_0/i_core_addr \
sim:/testbench/black_bean_0/iosc_ins_0/i_core_pc \
sim:/testbench/black_bean_0/iosc_ins_0/i_core_data \
sim:/testbench/black_bean_0/iosc_ins_0/o_core_data \
sim:/testbench/black_bean_0/iosc_ins_0/o_core_interrupt \
sim:/testbench/black_bean_0/iosc_ins_0/i_skin_data \
sim:/testbench/black_bean_0/iosc_ins_0/i_skin_interrupt \
sim:/testbench/black_bean_0/iosc_ins_0/o_skin_oen \
sim:/testbench/black_bean_0/iosc_ins_0/o_skin_ien \
sim:/testbench/black_bean_0/iosc_ins_0/o_skin_addr \
sim:/testbench/black_bean_0/iosc_ins_0/o_skin_data

add wave -divider mem

add wave -position insertpoint  \
sim:/testbench/black_bean_0/mem_controller_0/i_ren \
sim:/testbench/black_bean_0/mem_controller_0/i_wen \
sim:/testbench/black_bean_0/mem_controller_0/i_address \
sim:/testbench/black_bean_0/mem_controller_0/i_data \
sim:/testbench/black_bean_0/mem_controller_0/o_data \
sim:/testbench/black_bean_0/mem_controller_0/mem_r_data \
sim:/testbench/black_bean_0/mem_controller_0/mem_w_data \
sim:/testbench/black_bean_0/mem_controller_0/mem_addr \
sim:/testbench/black_bean_0/mem_controller_0/mem_r_en \
sim:/testbench/black_bean_0/mem_controller_0/mem_w_en

add wave -position insertpoint  \
sim:/testbench/memory/reg_stored_data \
