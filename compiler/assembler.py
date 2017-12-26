#! $PATH/python

# file name: machine_instruction_parser.py
# author: lianghy
# time: 2017-9-20 14:36:57

"""Bean assebmler. Convert Assembly to machine code for simulation."""

import os
from os.path import join
import re
import argparse
import configparser
import common_func as bbc

assemble_pattern = {
        'null'                  :   r'\s*'                          ,
        'comments'              :   r'^#'                           ,
        'label_ref'             :   r'^lable_[a-z0-9]+ [a-f0-9]+'         ,
        'quote_lable'           :   r'^[a-z0-9_]+ lable_[a-z0-9]+'   ,
        'normal_ins'            :   r'[a-z0-9_]+'
        }

BAS_pattern = {
        'return'        : r"\n",
        'data'          : r"[a-f0-9]+",
        'command'       : r"(REG_[_A-Z0-9]*)|(MEM_[_A-Z0-9]*)|(ALU_[_A-Z0-9]*)"
        }

BAS_map = {
    'REG_NULL'      : '0',
    'REG_IR'        : '1',
    'REG_PC'        : '2',
    'REG_AR'        : '3',
    'REG_DR0'       : '4',
    'REG_DR1'       : '5',
    'REG_CR'        : '6',
    'REG_DR2'       : '7',
    'ALU_RE'        : '8',
    'ALU_AD'        : '9',
    'REG_EMPTY'     : 'a',
    'REG_EMPTY'     : 'b',
    'MEM_PC'        : 'c',
    'MEM_AR'        : 'd',
    'MEM_OTH'       : 'e',
    'MEM_NULL'      : 'f'
}

BAS_TOKEN_EX = '|'.join('(?P<%s>%s)' % item for item in BAS_pattern.items())

def analyse_bas_patter(contents):
    """analyse BAS command and data pattern, return a list."""
    for one_pattern in re.finditer(BAS_TOKEN_EX, contents):
        lexical_type = one_pattern.lastgroup
        lexical_str = one_pattern.group(lexical_type)
        if lexical_type == 'return':
            yield lexical_str
        elif lexical_type == 'data':
            #yield bbc.verilog_number_to_binary_string(lexical_str)
            #yield bbc.verilog_number_to_hex(lexical_str)
            yield lexical_str
        elif lexical_type == 'command':
            #print(lexical_str)
            yield "".join(BAS_map[name] for name in lexical_str.split(' '))
            # next
        else:
            raise Exception("Unkown patter: {}".format(lexical_type))

def convert_bas_to_bmh(in_file, out_file, config):
    """convert BAS to a binary string file for initial the memory when simulating the verilog."""
    print("start assembler! source file is {}, and target file is {}".format(in_file, out_file))
    if os.stat(in_file).st_size > int(config['DEFAULT']['BAS_file_size']):
        raise Exception("File size exceeds the limitation.")
    with open(in_file, 'r') as fin:
        all_content = fin.read()
    with open(out_file, 'w') as fout:
        #fout.writelines(["{}\n".format(x) for x in analyse_bmi_patter(all_content)])
        fout.writelines([x for x in analyse_bas_patter(all_content)])


if __name__ == "__main__":
    print("machine_instruction_parser.py")
