set work_home "D:/lhy/project/black_bean/simu"
set project_name bb_simu
set sim_lib_name bb_simu

cd $work_home
if { [file isfile "${project_name}.mpf"] } {
    project open $work_home/$project_name
} else {
    project new $work_home $project_name
    vlib $sim_lib_name
    vmap $sim_lib_name $sim_lib_name 
    project addfile testbench.v                                                     verilog 
    project addfile $work_home/../rtl/common_module/regfile.v                       verilog 
    project addfile $work_home/../rtl/black_bean_top.v                              verilog 
    project addfile $work_home/../rtl/bb_core/bb_core.v                             verilog 
    project addfile $work_home/../rtl/bb_core/alu/alu.v                             verilog 
    project addfile $work_home/../rtl/bb_core/alu/comparer.v                        verilog 
    project addfile $work_home/../rtl/bb_core/alu/jump_condition.v                  verilog 
    project addfile $work_home/../rtl/bb_core/controller/decoder.v                  verilog 
    project addfile $work_home/../rtl/bb_core/controller/brancher.v                 verilog 
    project addfile $work_home/../rtl/bb_core/common_register.v                     verilog 
    project addfile $work_home/../rtl/skin/mem_controller.v                         verilog 
    project addfile $work_home/../rtl/skin/skin.v                                   verilog 
}

vlog -work $sim_lib_name testbench.v
vlog -work $sim_lib_name $work_home/../rtl/common_module/regfile.v                                    
vlog -work $sim_lib_name $work_home/../rtl/black_bean_top.v                                           
vlog -work $sim_lib_name $work_home/../rtl/bb_core/bb_core.v                                          
vlog -work $sim_lib_name $work_home/../rtl/bb_core/alu/alu.v                                          
vlog -work $sim_lib_name $work_home/../rtl/bb_core/alu/comparer.v                                     
vlog -work $sim_lib_name $work_home/../rtl/bb_core/alu/jump_condition.v                               
vlog -work $sim_lib_name $work_home/../rtl/bb_core/controller/decoder.v                                  
vlog -work $sim_lib_name $work_home/../rtl/bb_core/controller/brancher.v                                  
vlog -work $sim_lib_name $work_home/../rtl/bb_core/common_register.v
vlog -work $sim_lib_name $work_home/../rtl/skin/mem_controller.v                                      
vlog -work $sim_lib_name $work_home/../rtl/skin/skin.v 

vsim -lib $sim_lib_name -L $sim_lib_name -novopt testbench

source add_signal.tcl
run
