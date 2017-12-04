Introduction
============

This compiler has these function:

1. Converts Bean Machine Instruction in string form to binary(hexadecimal) string for verilog simulation.
2. Parse Bean Assembely Instruction, and generate BMI file.
3. :TODO: generate a binary file for excute.

Usage:

BAI file:  python file.py

BMI file:  python dir/machine_instruction_parser.py file.bmi

Compiler:

Bean program

   Tokenlizer  -> Token_list
   Lexer       -> generate statement
   parser      -> analyse statement


Bean assembler translates the assebmly file to binary file.
Bean lexier translates the bean file to assembler file. 

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


Bean Language Parser
====================

BAI Parser parse the .b file to a python object. The python object will be converted to binery file by Bean Language Interpreter.



BAI Converter
=============

BAI Converter is a package of python, provides function to program in the Bean Assembly Language.
It does not optimize the program.
The Bean python program is excuted line by line.

With this package, programmer can write assembly program in a python style.
The basic class is AssemblyConverter.
To generate .bmh file for simulation, call AssemblyConverter.generate_BMH(),
To generate .bmi file as a assembly file, call AssemblyConverter.generate_BMI(),
To generate .bmb file as a binary file, call AssemblyConverter.generate_BMB(),
To excute these instructions, call AssemblyConverter.run().

Register of the instructions is defined as an attribute.
Such as "self.reg.dr0" means "CORE_DR0"
:TODO: change self.reg.dr0 to reg.dr0?
       reg = Registers()

Memory Allocation
-----------------

Ask for free lines
~~~~~~~~~~~~~~~~~~
next

write data to lines
~~~~~~~~~~~~~~~~~~~


Variable
--------

Generate a new variable:

1. check variable name in the namespace
2. ask for a free line in data page
3. write data to the line
4. write variable name to the namespace
5. write variable point address to the namespace.

Static variables are stored, and the statement of define the variables is not excute in a compiled program.
If the source code is excuted dynamitcly, SetVariable function allocates memory for the variables.

==========  ===========
attribute   value
==========  ===========
name        string
type        interge
address     line number
==========  ===========

local variable
~~~~~~~~~~~~~~

=============  ==================
attribute      value
=============  ==================
page           page number
variable_list  all local variable
=============  ==================


Block
-----

Bean Assembly Instruction uses block namespace to locate the loop block start and end lines.
When starts a loop, set a block name and the relevant line number.

Bean Assembly Instruction uses namespace to locate each function start and end lines.
When a program call a function of another program, from the block space,
it searches the start line of the function.

While
~~~~~

parse source::

   start_line_stack.append(start_line_number)
   branche( v1 v2 con endblock)
   block body
   back_to_start_line(start_line_stack.pop())
   end_line_stack.append(end_line_number)

fill block label(called by endwhile)::

   for line in while_block():
      if end_line_label in line:
         replace end_line_label with end_line_stack.pop()

   check_while_block()


generate_BAI():
The block label points to a line, but the size() function cant get the line number.
To get the line number, firstly genegrate a block label, then iterate each line to count the number.



Addressing Mode
---------------

To support addressing mode in python style, define addressing function.

================  =======  =======
address type      example  function
================  =======  =======
register          DR1      reg("DR1")
immediate         8'h01    data('1')
direct            (8'h01)  mem('1')
memory indirect   @8'h01   mem(mem('1'))
================  =======  =======


branch(data(01), mem(02), "==", 'x')

-------------------------------------------------------------------------------------

Memory Management
-----------------

Use global namespace to manage all veriables, program and data space.
Currently, the data space is started from 8'h10.
The last value of body_level list is current body level.

.. python::

   global_namespace = {
      data_space: "8'h10",
      veriables : {},
      body_level: []
   }

Compiling
---------

compile by lines.

.. python::

   veriable_re    = r"[_0-9a-zA-Z]"
   data_re        = r"8'h[0-9a-f][0-9a-f]"
   source_reg_re  = r"|".join(['IR', 'PC', 'AR', 'DR0', 'DR1', 'CR', 'RE', 'AD'])
   target_reg_re  = r"|".join(['IR', 'PC', 'AR', 'DR0', 'DR1', 'CR'])
   block_line        = r"^block {}\n".format(veriable_re)
   let_line          = r"^let {} {}\n".format(target_reg_re, data_re)
   add1_line         = r"^add1 {}\n".format(target_reg_re)
   jump_line         = r"^jump {}\n".format(veriable_re)

   #reg_load_line     = r"^load {} {}".format(register_re, data_re)

   address_re  = r"8'h[0-9a-f][0-9a-f]"
   sub_body_re = r":"
   expr_re     = r""
   true_re     = r"1|True"
   false_re    = r"0|False"
   compare_re  = r"|".join('<', '==', '>', '!=')
   assert_re   = r"{0} {1} {0}".format("|".join([data_re, veriable_re]), compare_re)
   set_line          = r" ".join(["set", veriable_re, address_re])
   assignment_line   = r" ".join([veriable_re, '=', data_re])
   while_assert_re   = r"|".join([true_re, false_re, ])
   while_line        = r"while {} *{}".format(while_assert_re, sub_body_re)
   body_level_re = "    "*body_level
   
 
parser
------

Each Black Bean Assembly Instruction is an instruction function of class BAICompiler.
When call the instruction function, the function will generate the Machine Instruction.
To generate the BMI file, call BAICompiler.generate_BMI(*file*).
:TODO: To run the assembly instruction, call BAICompiler.excute().





Structure
=========

files:

bb_assembly_compiler.py is the main file.
machine_language.py is the machine_language compiler.
assembly_language.py is the assembly_language compiler.

COMPILER_CONFIG is global config.

