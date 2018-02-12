#! $PATH/python

# file name: machine_instruction_parser.py
# author: lianghy
# time: 2017-9-20 14:36:57

"""Bean assebmler. Convert Assembly to machine code for simulation."""

import re,os

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
        'command'       : r"([A-Z][A-Z0-9]*)"
        }

BAS_map = {
    'NULL'      : '0',
    'ROM'     : '1',
    'RAM'     : '2',
    'PC'     : '3',
    'AR'     : '4',
    'CR'     : '5',
    'RE'     : '6',
    'AD'     : '7',
    'PA'     : '8',
    'PD'     : '9',
    'DR0'     : 'a',
    'DR1'     : 'b',
    'DR2'     : 'c',
    'DR3'     : 'd',
    'AP'       : 'e',
    'NONE'      : 'f'
}

BAS_TOKEN_EX = '|'.join('(?P<%s>%s)' % item for item in BAS_pattern.items())

def analyse_bai_patter(contents):
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

def convert_bai_to_bmh(in_file, out_file, config):
    """convert BAS to a binary string file for initial the memory when simulating the verilog."""
    print("start assembler! source file is {}, and target file is {}".format(in_file, out_file))
    if os.stat(in_file).st_size > int(config['DEFAULT']['BAS_file_size']):
        raise Exception("File size exceeds the limitation.")
    with open(in_file, 'r') as fin:
        all_content = fin.read()
    with open(out_file, 'w') as fout:
        #fout.writelines(["{}\n".format(x) for x in analyse_bmi_patter(all_content)])
        fout.writelines([x for x in analyse_bai_patter(all_content)])


if __name__ == "__main__":
    print("machine_instruction_parser.py")
