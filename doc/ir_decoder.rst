= 状态 =

当前数据匹配IR，匹配成功后，进入读取数据状态，

当解码模块返回指令读取完成时，标识下一数据是指令。


两层状态：

主状态——指令状态：当前指令
次状态——指令执行状态：取指、取指令数据、发射、运算等

每个子状态都有独立的状态控制器。

= 复位 =
系统进入复位状态，进行初始化。
= 初始化指令 =
动作：将内存地址0开始的256行数据，写入从指令寄存器地址0开始写入指令寄存器。

指令：读令 0 0 ff;

微指令：

设计数器数值counter为0;
设内存地址mem_addr为0;
设指令寄存器地址ir_addr为0。
循环1：
当内存控制器空闲时，按mem_addr读取内存数据。
当内存读取数据准备好时，按ir_addr指令寄存器写入数据；
计数器数值增加1。
当计数器数值等于最大行数时，当前指令完成；
否则，返回循环1。

微指令：
counter 0
R1 0
R2 0
//set_loop_point current_line
L1: wait mem_ready
mem_read R1
add R1 R1 1
wait mem_data_valid
ir_write R2
add R2 R2 1
add counter counter 1
jump_equal 2 counter max_lines
jump L1
ir_finished


= 停止 =
停止取指，系统保持当前状态

= 加载数据 =
loadda source_addr target_addr lines;

// 每拍读一行。读mem需要多行。
ready : counter = 0; goto step1.
step1 : mem_addr = source_addr, mem_read_mem, source_addr += 1; counter += 1; goto step2.
step2 :	if counter == lines, exit. else
	mem_addr = source_addr, mem_read_mem, source_addr += 1; 
	data_reg_write data_reg_addr = target_addr, target_addr +=1;
	counter +=1; goto step2.

= 加载指令 =
loadir source_addr target_addr lines;

// 每拍读一行。读mem需要多行。
ready : counter = 0; goto step1.
step1 : data_addr = source_addr, data_read_data, source_addr += 1; counter += 1; goto step2.
step2 :	if counter == lines, exit. else
	data_addr = source_addr, data_read_data, source_addr += 1; 
	ir_reg_write ir_reg_addr = target_addr, target_addr +=1;
	counter +=1; goto step2.

= 跳转 =
跳转 地址（地址可以是绝对地址，可以是寄数）
判断跳转 结果 地址（结果为真，则跳转；结果可以是数据，可以是寄数）

= 比较 =
大于 a1 a2 a3（a1大于a2，则a3为1，否则a3为零）
小于 a1 a2 a3（）
等于 a1 a2 a3（）

= 取反 =
= 取非 =

= 端口说明 =
| D | 名称     | 说明     |
|---|----------|----------|
| i | clk      |          |
| i | rst_n    |          |
| i | data_in  | 外部数据 |
| i | ir       | 寄令数据 |
| o | irp      | 寄令地址 |
| o | data_out | 数据     |
| o | ctrl_bus | 控制总线 |
|   |          |          |
|   |          |          |


