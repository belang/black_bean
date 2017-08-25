#! $PATH/python

# file name: compile_bean_instruction.py
# author: lianghy
# time: 2017-7-27 15:49:37

"""Bean instruction compiler.  """

import os
from os.path import join
import re

import instruction_config as ic
import black_bean_common_func as bb

config = {
        'source_file':"read_data.b",
        'compile_file':"read_data.hex",
        'addr_file':"read_data.adr",
        'run_file':"read_data.sim",
        'source_language_type':"english",
        'data_format':"hexadecimal",
        'default':"None"
        }


def bean_write_file(fname, lines):
    """translate bean language to instruction in memory."""
    with open(config[fname], 'w') as fsource:
        fsource.writelines(lines)

def parse_bean_program(glabel_position):
    """parse user progamme"""
    ins_re = '|'.join('(?P<%s>%s)' % item for item in ic.assemble_pattern.items())
    machine_instruction_lines = []
    with open(config["source_file"], 'r') as fsource:
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

def main():
    """main
    glabel_position : record the label position of the file."""
    if os.path.isfile(config["target_file"]):
        with open(config["target_file"], 'w') as fsource:
            pass
    glabel_position = {}
    parse_bean_program(glabel_position)
    link_bean_program(glabel_position)

if __name__ == "__main__":
    main()
    print("compile_bean_instruction.py")
