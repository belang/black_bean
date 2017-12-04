#! $PATH/python

# file name: bean_assembly_code_package.py
# author: lianghy
# time: 2017/11/23 10:13:15

"""The source and target data type may be string, token, or NSVar.
String: memory address or assembly code
token:  immediate data
NSVar:  variable saved in namespace"""

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

class AssemblyCommand(object):
    """docstring for AssemblyCommand"""
    def __init__(self, source, target):
        self.source = source
        self.target = target

class LoadData(object):
    """load data from mem"""
    def __init__(self, target, addr):
        super(LoadData, self).__init__()
        self.addr = addr
        self.target = target
        self.code_lines = 2

class LoadOP(object):
    """load data from mem"""
    def __init__(self, op, addr):
        super(LoadOP, self).__init__()
        self.op = op
        self.addr = addr
        self.code_lines = 2

class SetCR(object):
    """set cr by immediate data"""
    def __init__(self, op_code):
        super(SetCR, self).__init__()
        self.data = op_code
        self.code_lines = 2

class SetAR(object):
    """set ar by immediate data"""
    def __init__(self, addr):
        super(SetAR, self).__init__()
        self.data = addr
        self.code_lines = 2

class SetData(object):
    """set immediate data"""
    def __init__(self, data, target):
        super(SetData, self).__init__()
        self.data = data
        self.target = target
        self.code_lines = 2

class SaveData(object):
    """save register to memory by the addr"""
    def __init__(self, source, addr):
        super(SaveData, self).__init__()
        self.source = source
        self.addr = addr
        self.code_lines = 2

class SaveRE(object):
    """save arithmetic logic unit result to memory by the addr"""
    def __init__(self, addr):
        super(SaveRE, self).__init__()
        self.target = addr
        self.code_lines = 2

if __name__ == "__main__":
    print("bean_assembly_code_package.py")
