
add wave -divider test_port
add wave -divider ram
add wave -position insertpoint  \
{sim:/testbench/bean_mc_top0/core0/RAM0/regfile0/reg_stored_data[0]} \
{sim:/testbench/bean_mc_top0/core0/RAM0/regfile0/reg_stored_data[1]} \
{sim:/testbench/bean_mc_top0/core0/RAM0/regfile0/reg_stored_data[2]} \
{sim:/testbench/bean_mc_top0/core0/RAM0/regfile0/reg_stored_data[3]}
