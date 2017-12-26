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
sim:/testbench/black_bean_0/bb_core_0/decoder_0/n_unit_ien \
sim:/testbench/black_bean_0/bb_core_0/decoder_0/n_unit_oen

add wave -divider brancher
add wave -position insertpoint  \
sim:/testbench/black_bean_0/bb_core_0/brancher_0/i_program_count \
sim:/testbench/black_bean_0/bb_core_0/brancher_0/i_address_reg \
sim:/testbench/black_bean_0/bb_core_0/brancher_0/i_operand0 \
sim:/testbench/black_bean_0/bb_core_0/brancher_0/i_operand1 \
sim:/testbench/black_bean_0/bb_core_0/brancher_0/i_config_reg \
sim:/testbench/black_bean_0/bb_core_0/brancher_0/i_config_reg_ien \
sim:/testbench/black_bean_0/bb_core_0/brancher_0/i_config_reg_oen \
sim:/testbench/black_bean_0/bb_core_0/brancher_0/o_branch_addr

#add wave -position insertpoint -type binary sim:/testbench/black_bean_0/bb_core_0/decoder_0/i_action

add wave -divider common_register
add wave -position insertpoint  \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/i_skin_data \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/i_core_data \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/i_unit_ien \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/i_unit_oen \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/i_branch_addr \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_address_reg \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_operand0 \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_operand1 \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_config_reg \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_program_count \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_instruction \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/o_reg_value \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_AR \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_DR0 \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_DR1 \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_DR2 \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_CR \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_IR \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/reg_PC \
sim:/testbench/black_bean_0/bb_core_0/common_register_0/cr_data_in

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
sim:/testbench/black_bean_0/bb_core_0/alu_0/o_result

add wave -divider mem

add wave -position insertpoint  \
sim:/testbench/memory/i_data \
sim:/testbench/memory/i_address \
sim:/testbench/memory/i_write_en \
sim:/testbench/memory/o_data \
sim:/testbench/memory/reg_address \
sim:/testbench/memory/reg_stored_data
