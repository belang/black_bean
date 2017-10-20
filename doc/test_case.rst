
Test case directory contains test vector in arsembly language.

test case 1
-----------

tested function: immediate data; write mem; jump; read mem to reg;

write a program to the line 8'h40, which reads line 8'h00.

==========================  ====================================================================
SKIN_MEM_PC CORE_DR0        set DR0 (SKIN_MEM_PC CORE_AR) 
SKIN_MEM_PC CORE_AR         
SKIN_MEM_PC CORE_AR         write DR0 8'h40 
8'h40                       
CORE_DR0    SKIN_MEM_AR     =2> write 8'h40 (SKIN_MEM_PC CORE_AR) -- write target source
SKIN_MEM_PC CORE_DR0        write 8'h00 8'h41
8'h00                                                     
SKIN_MEM_PC CORE_AR                                           
8'h41                                                         
CORE_DR0    SKIN_MEM_AR                                       
SKIN_MEM_PC CORE_DR0        write 8'h42 (SKIN_MEM_AR CORE_DR1) --? through DR1 or DR0?
SKIN_MEM_AR CORE_DR1        
SKIN_MEM_PC CORE_AR                                           
8'h42                                                         
CORE_DR0    SKIN_MEM_AR                                       
SKIN_MEM_PC CORE_DR0        write 8'h43 8'h00                 
CORE_NULL   CORE_NULL                                         
SKIN_MEM_PC CORE_AR                                           
8'h43                                                         
CORE_DR0    SKIN_MEM_AR                                       
SKIN_MEM_PC CORE_PC         jump 8'h40                     
8'h40                                                         
CORE_NULL   CORE_NULL       stop                         
==========================  ====================================================================

test case 3
-----------

branch

If a > 0 then write 1 else write 0 to 8'h60 (use CORE_NULL), RESULT: 1

SKIN_MEM_PC CORE_DR0       save a in 8'h50 with value 8'hff
8'hff
SKIN_MEM_PC CORE_AR         
8'h50                       
CORE_DR0    SKIN_MEM_AR
CORE_NULL   CORE_DR0       set DR0 8'h00
SKIN_MEM_PC CORE_AR        load a to DR1
8'h50                       
SKIN_MEM_AR CORE_DR1        
SKIN_MEM_PC CORE_CR        set CR >
8'h03
SKIN_MEM_PC CORE_AR        set jump addr : line 16
8'h0f
CORE_CR     CORE_PC        branch
SKIN_MEM_PC CORE_AR        write 8'h60 0 
8'h60                       
CORE_NULL   SKIN_MEM_AR
SKIN_MEM_PC CORE_DR0       wirte 8'h60 1
8'h01
SKIN_MEM_PC CORE_AR         
8'h60                       
CORE_DR0    SKIN_MEM_AR
CORE_NULL   CORE_NULL   


TODO: show result to output port
If a !< 1 then write 1 else write 0 to 8'h60 ; RESUTL: 0


test case 4
-----------

1+2+3+...+10

SKIN_MEM_PC CORE_AR        let (y = 0)
8'h90
CORE_NULL   SKIN_MEM_AR
SKIN_MEM_PC CORE_DR0       set DR0 8'h01 (x = 1)
8'h01
SKIN_MEM_PC CORE_DR1       set DR1 8'h0a (while x < 11)
8'h0b
SKIN_MEM_PC CORE_AR        set AR 22 (false address)
8'h16
SKIN_MEM_PC CORE_CR        <
8'h01
CORE_CR     CORE_PC        
SKIN_MEM_PC CORE_AR        load y to DR1 (while body: y = x+y)
8'h90
SKIN_MEM_AR CORE_DR1       
SKIN_MEM_PC CORE_CR        add
8'h01                       
ALU_RE      SKIN_MEM_AR    save y
CORE_DR0    CORE_DR0       (x = x+1)
SKIN_MEM_PC CORE_PC        jump line 05 (endwhile)
8'h05
SKIN_MEM_PC CORE_AR        load y to DR1 (print y)
8'h90
SKIN_MEM_AR CORE_DR1       
CORE_DR1    SKIN_OTH       
CORE_NULL   CORE_NULL      (exit)


