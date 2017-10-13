============================
Black Bean Assembly compiler
============================

Introduction
============

This compiler has these function:

1. Converts Bean Machine Instruction in string form to binary(hexadecimal) string for verilog simulation.
2. Parse Bean Assembely Instruction, and generate BMI file.
3. :TODO: generate a binary file for excute.

Usage:

BAI file:  python file.py

BMI file:  python dir/machine_instruction_parser.py file.bmi

BMI Converter
=============

BMI Pattern
-----------

Assemble pattern are shown as follow:

return          `\n`
    new line, keep

data            `\d'h\d+`
    data

command         `(CORE_\w*)|(IOSC_\w*)|(ALU_\w*)`
    normal machine instruction

Algorithm
---------

To convert the BMI file, the command is `python machine_instruction_parser.py file/dir [-o dir]`
The output file is the same name with the BMI file, but with differnet suffixes as *bmh*.
If given an output directory, all output file is export to that directory with the same heirachy as the input directory.
If the source is a directory, and the output directory is not provided,
an "output" directory is created in current directory as the default output directory.

1. check file size, make sure the file is smaller tham 1M.
2. check file suffixe is *bmi*.
3. read in all, and convert to benary/hexadecimal string.

BAI Parser
==========

BAI Parser is a package of python, provides function to program in the Bean Assembly Language.
With this package, programmer can write assembly program in a python style.
The basic class is AssemblyParser.
To generate .bmh file for simulation, call AssemblyParser.generate_BMH(),
To generate .bmi file as a assembly file, call AssemblyParser.generate_BMI(),
To generate .bmb file as a binary file, call AssemblyParser.generate_BMB(),
To excute these instructions, call AssemblyParser.run().

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

B Language compiling
====================

COMPILER_CONFIG
---------------

Memory Management
-----------------

Divide memory to different blocks.

- program block

  store the origin program.
  load new program.

- running block

  variables and datas.


=============  ==============================  ==================================
pattern        regular expression              description
=============  ==============================  ==================================
null           `\s*`                           empty line  
lable_ref      `^lable_[a-z0-9]+ [a-f0-9]+`    the target line of one block
quote_lable    `^[a-z0-9_]+ lable_[a-z0-9]+`   quote the line number of the block
=============  ==============================  ==================================

Addressing Mode
---------------

Supported mode:

- direct addrssing.

  all address is a directe address.



Structure
=========

files:

bb_assembly_compiler.py is the main file.
machine_language.py is the machine_language compiler.
assembly_language.py is the assembly_language compiler.

COMPILER_CONFIG is global config.

