============================
Black Bean Assembel compiler
============================

Introduction
============

This compiler converts bean instruction in string form to hexadecimal string for verilog simulation.

:TODO: generate a binary file for excute.

Assemble Pattern
================

Assemble pattern are shown as follow:

=============  ==============================  ==================================
pattern        regular expression              description
=============  ==============================  ==================================
null           `\s*`                           empty line  
comments       `^#`                            comments line
lable_ref      `^lable_[a-z0-9]+ [a-f0-9]+`    the target line of one label
quote_lable    `^[a-z0-9_]+ lable_[a-z0-9]+`   quote the line number of the label
normal_ins     `[a-z0-9_]+`                    normal machine instruction
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

1. Parse the assemble file '.bba' to '.bbh':
   
   - convert the assemble string to machine instruction hexadecimal string.
   - make each line one machine instruction.
   - record the line number of the label reference and that quotes label.

2. Link '.bbh' to '.bbb':

   - replace the quoting line label string to the consponding number.
   - remove the label reference line
