============================
Black Bean Assembel compiler
============================

Introduction
============

This compiler converts bean instruction in string form to benary(hexadecimal) string for verilog simulation.
It deals with two type of programs, BMI and BAI.
If a file is a BMI file, compiler convert them to benary(hexadecimal) file,
and a BAI type to a BMI file firstly.

:TODO: generate a binary file for excute.

BMI compiling
=============

BMI Pattern
-----------

Assemble pattern are shown as follow:

return          new line, keep
    `\n`

data            data
    `\d'h\d+`

command         normal machine instruction
    `(CORE_\w*)|(IOSC_\w*)|(ALU_\w*)`

Algorithm
---------

1. check file size, make sure the file is smaller tham 1M.
2. read in all, and convert to benary/hexademic string.

   1. 


=============  ==============================  ==================================
pattern        regular expression              description
=============  ==============================  ==================================
null           `\s*`                           empty line  
lable_ref      `^lable_[a-z0-9]+ [a-f0-9]+`    the target line of one label
quote_lable    `^[a-z0-9_]+ lable_[a-z0-9]+`   quote the line number of the label
=============  ==============================  ==================================

Processing Pattern
==================

=============  =============================================================
pattern        process           
=============  =============================================================
null           EMPTY. set as EMPTY instruction  
comments       null. remove the line 
lable_ref      data. remove the label, keep the data, record the label number
quote_lable    two lines. seperate two words to two lines
normal_ins     kept. keep machine instruction
=============  ===========================  ==================================

Flow
====

1. Parse the assemble file '.bai' to '.bmi':
   
   - convert the assemble string to machine instruction hexadecimal string.
   - make each line one machine instruction.
   - record the line number of the label reference and that quotes label.

2. Link '.bmi' to '.bmb':

   - replace the quoting line label string to the consponding number.
   - remove the label reference line


Useage of Tool
==============

To run the tool, input "python(3) bbac input_file [option]"

input_file:
    single input file or all .bba files in a directory.

-o file_diretory        single output file or directory. 
                        if the input is a direcotry, and the output must be a dierctory,
                        and the output files havs the same base name with postfix .bbb,
                        and the output hierachy is the same as input file.

