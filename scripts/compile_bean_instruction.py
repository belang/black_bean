#! $PATH/python

# file name: compile_bean_instruction.py
# author: lianghy
# time: 2017-7-27 15:49:37

"""Bean instruction compiler.

Funtion:
    1. change the address according the final line number.

"""

from os.path import join

config = {
        source_file:"read_data.b",
        target_file:"read_data.hex",
        instruction_define_file:"E:\\110_project\\black_bean\\rtl\\define.v",
        source_language_type:"chinese",
        data_format:"hexadecimal",
        default:"None"
        }

INSTRUCTION_MAP = {}

def bean_write_simu_file():
    """write to a file """
    with open(config["instruction_define_file"], 'a') as fsource:
        fsource.writelines(TARGET_LINES)
        INSTRUCTION_MAP.clear()

def translate_instruction(bean_in):
    """translate bean language to instruction in memory. If the lines is large
    than 1024*1024, append them to target_file."""
    TARGET_LINES.append("{}\n".format(INSTRUCTION_MAP[bean_in]))
    if len(TARGET_LINES) == 1048576:
        bean_write_simu_file()

def parse_instruction():
    """get the corresponding instruction and value."""
    with open(config["instruction_define_file"], 'r') as fsource:
        oneline = fsource.readline()
        while len(oneline) > 0:
            if oneline.startwith('// CONTROLLER'):
                break
            oneline = fsource.readline()
        oneline = fsource.readline()
        while len(oneline) > 0:
            command_line_pattern = re.compile("`define ([A-Z_0-9)+\s+(\d+)'h([0-9a-fA-F]+)")
            one_command = command_line_pattern.fullmath(one_command)
            if one_command is not None:
                ## current only in hexadecimal format
                ti_name = one_command.groups()[0]
                #ti_width = one_command.groups()[1]
                ti_value = one_command.groups()[2]
                #ti_oct = int("0x{}".format(ti_value), 16)
                #ti_bin = bin(ti_oct)
                #instruction_map[ti_name] = ti_bin[2:].rjust(int(ti_width), '0')
                INSTRUCTION_MAP[ti_name] = ti_value
            elif oneline.startwith('// END CONTROLLER'):
                break
            oneline = fsource.readline()

def parse_bean_progam():
    """parse user progamme"""
    keys = INSTRUCTION_MAP.keys()
    with open(config["source_file"], 'r') as fsource:
        for oneline in fsource.readlines():
            if oneline.startwith("#"):
                continue
            if re.fullmatch('\s*',oneline):
                continue
            keys_search = re.fullmatch('(\S+) *(0x)?\s*', oneline)
            if keys_search is not None:
                if keys.groups()[0] in keys:
                    translate_instruction(keys.groups()[0])
                elif keys.groups()[1] is not None:
                    translate_instruction(keys.groups()[1][2:])
                else:
                    raise Exception('Unknow keys values: {}'.format(oneline))

def main():
    """main"""
    if os.path.isfile(config["instruction_define_file"]):
        with open(config["instruction_define_file"], 'w') as fsource:
            fsource.writelines(TARGET_LINES)
            INSTRUCTION_MAP.clear()
    parse_instruction()
    parse_bean_progam()
    if len(INSTRUCTION_MAP) > 0 :
        bean_write_simu_file()

if __name__ == "__main__":
    print("compile_bean_instruction.py")
