#! $PATH/python

# file name: compile_bean_instruction.py
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
import lexer_token_view as ltv
import lexer_assembly_view as lav

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

ARGS = PARSER.parse_args()

CONFIG = configparser.ConfigParser()
CONFIG.read(join(ROOT, 'config.ini'))
print(join(ROOT, 'config.ini'))

def compile_one_file(infile, oudir):
    if infile.endswith('bmi'):
        if oudir is None:
            oufile = "{}bmh".format(infile[0:-3])
        else:
            oufile = join(oudir, "{}bmh".format(infile[0:-3]))
        assembler.convert_bai_to_bmh(infile, oufile, CONFIG)
    elif infile.endswith('.bai'):
        line_token = tokenizer.LineTokenizer()
        with open(infile, 'r') as fin:
            for one_line in fin.readlines():
                line_token.analize_line(one_line)
        token_view = ltv.TokenLexer(line_token.token_list)
        assembly_view = lav.AssemblyLexer(token_view)
        #generate simulation files
        oufile = "{}bmi".format(infile[0:-3])
        assembly_view.gen_simu_file(oufile)
    else:
        raise Exception("Unknown file type {}".format(infile))

def compile_file(args):
    """main compiling progress
    support parse a directory or a single file."""
    infile = args.input_file
    oudir = args.output_dir
    if os.path.isfile(infile):
        compile_one_file(infile, oudir)
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
                compile_one_file(fone, join(oudir, o_sub_root))

if __name__ == "__main__":
    compile_file(ARGS)
    print("compile_bean_instruction.py")
