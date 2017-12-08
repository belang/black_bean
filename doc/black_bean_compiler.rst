Introduction
============

This compiler has these function:

1. Converts Bean Machine Instruction in string form to binary(hexadecimal) string for verilog simulation.
2. Parse Bean Assembely Instruction, and generate BMI file.
3. :TODO: generate a binary file for excute.

Usage:

BMI file:  python compiler.py file.bmi

Compiler:

   Tokenlizer  -> Token_list
   Lexer       -> assembly code
   Assembler   -> binary file or simu file


Bean Assembler
==============

Bean Assembly Pattern
---------------------

Assemble pattern are shown as follow:

return          `\n`
    new line, keep

data            `\d'h\d+`
    data

command         `(CORE_\w*)|(SKIN_\w*)|(ALU_\w*)`
    normal machine instruction

Algorithm
---------

To convert the BMI file, the command is `python machine_instruction_parser.py file/dir [-o dir]`
The output file is the same name with the BMI file, but with differnet suffixes as *bmh*.
If given an output directory, all output file is export to that directory with the same heirachy as the input directory.
If the source is a directory, and the output directory is not provided,
an "output" directory is created in current directory as the default output directory.

1. check file size, make sure the file is smaller tham 1M.
2. check file suffixe is *bai*.
3. read in all, and convert to benary/hexadecimal string.


Bean Language Lexier
====================

data type only support decimal type.

==========  ===================================
process     discription
==========  ===================================
tokenizer   get the token
lexer       form the structure of the statement
parser      analyse the program function
==========  ===================================

Tokenizer
---------

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

Lexer
-----

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





Structure
=========

files:

bb_assembly_compiler.py is the main file.

COMPILER_CONFIG is global config.

