Test Case Spcecification
========================

Test case directory contains test vector in arsembly language.

==========================  =================  ==============================
instruction                 temp assembly      explain                       
==========================  =================  ==============================

==========================  =================  ==============================
IOSC_INS_PC CORE_DR0        set dr0 8'h01      write 8'h01 to memory 8'h10
8'h01                       
IOSC_INS_PC CORE_AR         set ar 8'h10       "write addr data"    
8'h10                       
CORE_DR0    IOSC_INS_AR     write dr           write 8'h10 8'h01    
==========================  =================  ==============================
IOSC_INS_PC CORE_DR0        write 8'h40 8'hc2  write a program to the line    
IOSC_INS_PC CORE_AR         set addr           8'h40, which reads line 8'h00 
IOSC_INS_PC CORE_AR                            
8'h40                                                                        
CORE_DR0    IOSC_INS_AR                                                  
IOSC_INS_PC CORE_DR0        write 8'h41 8'h00                                 
8'h00                       addr                                             
IOSC_INS_PC CORE_AR                                                          
8'h41                                                                        
CORE_DR0    IOSC_INS_AR                                                  
IOSC_INS_PC CORE_DR0        write 8'h42 8'h84                                 
IOSC_INS_AR CORE_DR1        read to dr1                                      
IOSC_INS_PC CORE_AR                                                          
8'h42                                                                        
CORE_DR0    IOSC_INS_AR                                                  
IOSC_INS_PC CORE_DR0        write 8'h43 8'h00                                 
CORE_NULL   CORE_NULL       stop                                             
IOSC_INS_PC CORE_AR                                                          
8'h43                                                                        
CORE_DR0    IOSC_INS_AR                                                  
IOSC_INS_PC CORE_PC         jump to 8'h40                                    
8'h40                                                                        
CORE_NULL   CORE_NULL                                                          
==========================  =================  ==============================
















