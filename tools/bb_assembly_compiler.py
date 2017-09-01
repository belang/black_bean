#! $PATH/python

# file name: compile_bean_instruction.py
# author: lianghy
# time: 2017-7-27 15:49:37

"""Bean instruction compiler.  """

import os
from os.path import join
import re
import argparse

import instruction_config as ic
import black_bean_common_func as bbc

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

CONFIG = {'BMI_file_size': 2**20}

def bean_write_file(fname, lines):
    """translate bean language to instruction in memory."""
    with open(config[fname], 'w') as fsource:
        fsource.writelines(lines)

def parse_bean_program(glabel_position, source_file, target_file):
    """parse user progamme"""
    ins_re = '|'.join('(?P<%s>%s)' % item for item in ic.assemble_pattern.items())
    machine_instruction_lines = []
    with open(source_file, 'r') as fsource:
        line_num = 0
        for oneline in fsource.readlines():
            hit_ins = re.fullmatch(ins_re, oneline.strip())
            if hit_ins is None:
                raise Exception('Unknow keys values: {}'.format(oneline))
            ins_type = hit_ins.lastgroup
            ins_value = hit_ins.group(ins_type)
            if ins_type == 'null':
                machine_instruction_lines.append('{}\n'.format(ic.machine_instruction['empty']))
            elif ins_type == 'comments':
                pass
            elif ins_type == 'label_ref':
                machine_instruction_lines.append(oneline)
                glabel_position[oneline.split(' ')[0]] = bb.hex_str(8, line_num)
            elif ins_type == 'quote_label':
                tlist = ins_value.split(' ')
                machine_instruction_lines.append('{}\n{}\n'.format(
                    ic.machine_instruction[tlist[0]], tlist[1]))
                line_num += 1
            elif ins_type == 'normal_ins':
                machine_instruction_lines.append('{}\n'.format(ic.machine_instruction[ins_value]))
            else:
                print(ins_type)
                raise Exception('Unknow keys values: {}'.format(oneline))
            line_num += 1
    bean_write_simu_file('compile_file', machine_instruction_lines)
            
def link_bean_program():
    """config address """
    line_num = 0
    link_addr = {}
    get_label_target_file = []
    with open(config["compile_file"], 'r') as fsource:
        for one_line in fsource:
            re_str = r'(?P<tar>^label_[a-z0-9_]+ [a-f0-9]+\n)'
            addr = re.fullmatch(re_str, one_line)
            if addr is None:
                new_str = one_line
            else:
                link_addr[addr.group('tar')] = line_num
                new_str = one_line.split(' ')[1]
            line_num += 1
            get_label_target_file.append(new_str)

        bean_write_label_target_file('addr_file', get_label_target_file)
        fsource.seek(0,0)
        # next
        for one_line in fsource:
            re_str = r'(?P<addr>^label_[a-z0-9_]+\n)'
            addr = re.fullmatch(re_str, one_line)
            if addr is None:
                new_str = one_line
            else:
                link_addr[addr.group('tar')] = line_num
                new_str = one_line.split(' ')[1]
            line_num += 1
            get_label_target_file.append(new_str)

def analyse_bmi_patter(contents):
    """analyse BMI command and data pattern, return a list."""
    for one_pattern in re.finditer(ic.BMI_TOKEN_EX, contents):
        lexical_type = one_pattern.lastgroup
        lexical_str  = one_pattern.group(lexical_type)
        if lexical_type == 'data':
            yield bbc.verilog_number_to_binary_string(lexical_str)
        elif lexical_type == 'command':
            print(lexical_str)
            yield "".join(ic.BMI_map[name] for name in lexical_str.split(' '))
            # next
        else:
            raise Exception("Unkown patter: {}".format(lexical_type))

def convert_bmi_to_memory_initial(in_file, out_file):
    """convert BMI to a binary string file for initial the memory when simulating the verilog."""
    with open(in_file, 'r') as fin:
        all_content = fin.read()
    with open(out_file, 'w') as fout:
        fout.writelines(["{}\n".format(x) for x in analyse_bmi_patter(all_content)])


def compile_file(args):
    """main compiling progress
    glabel_position     record the label position of the file."""
    glabel_position = {}
    if os.path.isfile(args.input_file):
        if args.input_file.endswith('bmi'):
            if args.output_file is None:
                convert_bmi_to_memory_initial(args.input_file, "{}bmb".format(args.input_file[0:-3]))
            elif os.path.isdir(args.output_file):
                convert_bmi_to_memory_initial(args.input_file, join("{}bmb".format(args.input_file[0:-3])))
            elif os.path.isfile(args.output_file):
                if args.output_file.endswith('bmb'):
                    convert_bmi_to_memory_initial(args.input_file, args.output_file)
                else:
                    convert_bmi_to_memory_initial(args.input_file, "{}.bmb".format(args.output_file))
            else:
                raise Exception("the output arguments should be a directory.")
        elif args.input_file.endswith('bai'):
            #TODO : prograss bai 
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
