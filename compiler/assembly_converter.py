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

class Variable(object):
    """docstring for Variable"""
    def __init__(self, arg, data):
        super(Variable, self).__init__()
        self.arg, data = arg, data
        self.name = 'var'
        self.type = 'interge'
        self.value = "8'h00"
        self.target_address = 0
        self.grammar = GrammarParser()
        self.add(arg, data)
    def add(self, arg, data):
        """set varialbe"""
        try:
            self.grammar.check_var(arg)
            self.name = arg
        except Exception as exp:
            raise exp
        try:
            self.grammar.check_data(data)
            self.value = data
        except Exception as exp:
            raise exp

class Variable(object):
    """docstring for Variabl"""
    def __init__(self, arg):
        super(Variabl, self).__init__()
        self.arg = arg
        
    def add(self, arg, data):
        """add var to space"""
        pass

class VariableSpace(object):
    """docstring for Variable"""
    def __init__(self, arg, data):
        super(Variable, self).__init__()
        self.arg, data = arg, data
        self.gvar = GlobalVariable(self)
        self.lvar = LocalVariable(self)

class NameSpace():
    """docstring for NameSpace"""
    def __init__(self):
        super(NameSpace, self).__init__()
        self._top_name = "top"
        self.var = VariableSpace()
    @property
    def top_name(self):
        """top name of the function"""
        return self._top_name
    @top_name.setter
    def top_name(self, name):
        """docstring for top_name"""
        self._top_name = name

class MachineUnit(object):
    """docstring for MachineRegister"""
    def __init__(self):
        super(MachineRegister, self).__init__()
        self._ir  = "CORE_IR"
        self._pc  = "CORE_PC"
        self._ar  = "CORE_AR"
        self._dr0 = "CORE_DR0"
        self._dr1 = "CORE_DR1"
        self._cr  = "CORE_CR"
        self._re  = "ALU_RE"
        self._ad  = "ALU_AD"
        self._target_reg_list = [self._ir, self._pc, self._ar, self._dr0, self._dr1, self._cr]
        self._source_reg_list = [self._ir, self._pc, self._ar, self._dr0, self._dr1, self._cr, self._re, self._ad]

    @property
    def ir(self):
        return self._ir
    @property
    def pc(self):
        return self._pc
    @property
    def ar(self):
        return self._ar
    @property
    def dr0(self):
        return self._dr0
    @property
    def dr1(self):
        return self._dr1
    @property
    def cr(self):
        return self._cr
    @property
    def re(self):
        return self._re
    @property
    def ad(self):
        return self._ad
    def is_target_unit(self, name):
        return name in self._target_reg_list
    def is_source_unit(self, name):
        return name in self._source_reg_list

class GrammarParser(MachineUnit):
    """docstring for GrammarParser"""
    def __init__(self):
        super(GrammarParser, self).__init__()
        self._variable_re = r"[_0-9a-zA-Z]"
        self._data_re = r"8'h[0-9a-f][0-9a-f]"
        self._addr_re = r"8'h[0-9a-f][0-9a-f]"
    def is_var(self, var):
        """docstring for is_var"""
        if re.fullmatch(self._variable_re, var) is None:
            return False
        else:
            return True
    def is_data(self, var):
        """docstring for is_var"""
        if re.fullmatch(self._data_re, var) is None:
            return False
        else:
            return True
    def check_var(self, var):
        """return exception or None"""
        if not self.is_var(var):
            raise Exception("Wrong unit name {}".format(var))
    def check_data(self, var):
        """return exception or None"""
        if not self.is_data(var):
            raise Exception("Wrong data type {}".format(var))

class Function():
    """docstring for Function"""
    def __init__(self, name):
        super(Function, self).__init__()
        self.namespace = NameSpace()
        self.namespace.top_name = name
        self.grammar = GrammarParser(self)
        # statement
        self.let = self._set_variable
    def _set_variable(self, var, data):
        """generate a new variable and save the value"""
        self.namespace.var.local.add(var, data)
    def generate_simu_file(self):
        # get page address
        self._func.append(self.move(self.program, self))
        self._func.append(self._data)

class Statement(object):
    """docstring for Statement"""
    def __init__(self, function):
        super(Statement, self).__init__()
        self._func = function

class AssemblyInstruction(object):
    """Bean Assembly Language"""
    def __init__(self):
        super(AssemblyInstruction, self).__init__()
        self.reg = MachineRegister()
        self.target_reg_list = [self.reg.ir, self.reg.pc, self.reg.ar, self.reg.dr0, self.reg.dr1, self.reg.cr]
        self.source_reg_list = [self.reg.ir, self.reg.pc, self.reg.ar, self.reg.dr0, self.reg.dr1, self.reg.cr, self.reg.re, self.reg.ad]
        self.variable_re = r"[_0-9a-zA-Z]"
        self.data_re = r"8'h[0-9a-f][0-9a-f]"
        self.addr_re = r"8'h[0-9a-f][0-9a-f]"

    def is_variable(self, name):
        """docstring for check_variable"""
        if re.fullmatch(self.variable_re, name) is None:
            return False
        else:
            return True
    def check_target_reg_exist(self, reg):
        """docstring for check_target_reg"""
        if reg not in self.target_reg_list:
            raise Exception("register {} doesn't exist!".format(reg))
    def check_source_reg_exist(self, reg):
        """docstring for check_source_reg"""
        if reg not in self.source_reg_list:
            raise Exception("register {} doesn't exist!".format(reg))
    def is_data(self, data):
        """docstring for check_data"""
        if re.fullmatch(self.data_re, data) is None:
            return False
        else:
            return True
    def check_addr_syntax(self, addr):
        """docstring for check_addr"""
        if re.fullmatch(self.addr_re, addr) is None:
            return False
        else:
            return True
    def address(self, data):
        """get the address mode"""
        pass


class AssemblyConverter(AssemblyInstruction):
    """docstring for AssemblyConverter
        _block_file: """
    def __init__(self, config_file=None):
        super(AssemblyConverter, self).__init__()
        self.content = None
        config_converter = configconverter.ConfigConverter()
        if config_file is not None:
            self.config = config_converter.read(config_file)
        else:
            config_converter.read(join(ROOT, 'config.ini'))
            self.config = config_converter
        self._block_file = []
        self.new_file = []
        self._block_label = 0
        self._stack_start_line = []
        self.__block_end_label = "END_BLOCK"
        self.variable_namespace = {}

        self.block_space = {}

    def generate_BMI(self, out_file):
        """main compile process"""
        # check block_space.
        for index, line in enumerate(self._block_file):
            if line.startswith("block_space"):
                self.new_file.append(self.block_space[line.rstrip().split(' ')[1]])
            else:
                self.new_file.append(self._block_file[index])
        with open(out_file, 'w') as fout:
            fout.writelines(self.new_file)

    def _gen_block_label(self):
        """auto generate numberal label for label lines."""
        self._block_label = self._block_label+1
    def _get_current_line(self):
        """return current line number"""
        return len(self.new_file)
        
    # machine instruction
    def _load(self, v1, v2):
        """load variable, immediate data or registers to a regitster"""
        if self.is_variable(v1):
            self._block_file.append("SKIN_INS_PC CORE_AR\n")
            self._block_file.append("{}".format(self.variable_namespace[v1]))
            self._block_file.append("SKIN_INS_AR {}\n".format(v1))
        elif self.is_reg(v1):
            if v1 is not v2:
                self._block_file.append("{} {}\n".format(v1, v1))
        elif self.is_data(v1):
            self._block_file.append("SKIN_INS_PC CORE_AR\n")
            self._block_file.append("{}".format(v1))
        else:
            raise Exception("Unkown data type {}".format(v1))
    def _branch(self, v1=None, v2=None, rel=None):
        """branch instruction"""
        self._load(v1, self.reg.dr0)
        self._load(v2, self.reg.dr1)
        self._load(rel, self.reg.cr)
        self._load(self.__block_end_label, self.reg.ar)
        self._block_file.append("CORE_CR CORE_PC\n")

    # AddressingMode
    def data(self, args):
        """immediate: convert to hexadecimal type"""
        if args.startswith(r"\d'h"):
            return "data", args
        else:
            return "data", bbc.int_to_verilog_hex(self.config["DEFAULT"]["data_width"], args)
    def reg(self, args):
        """check args in register list"""
        if args in self.target_reg_list:
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
        self.check_target_reg_exist(reg)
        self.is_data(data)
        self._block_file.append("SKIN_INS_PC {}\n".format(reg))
        self._block_file.append("{}\n".format(data))
    def load(self, reg, addr):
        """load data to register from memory by address."""
        self.check_target_reg_exist(reg)
        self.check_addr_syntax(addr)
        self._block_file.append("SKIN_INS_PC CORE_AR\n")
        self._block_file.append("{}\n".format(addr))
        self._block_file.append("SKIN_INS_AR {}\n".format(reg))
    def save(self, addr, reg):
        """save data to memory from register by address."""
        self.check_source_reg_exist(reg)
        self.check_addr_syntax(addr)
        self._block_file.append("SKIN_INS_PC CORE_AR\n")
        self._block_file.append("{}\n".format(addr))
        self._block_file.append("{} SKIN_INS_AR\n".format(reg))
    def when(self, v1, v2, rel):
        """iocstring for while """
        self._stack_start_line.append(self._get_current_line())
        self._branch(v1, v2, rel)
    def endwhen(self):
        """docstring for endwhen"""
        self._stack_end_line.append(self._get_current_line()+self.block_size)
        #TODO make block as a object, Bean assembly language an object,
        #     program an object ...
        

    def tsetv(self, varialbe, data):
        """set immediate data to a variable"""
        ###### TODO
        self.check_target_reg_exist(varialbe)
        self.is_data(data)
        self._block_file.append("SKIN_INS_PC CORE_{}\n".format(varialbe))
        self._block_file.append("{}\n".format(data))


    def jump(self, label):
        """append new lines with number or block_space label"""
        self.is_variable(label)
        if label in self.block_space.keys():
            self._block_file.append("SKIN_INS_PC CORE_PC\n")
            self._block_file.append("{}\n".format(self.block_space[label]))
        else:
            self._block_file.append("block_space {}\n".format(label))

    def branch(self, v1=None, v2=None, rel="=", label=None):
        """docstring for branch"""
        pass

    def add1(self):
        """append new lines"""
        self._block_file.append("CORE_DR0 CORE_DR0\n")

    def set_block(self, label=None):
        """set block_space line numbers."""
        if label is not None:
            self.is_variable(label)
            if label in self.block_space.keys():
                raise Exception("Labe has been defined: {}".format(label))
        else:
            self._block_label_number = self._block_label_number + 1
        self.block_space[label] = bbc.int_to_verilog_hex(self.config["DEFAULT"]["data_width"], len(self._block_file))


if __name__ == "__main__":
    print("assembly_language.py")
