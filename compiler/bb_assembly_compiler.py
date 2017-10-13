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

import machine_language as ml
import assembly_parse as ap

ROOT = os.path.dirname(os.path.realpath(__file__))
def parse_check_file_type(string):
    """check if it is a file or directory"""
    if os.path.isfile(string):
        return string
    elif os.path.isdir(string):
        return string
    else:
        raise argparse.ArgumentTypeError("{} is not a file or dir".format(string))

PARSER = argparse.ArgumentParser(description='Bean assembly instruction compiler.')
PARSER.add_argument('input_file',
                   type=parse_check_file_type,
                   help='single input file or all .bba files in a directory.')
PARSER.add_argument('-o', metavar='output file/directory', dest='output_file',
                   type=parse_check_file_type,
                   help='single output file or directory.')

ARGS = PARSER.parse_args()

CONFIG = configparser.ConfigParser()
CONFIG.read(join(ROOT, 'config.ini'))
print(join(ROOT, 'config.ini'))

def compile_file(args):
    """main compiling progress
    support parse a directory or a single file."""
    if os.path.isfile(args.input_file):
        if os.stat(args.input_file).st_size > int(CONFIG['DEFAULT']['BMI_file_size']):
            raise Exception("File size exceeds the limitation.")
        if args.input_file.endswith('bmi'):
            out_file = "{}bmh".format(args.input_file[0:-3])
            ml.convert_bmi_to_bmh(args.input_file, out_file)
        elif args.input_file.endswith('bai'):
            #TODO : prograss bai 
            bai_compiler = ap.AssemblyCompiler(CONFIG)
            bmi_file = "{}bmi".format(args.input_file[0:-3])
            bai_compiler.compile(args.input_file, bmi_file)
            bmh_file = "{}bmh".format(args.input_file[0:-3])
            ml.convert_bmi_to_bmh(bmi_file, bmh_file)
            pass
        else:
            raise Exception("file type error.")
    elif os.path.isdir(args.input_file):
        if os.path.isfile(args.output_file):
            raise Exception("the output arguments should be a directory.")
        elif os.path.isdir(args.output_file):
            for root, dirs, files in os.walk(args.output_file):
                #TODO : multi files.
                pass
        else:
            raise Exception("arguments parse Error.")
    else:
        raise Exception("arguments parse Error.")

if __name__ == "__main__":
    compile_file(ARGS)
    print("compile_bean_instruction.py")
