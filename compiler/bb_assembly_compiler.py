#! $PATH/python

# file name: compile_bea_instruction.py
# author: lianghy
# time: 2017-7-27 15:49:37

"""Bean instruction compiler.  """

import os
from os.path import join
import re
import argparse
import configparser

import assembler
import tokenizer
import lexer
import beanparser

ROOT = os.path.dirname(os.path.realpath(__file__))
def parse_check_file_type(string):
    """check if it is a file or directory"""
    if os.path.isfile(string):
        return string
    elif os.path.isdir(string):
        return string
    else:
        raise argparse.ArgumentTypeError("{} is not a file or dir".format(string))
def parse_check_dir_type(string):
    """check if it is a file or directory"""
    if os.path.isdir(string):
        return string
    else:
        raise argparse.ArgumentTypeError("{} is not a dir".format(string))

PARSER = argparse.ArgumentParser(description='Bean assembly instruction compiler.')
PARSER.add_argument('input_file',
                    type=parse_check_file_type,
                    help='single input file or a directory.')
PARSER.add_argument('-o', metavar='output file/directory', dest='output_dir',
                    type=parse_check_dir_type,
                    help='single output directory.')
PARSER.add_argument('-m', metavar='mode', dest='mode', default="n",
                    help='d: debug')

ARGS = PARSER.parse_args()

CONFIG = configparser.ConfigParser()
CONFIG.read(join(ROOT, 'config.ini'))
print(join(ROOT, 'config.ini'))

## debug function
def show_var_addr(result):
    """docstring for show_var_addr"""
    [print(x.name, " ", x.physical_addr) for x in result[-1][-1].nas.var_list]

debug_func = {"show_var_addr": show_var_addr}
## main function
def compile_one_file(infile, oudir):
    if infile.endswith('bas'):
        if oudir is None:
            oufile = "{}bmh".format(infile[0:-3])
        else:
            oufile = join(oudir, "{}bmh".format(infile[0:-3]))
        assembler.convert_bas_to_bmh(infile, oufile, CONFIG)
    elif infile.endswith('.bea'):
        line_token = tokenizer.LineTokenizer()
        with open(infile, 'r') as fin:
            for one_line in fin.readlines():
                line_token.analize_line(one_line)
        token_view = lexer.lexer(line_token.token_list)
        assembly_view = beanparser.Parser(token_view)
        #generate simulation files
        if oudir is None:
            assembly_file = "{}bas".format(infile[0:-3])
            verilog_simu_file = "{}bmh".format(infile[0:-3])
        else:
            assembly_file = join(oudir, "{}bmh".format(infile[0:-3]))
            verilog_simu_file = join(oudir, "{}bas".format(infile[0:-3]))

        assembly_view.write_simu_file(assembly_file)
        assembler.convert_bas_to_bmh(assembly_file, verilog_simu_file, CONFIG)
    else:
        raise Exception("Unknown file type {}".format(infile))
    return line_token, token_view, assembly_view

def compile_file(args):
    """main compiling progress
    support parse a directory or a single file."""
    result = []
    infile = args.input_file
    oudir = args.output_dir
    if os.path.isfile(infile):
        result.append(compile_one_file(infile, oudir))
    else:
        if oudir is None:
            os.path.mkdir("output")
            oudir = "output"
        else:
            oudir = args.output_dir
        for root, dirs, files in os.walk(args.input_file):
            o_sub_root = root.lstrip(args.input_file)[1:]
            for one_dir in dirs:
                os.path.mkdir(join(outfile, one_dir))
            for fone in files:
                result.append(compile_one_file(fone, join(oudir, o_sub_root)))
    if args.mode == 'd':
        while True:
            #exec(input(">>>"))
            in_com = input(">>>")
            exe_com = re.fullmatch(r"exec(\(.*\))", in_com)
            if exe_com is not None:
                exec(exe_com.groups()[0])
            else:
                debug_func[in_com](result)

if __name__ == "__main__":
    compile_file(ARGS)
    print("compile_bea_instruction.py")
