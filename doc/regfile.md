= 寄存器堆 =

== 端口说明 ==
| 方向   | 名称     | 说明         |
|--------|----------|--------------|
| input  | clk      |              |
| input  | rst_n    |              |
| input  | data_in  |              |
| input  | address  |              |
| input  | mode     | 1：读；0：写 |
| output | data_out |              |

目前，寄存器堆一直读，随地址变化。