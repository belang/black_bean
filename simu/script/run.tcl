set work_home "E:/project/black_bean/simu"
set project_name bb_simu
set sim_lib_name bb_simu

cd $work_home
if { [file isfile "${project_name}.mpf"] } {
    project open $work_home/$project_name
} else {
    project new $work_home $project_name
    vlib $sim_lib_name
    vmap $sim_lib_name $sim_lib_name 
    project addfile testbench.v                                                         verilog 
    project addfile ../rtl/common_module/regfile.v                                      verilog 
    project addfile ../rtl/black_bean_top.v                                             verilog 
    project addfile ../rtl/bb_core/bb_core.v                                            verilog 
    project addfile ../rtl/bb_core/alu/alu.v                                            verilog 
    project addfile ../rtl/bb_core/alu/comparer.v                                       verilog 
    project addfile ../rtl/bb_core/alu/jump_condition.v                                 verilog 
    project addfile ../rtl/bb_core/decoder/decoder.v                                    verilog 
    project addfile ../rtl/bb_core/common_register/common_register.v                    verilog 
    project addfile ../rtl/bb_core/common_register/address_caculator.v                  verilog 
    project addfile ../rtl/skin/mem_controller.v                                        verilog 
    project addfile ../rtl/IOSC/iosc_ins.v                                              verilog 
}

vlog -work $sim_lib_name testbench.v
vlog -work $sim_lib_name ../rtl/common_module/regfile.v                                    
vlog -work $sim_lib_name ../rtl/black_bean_top.v                                           
vlog -work $sim_lib_name ../rtl/bb_core/bb_core.v                                          
vlog -work $sim_lib_name ../rtl/bb_core/alu/alu.v                                          
vlog -work $sim_lib_name ../rtl/bb_core/alu/comparer.v                                     
vlog -work $sim_lib_name ../rtl/bb_core/alu/jump_condition.v                               
vlog -work $sim_lib_name ../rtl/bb_core/decoder/decoder.v                                  
vlog -work $sim_lib_name ../rtl/bb_core/data_register_controller/data_register_controller.v
vlog -work $sim_lib_name ../rtl/bb_core/data_register_controller/program_counter.v         
vlog -work $sim_lib_name ../rtl/skin/mem_controller.v                                      

vsim -lib $sim_lib_name -L $sim_lib_name -novopt testbench

source add_signal.tcl
run
