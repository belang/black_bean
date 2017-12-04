#! $PATH/python

# file name: lexer_token_view.py
# author: lianghy
# time: 2017/11/13 10:51:57

"""build statement structure from token list"""

import bean_assembly_code_package as bap

__statement_key_list = ["if", "while"]

class NSVar(object):
    """docstring for NAVar"""
    def __init__(self, name, addr=None):
        super(NSVar, self).__init__()
        self.name = name
        self.data_addr = addr
        #self.mem = mem
        #self.data_addr = mem.allocate_var_space()

class NSTempVar():
    """docstring for NSTempVar"""
    def __init__(self, mem):
        self.data_addr = None
        #self.data_addr = mem.allocate_temp_var_space()

class NameSpace():
    """docstring for NameSpace"""
    def __init__(self, ns, mem):
        self.parrent = ns
        self.mem = mem
        self.var_list = []
        self.temp_var_list = []
    def has_variable(self, name):
        """check if there is a variable in the space. If not create it."""
        for one_var in self.var_list:
            if one_var.name == name:
                return True
        return False
    def new_var(self, name, addr=None):
        """docstring for new_var"""
        if not self.get_var(name):
            self.var_list.append(NSVar(name, addr))
            return True
        else:
            return False
    def new_temp_var(self):
        """create a temp variable, and return the temp name(the position)."""
        self.temp_var_list.append(NSTempVar(self.mem))
        return len(self.temp_var_list)
    def get_var(self, name):
        """search the NSVar, and return it."""
        for var in self.var_list:
            if var.name == name:
                return var
        return False
    def assign_var_from_var(self, target, source):
        """set a variable data with another variable."""
        for var in self.var_list:
            if var.name == target:
                var.data_addr = self._get_var_data_addr(source)
                break
    def _get_var_data_addr(self, name):
        """get a variable target memory address."""
        for var in self.var_list:
            if var.name == name:
                return var.data_addr
    def link_var(self, var, addr):
        """docstring for link_var"""
        var = self.get_var(var)
        var.data_addr = addr
        var.ref_count += 1


class MemDataPage(object):
    """docstring for MemDataPage"""
    def __init__(self):
        super(MemDataPage, self).__init__()
        self.start_line_addr = 0
        self.element = []

class MemElement(object):
    """docstring for MemElement"""
    def __init__(self, size):
        super(MemElement, self).__init__()
        self.size = size
        self.start_bit_addr = 0
        self.ref_count = 0
        self.physical_addr = 0

class Memory(object):
    """docstring for Memory:
        data_page: a list, False means no value."""
    def __init__(self, total_size=256):
        self.total_size = total_size
        self.code_page = []
        self.data_page = MemDataPage()
    def allocate_var_space(self):
        """docstring for allocate_var_space"""
        self.data_page.element.append(False)
        return len(self.data_page)
    def allocate_virtual_space_for_data(self):
        """docstring for mem.allocate_virtual_space_for_data"""
        ele = MemElement(1)
        self.data_page.element.append(ele)
        return ele
    def allocate_mem_to_code(self, size):
        """nnnnn"""
        lines = size//8+1
        self.data_page.start_line_addr = lines*8


class AssemblyStmt():
    """token_view: point to the token object"""
    def __init__(self, ns, mem, token_view):
        self.token_view = token_view
        self.ns = ns
        self.mem = mem
        self._type = "Stmt"
        self.__block_keys = ("if", "while")
        self.assm_obj_code_list = []
        self.stmt_list = []
    def gen_assm_code(self):
        raise Exception("gen_assm_code must be rewritten.")
    def _generate_assembly_view(self):
        """generate assembly view"""
        raise Exception("generate_assembly_view must be rewritten.")
    def _analyse_structure(self):
        """build statement structure"""
        pass
    def get_code_lines(self):
        """docstring for get_code_lines"""
        raise Exception("Formular must be rewritten.")


class AssemblyVariable():
    """build from token"""
    def __init__(self, token):
        self._type = token.ttype
        self._value = token.tvalue

    @property
    def ttype(self):
        """get type"""
        return self._type
    @property
    def tvalue(self):
        """get value"""
        return self._value


class AssemblyStmtAssgAtomData():
    """y = 10"""
    def __init__(self, ns, mem, target, data):
        self.target = target
        self.data = data
        self.ns = ns
        self.mem = mem
        self.code_list = []
    def allocate_virtual_space(self):
        """docstring for gen_assm_code"""
        self.ns.new_var(self.target)
        #addr = self.ns.apply_mem("one byte")
        ele = self.mem.allocate_virtual_space_for_data(self.data)
        self.ns.link_var(self.target, ele)
    def gen_assm_code(self):
        """docstring for gen_assm_code"""
        self.code_list.append(bap.SetData(self.data, bap.DR0))
        self.code_list.append(bap.SaveData(bap.DR0, self.ns.get_var_ele(self.target)))
    def get_code_lines(self):
        code_lines = 0
        for code in self.code_list:
            code_lines += code.code_lines
        return code_lines


class AssemblyStmtAssgAtomVariable():
    """y = x"""
    def __init__(self, ns, target, source):
        self.target = target
        self.source = source
        self.ns = ns
        self.code_list = []
    def allocate_virtual_space(self):
        """docstring for gen_assm_code"""
        self.ns.new_var(self.target)
        self.ns.assign_var_from_var(self.target, self.source)
    def gen_assm_code(self):
        """docstring for gen_assm_code"""
        pass
    def get_code_lines(self):
        code_lines = 0
        for code in self.code_list:
            code_lines += code.code_lines
        return code_lines


class AssemblyStmtAssgAtomArithmetic():
    """y = a+b or y = 10+11
    atom: the type of atom is TokenExprAtom"""
    def __init__(self, ns, mem, target, atom):
        self.target = target
        self.op = atom.op
        self.od0 = atom.od0
        self.od1 = atom.od1
        self.ns = ns
        self.mem = mem
        self.code_list = []
        self.__op_code = {"+":"01",
                          "-":"02",
                          "*":"03",
                          "/":"04"}
    def allocate_virtual_space(self):
        """docstring for gen_assm_code"""
        self.ns.new_var(self.target)
        addr = self.mem.allocate_virtual_space_for_data()
        self.ns.link_var(self.target, addr)
    def _get_op_code(self):
        """docstring for _get_op_code"""
        return self.__op_code[self.op.tvalue]
    def gen_assm_code(self):
        """docstring for gen_assm_code"""
        if self.od0.ttype is "data":
            self.code_list.append(bap.SetData(self.od0, bap.DR0))
        else:
            self.code_list.append(bap.LoadData(bap.DR0, self.ns.get_var_ele(self.od0)))
        if self.od1.ttype is "data":
            self.code_list.append(bap.SetData(self.od1, bap.DR1))
        else:
            self.code_list.append(bap.LoadData(bap.DR1, self.ns.get_var_ele(self.od1)))
        self.code_list.append(bap.SetCR(self._get_op_code()))
        self.code_list.append(bap.SaveRE(self.ns.get_var_ele(self.target)))
    def get_code_lines(self):
        code_lines = 0
        for code in self.code_list:
            code_lines += code.code_lines
        return code_lines


class AssemblyStmtAssg(AssemblyStmt):
    """docstring for StmtAssg"""
    def __init__(self, token_view, ns, mem):
        super(AssemblyStmtAssg, self).__init__(token_view, ns, mem)
        self._type = "assignment"
        self.atom_list = []
        self._generate_assembly_view()
        self.allocate_virtual_space()
        self.gen_assm_code()
    def _generate_assembly_view(self):
        """link the variable of different exprssion."""
        atom_list = self.token_view.expr.atom_list
        if len(atom_list) == 1:
            atom = atom_list[0]
            if atom.op is None:
                if atom.od0.ttype is "data":
                    self.atom_list.append(AssemblyStmtAssgAtomData(self.ns, self.mem, self.token_view.target, atom.od0))
                elif atom.od0.ttype is "variable":
                    self.atom_list.append(AssemblyStmtAssgAtomVariable(self.ns, self.token_view.target, atom.od0))
                else:
                    raise Exception("Wrong token type: {}".format(atom.od0.ttype))
            else:
                self.atom_list.append(AssemblyStmtAssgAtomArithmetic(self.ns, self.mem, self.token_view.target, atom))
        else:
            for atom in atom_list:
                self.atom_list.append(AssemblyStmtAssgAtomArithmetic(self.ns, self.mem, atom.atom_id, atom))
            self.atom_list[-1].target = self.token_view.target
    def allocate_virtual_space(self):
        """in name space, add new var; in memory, allocate space for data; link the variable and the data."""
        for atom in self.atom_list:
            atom.allocate_virtual_space()
    def gen_assm_code(self):
        """docstring for gen_assm_code"""
        for atom in self.atom_list:
            atom.gen_assm_code()
    def get_code_lines(self):
        """docstring for get_code_lines"""
        code_lines = 0
        for atom in self.atom_list:
            code_lines += atom.code_lines
        return code_lines
    #next TODO: caculate the max needed space by the temp variables, and release these temp variables space. VAR( Max_Var_Count )


class AssemblyStmtWhile(AssemblyStmt):
    """docstring for StmtWhile"""
    def __init__(self, ns, mem, token_view):
        super(AssemblyStmtWhile, self).__init__(ns, mem, token_view)
        self._type = "while"
        self.condition = None
        self.block = []
        self._state = "condition"
        self._condition_tk = []
        self._block_tk = []
        self._sub_block = 0


class AssemblyLexer():
    """docstring for BeanLexer.
    _cache_token: cache some token before relize a statement type.
    _stmt_state: state machine for getting stmt type.
    """
    def __init__(self, token_view):
        ### language fetures
        self.token_view = token_view
        self.assembly_code = []
        self.assembly_view = []
        self.__bean_language_key_list = ["if", "else", "while", "break", "exit", "end"]
        self.mem = Memory()
        self.ns = NameSpace(None, self.mem)
        self.code_lines = 0
    def run(self):
        self.generate_assembly_view()
        self.allocate_virtual_space()
        self.gen_assm_code()
        self.allocate_mem_to_code()
        self.allocate_mem_to_run()
    def generate_assembly_view(self):
        """docstring for _create_assemb_view"""
        for stmt in self.token_view.stmt_list:
            if stmt.ttype == "assignment":
                self.assembly_view.append(AssemblyStmtAssg(self.ns, self.mem, stmt))
            elif stmt.ttype == "while":
                self.assembly_view.append(AssemblyStmtWhile(self.ns, self.mem, stmt))
            else:
                pass
    def allocate_virtual_space(self):
        """in name space, add new var; in memory, allocate space for data; link the variable and the data."""
        for stmt in self.assembly_view:
            stmt.allocate_virtual_space()
    def allocate_mem_to_code(self):
        """docstring for allocate_mem_to_code"""
        for stmt in self.assembly_view:
            self.code_lines += stmt.get_code_lines()
        if self.code_lines > 256:
            raise Exception("momory is not enough. code size is {}".format(self.code_lines))
        self.mem.allocate_mem_to_code(code_lines)
    def allocate_mem_to_run(self):
        """docstring for allocate_mem_to_code"""
        pass
    def gen_assm_code(self):
        """docstring for gen_assm_code"""
        for stmt in self.assembly_view:
            stmt.gen_assm_code()



if __name__ == "__main__":
    print("lexer.py")
