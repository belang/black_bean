#! $PATH/python

# file name: machine_instruction_parser.py
# author: lianghy
# time: 2017-9-20 14:36:57

"""Bean instruction compiler.  """

import os
from os.path import join
import re
import argparse
import configparser
import black_bean_common_func as bbc

assemble_pattern = {
        'null'                  :   r'\s*'                          ,
        'comments'              :   r'^#'                           ,
        'label_ref'             :   r'^lable_[a-z0-9]+ [a-f0-9]+'         ,
        'quote_lable'           :   r'^[a-z0-9_]+ lable_[a-z0-9]+'   ,
        'normal_ins'            :   r'[a-z0-9_]+'
        }

BMI_pattern = {
        'return'        : r"\n",
        'data'          : r"\d+'h[a-f0-9]+",
        'command'       : r"(CORE_[_A-Z0-9]*)|(SKIN_[_A-Z0-9]*)|(ALU_[_A-Z0-9]*)"
        }

BMI_map = {
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

BMI_TOKEN_EX = '|'.join('(?P<%s>%s)' % item for item in BMI_pattern.items())

def analyse_bmi_patter(contents):
    """analyse BMI command and data pattern, return a list."""
    for one_pattern in re.finditer(BMI_TOKEN_EX, contents):
        lexical_type = one_pattern.lastgroup
        lexical_str = one_pattern.group(lexical_type)
        if lexical_type == 'return':
            yield lexical_str
        elif lexical_type == 'data':
            #yield bbc.verilog_number_to_binary_string(lexical_str)
            yield bbc.verilog_number_to_hex(lexical_str)
        elif lexical_type == 'command':
            #print(lexical_str)
            yield "".join(BMI_map[name] for name in lexical_str.split(' '))
            # next
        else:
            raise Exception("Unkown patter: {}".format(lexical_type))

def convert_bmi_to_bmh(in_file, out_file):
    """convert BMI to a binary string file for initial the memory when simulating the verilog."""
    with open(in_file, 'r') as fin:
        all_content = fin.read()
    with open(out_file, 'w') as fout:
        #fout.writelines(["{}\n".format(x) for x in analyse_bmi_patter(all_content)])
        fout.writelines([x for x in analyse_bmi_patter(all_content)])

ROOT = os.path.dirname(os.path.realpath(__file__))
def parse_check_file_type(string):
    """check if it is a file or directory"""
    if os.path.isfile(string):
        return string
    elif os.path.isdir(string):
        return string
    else:
        raise argparse.ArgumentTypeError("{} is not a file or dir".format(string))

## environment parse

PARSER = argparse.ArgumentParser(description='Bean assembly instruction compiler.')
PARSER.add_argument('input_file',
                   type=parse_check_file_type,
                   help='single input file or all .bba files in a directory.')
PARSER.add_argument('-o', metavar='output directory', dest='output_file',
                   help='single output file or directory.')

ARGS = PARSER.parse_args()

CONFIG = configparser.ConfigParser()
CONFIG.read(join(ROOT, 'config.ini'))

def compile_file(fone, fout):
    """ compile one file """
    if os.stat(fone).st_size > int(CONFIG['DEFAULT']['BMI_file_size']):
        raise Exception("File size exceeds the limitation.")
    if fone.endswith('bmi'):
        convert_bmi_to_bmh(fone, fout)
    else:
        raise Exception("file type error.")

def machine_instruction_parser(args):
    """main process, support parse a directory or a single file."""
    if os.path.isfile(args.input_file):
        if args.output_file is None:
            toutput_file = "{}bmh".format(args.input_file[0:-3])
        compile_file(args.input_file, toutput_file)
    elif os.path.isdir(args.input_file):
        if args.output_file is None:
            try:
                os.path.mkdir("output")
            except:
                raise Exception("Can't create directory: output")
        elif os.path.isdir(args.output_file):
            pass
        else:
            raise Exception("Output directory is wrong")
        for root, dirs, files in os.walk(args.input_file):
            o_sub_root = root.lstrip(args.input_file)[1:]
            for fone in files:
                compile_file(fone, join(args.output_file, o_sub_root, fone)[0:-3])
        else:
            raise Exception("arguments parse Error.")
    else:
        raise Exception("arguments parse Error.")

if __name__ == "__main__":
    machine_instruction_parser(ARGS)
    print("machine_instruction_parser.py")
