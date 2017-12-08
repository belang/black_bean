############
Introduction
############

Bean system is about how to program on Bean processor.

#############
Bean Language
#############

Word
====

=,+,-,*,/,(,)
if,else,while,exit,end

Statement
=========

=============  ==================================  ==============
type           grammar                             discription
=============  ==================================  ==============
stmt           [assg,expr,if,while,exit]
assignment_    variable = expr
expr_          term,plusminus
plusminus      [expr+muldiv,expr-muldiv,muldiv]  
muldiv         [muldiv/term,muldiv*term,term]
variable       [a-z,A-Z][a-z,A-Z,0-9,_]*
data           [0-9]
term           [variable,data]
if             if ( expr ) else stmt
while          while ( expr ) stmt
end            end                                 finish a block
exit           exit
black          ' '                                 empty
return         '\n'                                new line
for            for x in list: first: then: last:   
new_           new var = data                      allocate a new memory space for the variable.
=============  ==================================  ==============

.. _assignment: new_
.. _new: 
   In Bean program, assignment means the variable point to value address of the source variable or data.
   When assign with a 'new' statement, allocate new memory space for the variable, and save the value to the new space.
   For example,
   When "a = 8'h30", the data 8'h30 is stored in 8'h50, and the data of a is 8'h50, a is stored in 8'h10.
   When "b = a", variable b is stored in 8'h11, and its data is 8'h50.
   When "new b = a", variable b is stored in 8'h11, and its data is 8'h51, and the value(data in 8'h51) is 8'h10.
   For string type, "b = 'abcd'", b is stored in 8'h10, its value is 8'h20, and "abcd" is stored in 8'h20-8'h23.
   Next assignment, "b = b+'efg'", "efg" may be stored in other places for example 8'h30-32.
.. _expr:  expr is caculate from left to right.
   Don't support multi assignment in one line such as y=x=3.

Expression
==========

=============  ==================================  ==============
type           grammar                             discription
=============  ==================================  ==============
+,-            a+b+c-d
/,*            a*b*c/d
=============  ==================================  ==============

Memory Allocation
=================

Strucnture
----------

The bean architecture organizes the memory as blocks and pages.
A block is a program, include the source code and the running space.
A page is a function with local variable and datas.

Page
====

Memory controller shows the free space, and reorder the data.

Each page is considered as a paper note page, on which lines have been printed.
Each line has one byte.


The page number is on the foot, 

Variable
========

Private variable is not saved, but translated as a address by compiler.
Public variable is saved in the NameSpace, so other function can call it, or
public variable is designed as a function, which get the value(address) of the variable.

Addressing Mode
===============

================  =======  =======
address type      example  compute
================  =======  =======
register          DR1      
immediate         8'h01
direct            (8'h01)  Mem[8'h01]
memory indirect   @8'h01   Mem[Mem[8'h01]]
================  =======  =======

Bean Assembly Instrution
========================

=======  ===========
Terms    Description
=======  ===========
reg      register name, include all ports defined in machine instructions.
data     immediate data in string format such as 8'h01
label    a user define string
v1       varialbe 1, maybe data or register
rel      relation: <, ==, >, !<, !=, !>
=======  ===========

============================  ================  ===========
Instrution                    Action            Description
============================  ================  ===========
set reg data                  Reg <= Data       set immediate data to register
add1                          Reg0 <= Reg0+1    register data0 add 1
load reg addr                 Reg <= Mem(addr)
save addr reg                 Mem(addr) <= Reg
if v1 rel v2                                    if v1 is a variable, set the value to DR0,
                                                is a data, set to DR0,
                                                is reg, set to DR0,
                                                is DR0, no action;
                                                v2 is saved at DR1.
endif
while v1 rel v2                                 v1/v2 is processed the same as if.
endwhile
exit                          00
v1                            excute v1         if v1 is a function, call function
print v                                         load to oth.
v = v+v
============================  ================  ===========

=========================  =============  ======================================================
data                       8'h**          datas are written in hexadecimal.
veriable                   [_0-9a-zA-Z]   veriable names and keys.
expr                                      expression of bean assembly instruction
=========================  =============  ======================================================

next
A ass


A program can be writen in any one of the two instruction, or both.
The BAI do not have the same instruction as BMI.
A file with postfix .bmi is a BMI file, but that with .bai is mixed.

A complete program should include memory allocation,

Here, black bean architecture will define a series of rules about
how to do memory allocation.

