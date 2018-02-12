set work_home "D:/lhy/project/black_bean/microcontroller/simu"
set project_name microcontroller
set sim_lib_name microcontroller

cd $work_home
if { [file isfile "${project_name}.mpf"] } {
    project open $work_home/$project_name
} else {
    project new $work_home $project_name
    vlib $sim_lib_name
    vmap $sim_lib_name $sim_lib_name 
    project addfile $work_home/../rtl/testbench/testbench.v          verilog 
    project addfile $work_home/../rtl/common/regfile.v               verilog 
    project addfile $work_home/../rtl/common/data_bus.v              verilog 
    project addfile $work_home/../rtl/bean_mc_top.v                  verilog 
    project addfile $work_home/../rtl/core/add.v                     verilog 
    project addfile $work_home/../rtl/core/alu.v                     verilog 
    project addfile $work_home/../rtl/core/ar.v                      verilog 
    project addfile $work_home/../rtl/core/common_registers.v        verilog 
    project addfile $work_home/../rtl/core/compare.v                 verilog 
    project addfile $work_home/../rtl/core/core.v                    verilog 
    project addfile $work_home/../rtl/core/counter.v                 verilog 
    project addfile $work_home/../rtl/core/ram.v                     verilog 
    project addfile $work_home/../rtl/controller/controller.v        verilog 
    project addfile $work_home/../rtl/controller/pc.v                verilog 
    project addfile $work_home/../rtl/controller/rom.v               verilog 
    project addfile $work_home/../rtl/controller/decoder.v           verilog 
    project addfile $work_home/../rtl/interface/interface.v          verilog 
}


vlog -work $sim_lib_name $work_home/../rtl/testbench/testbench.v     
vlog -work $sim_lib_name $work_home/../rtl/common/regfile.v          
vlog -work $sim_lib_name $work_home/../rtl/common/data_bus.v         
vlog -work $sim_lib_name $work_home/../rtl/bean_mc_top.v             
vlog -work $sim_lib_name $work_home/../rtl/core/add.v                
vlog -work $sim_lib_name $work_home/../rtl/core/alu.v                
vlog -work $sim_lib_name $work_home/../rtl/core/ar.v                 
vlog -work $sim_lib_name $work_home/../rtl/core/common_registers.v   
vlog -work $sim_lib_name $work_home/../rtl/core/compare.v            
vlog -work $sim_lib_name $work_home/../rtl/core/core.v               
vlog -work $sim_lib_name $work_home/../rtl/core/counter.v            
vlog -work $sim_lib_name $work_home/../rtl/core/ram.v                
vlog -work $sim_lib_name $work_home/../rtl/controller/controller.v   
vlog -work $sim_lib_name $work_home/../rtl/controller/pc.v           
vlog -work $sim_lib_name $work_home/../rtl/controller/rom.v          
vlog -work $sim_lib_name $work_home/../rtl/controller/decoder.v      
vlog -work $sim_lib_name $work_home/../rtl/interface/interface.v     

vsim -lib $sim_lib_name -L $sim_lib_name -novopt testbench

#source add_signal.tcl
#run
