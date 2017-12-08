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

BAI_pattern = {
        'return'        : r"\n",
        'data'          : r"\d+'h[a-f0-9]+",
        'command'       : r"(CORE_[_A-Z0-9]*)|(SKIN_[_A-Z0-9]*)|(ALU_[_A-Z0-9]*)"
        }

BAI_map = {
        'CORE_NULL'       : '0',
        'CORE_IR'         : '1',
        'CORE_PC'         : '2',
        'CORE_AR'         : '3',
        'CORE_DR0'        : '4',
        'CORE_DR1'        : '5',
        'CORE_CR'         : '6',
        'CORE_EMPTY'      : '7',
        'ALU_RE'          : '8',
        'ALU_AD'          : '9',
        'CORE_EMPTY'      : 'a',
        'CORE_EMPTY'      : 'b',
        'SKIN_MEM_PC'     : 'c',
        'SKIN_MEM_AR'     : 'd',
        'SKIN_OTH'        : 'e',
        'SKIN_NULL'       : 'f'
}

BAI_TOKEN_EX = '|'.join('(?P<%s>%s)' % item for item in BAI_pattern.items())

def analyse_bai_patter(contents):
    """analyse BAI command and data pattern, return a list."""
    for one_pattern in re.finditer(BAI_TOKEN_EX, contents):
        lexical_type = one_pattern.lastgroup
        lexical_str = one_pattern.group(lexical_type)
        if lexical_type == 'return':
            yield lexical_str
        elif lexical_type == 'data':
            #yield bbc.verilog_number_to_binary_string(lexical_str)
            yield bbc.verilog_number_to_hex(lexical_str)
        elif lexical_type == 'command':
            #print(lexical_str)
            yield "".join(BAI_map[name] for name in lexical_str.split(' '))
            # next
        else:
            raise Exception("Unkown patter: {}".format(lexical_type))

def convert_bai_to_bmh(in_file, out_file, config):
    """convert BAI to a binary string file for initial the memory when simulating the verilog."""
    print("start assembler! source file is {}, and target file is {}".format(in_file, out_file))
    if os.stat(fone).st_size > int(config['DEFAULT']['BAI_file_size']):
        raise Exception("File size exceeds the limitation.")
    if fone.endswith('bai'):
        assembler.convert_bai_to_bmh(fone, fout)
    else:
        raise Exception("file type error.")
    with open(in_file, 'r') as fin:
        all_content = fin.read()
    with open(out_file, 'w') as fout:
        #fout.writelines(["{}\n".format(x) for x in analyse_bmi_patter(all_content)])
        fout.writelines([x for x in analyse_bai_patter(all_content)])


if __name__ == "__main__":
    machine_instruction_parser(ARGS)
    print("machine_instruction_parser.py")
