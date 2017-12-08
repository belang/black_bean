#! $PATH/python

# file name: bean_assembly_code_package.py
# author: lianghy
# time: 2017/11/23 10:13:15

"""The source and target data type may be string, token, or NSVar.
String: memory address or assembly code
token:  immediate data
NSVar:  variable saved in namespace"""

import common_func as cf

NULL = "REG_NULL"
IR   = "REG_IR"
PC   = "REG_PC"
AR   = "REG_AR"
DR0  = "REG_DR0"
DR1  = "REG_DR1"
CR   = "REG_CR"
BR   = "REG_BR"
RE   = "ALU_RE"
AD   = "ALU_AD"
MPC  = "MEM_PC"
MAR  = "MEM_AR"
OTH  = "MEM_OTH"

def ir(source, target):
    return "{} {}".format(source, target)

class LoadData(object):
    """load data from mem[addr] to target"""
    def __init__(self, target, addr):
        super(LoadData, self).__init__()
        self.addr = addr
        self.target = target
        self.code_lines = 3
    def gen_simu_code(self):
        return [ir(MPC, AR), "\n",
                cf.hex_str(self.addr.physical_addr), "\n",
                ir(MAR, self.target), "\n"]

class LoadCR(object):
    """load cr code from mem"""
    def __init__(self, addr):
        super(LoadCR, self).__init__()
        self.addr = addr
        self.code_lines = 3
    def gen_simu_code(self):
        return [ir(MPC, AR), "\n",
                cf.hex_str(self.addr.physical_addr), "\n",
                ir(MAR, CR), "\n"]

class SetCR(object):
    """set cr by immediate data"""
    def __init__(self, op_code):
        super(SetCR, self).__init__()
        self.data = op_code
        self.code_lines = 2
    def gen_simu_code(self):
        return [ir(MPC, CR), "\n",
                cf.int_str_to_hex_str(self.data), "\n"]

class SetAR(object):
    """set ar by immediate data"""
    def __init__(self, addr):
        super(SetAR, self).__init__()
        self.addr = addr
        self.code_lines = 2
    def gen_simu_code(self):
        return [ir(MPC, AR), "\n",
                self.addr.physical_addr, "\n"]

class SetData(object):
    """set immediate data"""
    def __init__(self, data, target):
        super(SetData, self).__init__()
        self.data = data
        self.target = target
        self.code_lines = 2
    def gen_simu_code(self):
        return [ir(MPC, self.target), "\n",
                cf.int_str_to_hex_str(self.data), "\n"]

class SaveData(object):
    """save register to memory by the addr"""
    def __init__(self, source, addr):
        super(SaveData, self).__init__()
        self.source = source
        self.addr = addr
        self.code_lines = 2
    def gen_simu_code(self):
        return [ir(MPC, AR), "\n",
                cf.hex_str(self.addr.physical_addr), "\n",
                ir(self.source, MAR), "\n"]

class SaveRE(object):
    """save arithmetic logic unit result to memory by the addr"""
    def __init__(self, addr):
        super(SaveRE, self).__init__()
        self.addr = addr
        self.code_lines = 2
    def gen_simu_code(self):
        return [ir(MPC, AR), "\n",
                cf.hex_str(self.addr.physical_addr), "\n",
                ir(RE, MAR), "\n"]

if __name__ == "__main__":
    print("bean_assembly_code_package.py")
