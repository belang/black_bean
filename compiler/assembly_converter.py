#! $PATH/python

# file name: assembly_converter.py
# author: lianghy
# time: 2017-9-20 14:37:48

"""converter class"""

import os
from os.path import join
import re
import configconverter
import black_bean_common_func as bbc

ROOT = os.path.dirname(os.path.realpath(__file__))
# Bean Assembly Language
TARGET_REG_LIST = ['IR', 'PC', 'AR', 'DR0', 'DR1', 'CR']
SOURCE_REG_LIST = ['IR', 'PC', 'AR', 'DR0', 'DR1', 'CR', 'RE', 'AD']
VERIABLE_RE = r"[_0-9a-zA-Z]"
DATA_RE = r"8'h[0-9a-f][0-9a-f]"
ADDR_RE = r"8'h[0-9a-f][0-9a-f]"

class AssemblyConverter(object):
    """docstring for AssemblyConverter"""
    def __init__(self, config_file=None):
        super(AssemblyConverter, self).__init__()
        self.content = None
        config_converter = configconverter.ConfigConverter()
        if config_file is not None:
            self.config = config_converter.read(config_file)
        else:
            config_converter.read(join(ROOT, 'config.ini'))
            self.config = config_converter
        self.block_file = []
        self.new_file = []
        self.block = {}

    def generate_BMI(self, out_file):
        """main compile process"""
        # check block.
        for index, line in enumerate(self.block_file):
            if line.startswith("block"):
                self.new_file.append(self.block[line.rstrip().split(' ')[1]])
            else:
                self.new_file.append(self.block_file[index])
        with open(out_file, 'w') as fout:
            fout.writelines(self.new_file)

    def _check_veriable(self, name):
        """docstring for _check_veriable"""
        if re.fullmatch(VERIABLE_RE, name) is None:
            raise Exception("veriable name {} is illegal.".format(name))
    def _check_target_reg(self, reg):
        """docstring for _check_target_reg"""
        if reg not in TARGET_REG_LIST:
            raise Exception("register {} doesn't exist!".format(reg))
    def _check_data(self, data):
        """docstring for _check_data"""
        if re.fullmatch(DATA_RE, data) is None:
            raise Exception("data {} is illegal.".format(data))
    def _check_addr(self, addr):
        """docstring for _check_addr"""
        if re.fullmatch(ADDR_RE, addr) is None:
            raise Exception("addr {} is illegal.".format(addr))
    def _address(self, data):
        """get the address mode"""
        pass

    # AddressingMode
    def data(self, args):
        """immediate: convert to hexadecimal type"""
        if args.startswith(r"\d'h"):
            return "data", args
        else:
            return "data", bbc.int_to_verilog_hex(self.config["DEFAULT"]["data_width"], args)
    def reg(self, args):
        """check args in register list"""
        if args in TARGET_REG_LIST:
            return "reg", args
        else:
            raise Exception("Wrong register name: {}".format(args))
    def mem(self, args):
        """check args in register list"""
        if args in self.reglist:
            return args
        else:
            raise Exception("Wrong register name: {}".format(args))

    # Bean Assembly Instruction
    def set(self, reg, data):
        """set immediate data to register"""
        self._check_target_reg(reg)
        self._check_data(data)
        self.block_file.append("SKIN_INS_PC CORE_{}\n".format(reg))
        self.block_file.append("{}\n".format(data))
    def load(self, reg, addr):
        """load data to register from memory by address."""
        self._check_target_reg(reg)
        self._check_addr(addr)
        self.block_file.append("SKIN_INS_PC CORE_AR\n")
        self.block_file.append("{}\n".format(addr))
        self.block_file.append("SKIN_INS_AR CORE_{}\n".format(reg))
    def save(self, addr, reg):
        """save data to memory from register by address."""
        self._check_source_reg(reg)
        self._check_addr(addr)
        self.block_file.append("SKIN_INS_PC CORE_AR\n")
        self.block_file.append("{}\n".format(addr))
        self.block_file.append("CORE_{} SKIN_INS_AR\n".format(reg))



    def jump(self, label):
        """append new lines with number or block label"""
        self._check_veriable(label)
        if label in self.block.keys():
            self.block_file.append("SKIN_INS_PC CORE_PC\n")
            self.block_file.append("{}\n".format(self.block[label]))
        else:
            self.block_file.append("block {}\n".format(label))

    def branch(self, v1=None, v2=None, rel="=", label=None):
        """docstring for branch"""
        pass

    def add1(self):
        """append new lines"""
        self.block_file.append("CORE_DR0 CORE_DR0\n")

    def set_block(self, label):
        """set block line numbers."""
        self._check_veriable(label)
        if label in self.block.keys():
            raise Exception("Labe has been defined: {}".format(label))
        self.block[label] = bbc.int_to_verilog_hex(self.config["DEFAULT"]["data_width"], len(self.block_file))


if __name__ == "__main__":
    print("assembly_language.py")
