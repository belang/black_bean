Test Case Spcecification
========================

Test case directory contains test vector in arsembly language.

==========================  =================  ==============================
instruction                 temp assembly      explain                       
==========================  =================  ==============================
ACTION_READ_PC UNIT_DR0     set dr0 data       write 8'h01 to memory 8'h10
8'h01                       set ar data                                           
ACTION_READ_PC UNIT_AR      write dr           
8'h10                       or                                               
ACTION_WRITE UNIT_DR0       write addr data    
==========================  =================  ==============================
ACTION_READ_PC UNIT_DR0     write 8'h40 8'hc2  write a program to the line    
ACTION_READ_PC UNIT_AR      set addr           8'h40, which reads line 8'h00 
ACTION_READ_PC UNIT_AR                         
8'h40                                                                        
ACTION_WRITE UNIT_DR0                                                 
ACTION_READ_PC UNIT_DR0     write 8'h41 8'h00                                 
8'h00                       addr                                             
ACTION_READ_PC UNIT_AR                                                       
8'h41                                                                        
ACTION_WRITE UNIT_DR0                                                 
ACTION_READ_PC UNIT_DR0     write 8'h42 8'h84                                 
ACTION_READ_AR UNIT_DR1     read to dr1                                      
ACTION_READ_PC UNIT_AR                                                       
8'h42                                                                        
ACTION_WRITE UNIT_DR0                                                 
ACTION_READ_PC UNIT_DR0     write 8'h43 8'h00                                 
ACTION_PAUSE UNIT_NULL      stop                                             
ACTION_READ_PC UNIT_AR                                                       
8'h43                                                                        
ACTION_WRITE UNIT_DR0                                                 
ACTION_READ_PC UNIT_PC      jump to 8'h40                                    
8'h40                                                                        
ACTION_PAUSE UNIT_NULL                                                       
==========================  =================  ==============================
















