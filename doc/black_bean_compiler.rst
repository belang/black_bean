Introduction
============

Bean language file ends with .bean
Bean assembley file ends with .bas
Bean simulation file ends with .bmh

This compiler has these function:

1. Converts Bean Machine Instruction in string form to binary(hexadecimal) string for verilog simulation.
2. Parse Bean Assembely Instruction, and generate BMI file.
3. :TODO: generate a binary file for excute.

Usage:

BMI file:  python compiler.py file.bea

Compiler
========

   Tokenlizer  -> Token_list
   Lexer       -> statement structure
   Parse       -> statement object
   Generator   -> assembly code
   Assembler   -> binary file or simu file
   Linker      -> import file or package

Debug
-----

1. show the memory variable allocation.

Bean Assembler
==============

All data in .bas file is writen in hexadecimal without prefix.

Algorithm
---------

The output file is the same name with the BAS file, but with differnet suffixes as *bmh*.

1. check file size, make sure the file is smaller tham 1M.
2. check file suffixe is *bas*.
3. read in all


Tokenizer
=========

Get all token of the program.
The token is a class, with attribute ttype and tvalue.

Token line state:

==========  =========================
state       discription
==========  =========================
start       start of the line
end         end of the line
indent      the first string is empty
term        search a term
continue    in the middle of a stmt
==========  =========================

When get in a new state, deal with the last state: finish or continue it.

Function
--------

1. convert the Decimal numbers to Hexadecimal.


Lexer
=====

=============  =======================================================================
TokenView      recognize the statement type, and then get all tokens of the statement;
               analyse the structure of the statement, form the expr, variable and so on objects.
AssemblyView   create variables in the namespace;
               write the assembly code in the form of variables;
               allocate the memory to the code_page;
               third, allocate the memory to the run_page;
               change the virtual address in the assembly code to the true address.
=============  =======================================================================

The detail is in "BB compiler.xmind".

When generate the assembly code,
first, all variable is stored in the run_page with a virtual address;
seconde, allocate the memory to the code_page;
third, allocate the memory to the run_page;
last, change the virtual address in the assembly code to the true address.



Parser
======

1. parse_structure: split lines or composed statement into atom statement.
2. parse_variable: create variable in namespace.
3. generate_code_with_var: generate codes object with variable in it.
4. allocate_mem_space(get code size): allocate memory space, for example code page, static varialbe lines, temp varialbe lines.
5. caculate_physical_addr: caculate the physical address of the memory element.
   For dynamic variables, allocate the space to them by order in one statement, and reset the dynamic space pointer at the end of the statement.



Structure
=========

files:



bb_assembly_compiler.py is the main file.

COMPILER_CONFIG is global config.

