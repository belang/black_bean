#! $PATH/python

# file name: lexer_assembly_view.py
# author: lianghy
# time: 2017/11/13 10:51:57

"""build statement structure from token list"""

import bean_assembly_code_package as bap

class NSVar(object):
    """docstring for NAVar"""
    def __init__(self, name):
        super(NSVar, self).__init__()
        self.name = name
        self.data = None
        self.size = 1
        self.ref_count = 0
        self.domain = "private"
        #self.mem = mem

class NameSpace():
    """docstring for NameSpace"""
    def __init__(self, ns):
        self.parrent_ns = ns
        self.sub_ns = []
        self.var_list = []
        self.temp_var_list = []
        if self.parrent_ns is not None:
            self.parrent_ns.sub_ns.append(self)
    def has_var(self, name):
        """check if there is a variable in the space. If not create it."""
        for one_var in self.var_list:
            if one_var.name == name:
                return True
        return False
    def new_var(self, name):
        """docstring for new_var"""
        nvar = NSVar(name)
        self.var_list.append(nvar)
        return nvar
    def get_var(self, name):
        """search the NSVar, and return it."""
        for var in self.var_list:
            if var.name == name:
                return var
        return None
    def assign_var_from_var(self, target, source):
        """set a variable data with another variable."""
        for var in self.var_list:
            if var.name == target:
                svar = self.get_var(source)
                var.data = svar.data
                svar.ele.ref_count += 1
                break
    def link_var(self, name, ele):
        """docstring for link_var"""
        var = self.get_var(name)
        ele.ref_count += 1
        var.data = ele
    def get_var_count(self):
        """get all variable count."""
        return len(self.var_list)
    def get_var_size(self):
        """get all variable count."""
        return sum([var.size for var in self.var_list])
    def get_var_ele(self, name):
        """docstring for get_var_e"""
        for var in self.var_list:
            if var.name == name:
                return var.data


class MemDataPage(object):
    """docstring for MemDataPage"""
    def __init__(self):
        super(MemDataPage, self).__init__()
        self.first_line = 0
        self.element = []
        self.static_page_current_bit = 0
        self.dynamic_page_current_bit = 0
        self.dynamic_page_line = 0

class MemDataEle(object):
    """docstring for MemDataEle"""
    def __init__(self, token):
        super(MemDataEle, self).__init__()
        self.token = token
        self.ref_count = 0
        # TODO: sub type for int, float ...
        self.variable_type = token.ttype
        self.size = 1
        self.physical_addr = 0

class Memory(object):
    """docstring for Memory:
        data_page: a list, False means no value."""
    def __init__(self, total_size=256):
        self.total_size = total_size
        self.code_page = []
        self.data_page = MemDataPage()
    def allocate_mem_page(self, code_size, static_var_size):
        """caculate the start line of data page."""
        lines = code_size//8+1
        self.data_page.first_line = lines*8
        static_lines = static_var_size//8+1
        self.data_page.dynamic_page_line = static_lines+lines
        if self.data_page.dynamic_page_line > self.total_size:
            raise Exception("momory is not enough. code size is {}, variable size is {}".format(lines, static_lines))
        self.data_page.static_page_current_bit = 8*self.data_page.first_line
        self.data_page.dynamic_page_current_bit = 8*self.data_page.dynamic_page_line
    def new_data_ele(self, token):
        """new data"""
        ele = MemDataEle(token)
        self.data_page.element.append(ele)
        return ele
    def assign_phy_addr_to_static_data(self, data):
        """data ele"""
        data.physical_addr = self.data_page.static_page_current_bit
        self.data_page.static_page_current_bit += data.size
    def assign_phy_addr_to_dynamic_data(self, data):
        """data ele"""
        data.physical_addr = self.data_page.dynamic_page_current_bit
        self.data_page.dynamic_page_current_bit += data.size
    def reset_dynamic_page(self):
        """docstring for reset_dynamic_page"""
        self.data_page.dynamic_page_current_bit = 8*self.data_page.dynamic_page_line


class AssemblyStmt():
    """token_view: point to the token object"""
    def __init__(self, token_view, mem):
        self.token_view = token_view
        self.mem = mem
        self._type = "Stmt"
        self.__block_keys = ("if", "while")
        self.code_list = []
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
    def set_physical_addr(self):
        """docstring for set_physical_addr"""
        pass


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
        if not self.ns.has_var(self.target):
            self.ns.new_var(self.target)
            ele = self.mem.new_data_ele(self.data)
            self.ns.link_var(self.target, ele)
    def gen_assm_code(self):
        """docstring for gen_assm_code"""
        self.code_list.append(bap.SetData(self.data.tvalue, bap.DR0))
        self.code_list.append(bap.SaveData(bap.DR0, self.ns.get_var_ele(self.target)))
    def gen_simu_code(self):
        codes = []
        for code in self.code_list:
            codes += code.gen_simu_code()
        return codes


class AssemblyStmtAssgAtomVariable():
    """y = x"""
    def __init__(self, ns, target, source):
        self.target = target
        self.source = source
        self.ns = ns
        self.code_list = []
    def allocate_virtual_space(self):
        """docstring for gen_assm_code"""
        if not self.ns.has_var(self.target):
            self.ns.new_var(self.target)
            self.ns.assign_var_from_var(self.target, self.source)
    def gen_simu_code(self):
        codes = []
        for code in self.code_list:
            codes += code.gen_simu_code()
        return codes


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
        """The target data type is the same as the od0.
        If od0 is an atom, get type from the atom id in local NS."""
        if not self.ns.has_var(self.target):
            self.ns.new_var(self.target)
            data_type_token = self.od0
            import lexer_token_view
            if isinstance(data_type_token, lexer_token_view.TokenExprAtom):
                data_type_token = self.ns.get_var(data_type_token.atom_id).data.token
            ele = self.mem.new_data_ele(data_type_token)
            self.ns.link_var(self.target, ele)
    def _get_op_code(self):
        """docstring for _get_op_code"""
        return self.__op_code[self.op.tvalue]
    def gen_assm_code(self):
        """docstring for gen_assm_code"""
        if self.od0.ttype is "data":
            self.code_list.append(bap.SetData(self.od0.tvalue, bap.DR0))
        else:
            self.code_list.append(bap.LoadData(bap.DR0, self.ns.get_var_ele(self.od0)))
        if self.od1.ttype is "data":
            self.code_list.append(bap.SetData(self.od1.tvalue, bap.DR1))
        else:
            self.code_list.append(bap.LoadData(bap.DR1, self.ns.get_var_ele(self.od1)))
        self.code_list.append(bap.SetCR(self._get_op_code()))
        self.code_list.append(bap.SaveRE(self.ns.get_var_ele(self.target)))
    def gen_simu_code(self):
        codes = []
        for code in self.code_list:
            codes += code.gen_simu_code()
        return codes


class AssemblyStmtAssg(AssemblyStmt):
    """docstring for StmtAssg"""
    def __init__(self, stmt_token_view, ns, mem):
        super(AssemblyStmtAssg, self).__init__(stmt_token_view, mem)
        self.ns = NameSpace(ns)
        self._type = "assignment"
        self.target = self.token_view.target.tvalue
        self.atom_list = []
        self._generate_assembly_view()
    def _generate_assembly_view(self):
        """link the variable of different exprssion."""
        atom_list = self.token_view.expr.atom_list
        if len(atom_list) == 1:
            atom = atom_list[0]
            if atom.op is None:
                if atom.od0.ttype is "data":
                    self.atom_list.append(AssemblyStmtAssgAtomData(self.ns, self.mem, self.target, atom.od0))
                elif atom.od0.ttype is "variable":
                    self.atom_list.append(AssemblyStmtAssgAtomVariable(self.ns, self.target, atom.od0))
                else:
                    raise Exception("Wrong token type: {}".format(atom.od0.ttype))
            else:
                self.atom_list.append(AssemblyStmtAssgAtomArithmetic(self.ns, self.mem, self.target, atom))
        else:
            for atom in atom_list:
                self.atom_list.append(AssemblyStmtAssgAtomArithmetic(self.ns, self.mem, atom.atom_id, atom))
            self.atom_list[-1].target = self.target
    def allocate_virtual_space(self):
        """For a new variable, in name space, add new var; in memory, allocate space for data; link the variable and the data.
        If not a new variable, if it is a new statement, allocate new space, or else do nothing."""
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
            code_lines += len(atom.code_list)
        return code_lines
    def get_physical_addr(self):
        """docstring for get_physical_addr"""
        for var in self.ns.var_list:
            self.mem.assign_phy_addr_to_dynamic_data(var.data)
        self.mem.reset_dynamic_page()
    def gen_simu_file(self):
        """docstring for """
        codes = []
        for atom in self.atom_list:
            codes += atom.gen_simu_code()
        return codes


class AssemblyStmtWhile(AssemblyStmt):
    """docstring for StmtWhile"""
    def __init__(self, token_view, ns, mem):
        super(AssemblyStmtWhile, self).__init__(token_view, mem)
        self.ns = NameSpace(ns)
        self._type = "while"
        self.atom_list = []
        self._generate_assembly_view()
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
        self.ns = NameSpace(None)
        self.code_lines = 0
        self.run()
    def run(self):
        self.generate_assembly_view()
        self.allocate_virtual_space()
        self.gen_assm_code()
        self.allocate_mem_page()
        self.allocate_physical_addr()
        #self.gen_simu_file()
    def generate_assembly_view(self):
        """docstring for _create_assemb_view"""
        print("generate assembly view.")
        for stmt in self.token_view.stmt_list:
            if stmt.ttype == "assignment":
                self.assembly_view.append(AssemblyStmtAssg(stmt, self.ns, self.mem))
            elif stmt.ttype == "while":
                self.assembly_view.append(AssemblyStmtWhile(stmt, self.ns, self.mem))
            else:
                pass
    def allocate_virtual_space(self):
        """in name space, add new var; in memory, allocate space for data; link the variable and the data."""
        for stmt in self.assembly_view:
            stmt.allocate_virtual_space()
    def gen_assm_code(self):
        """docstring for gen_assm_code"""
        for stmt in self.assembly_view:
            stmt.gen_assm_code()
    def allocate_mem_page(self):
        """allocate the memory to the page."""
        for stmt in self.assembly_view:
            self.code_lines += stmt.get_code_lines()
        if self.code_lines > 256:
            raise Exception("momory is not enough. code size is {}".format(self.code_lines))
        self.mem.allocate_mem_page(self.code_lines, self.ns.get_var_size())
    def allocate_physical_addr(self):
        """allocate physical address to data element.
        The data elements are dispatched in hierarchy namespace."""
        for var in self.ns.var_list:
            self.mem.assign_phy_addr_to_static_data(var.data)
        for stmt in self.assembly_view:
            stmt.get_physical_addr()
    def gen_simu_file(self, oufile):
        """docstring for gen_simu_file"""
        codes = []
        with open(oufile, "w") as fout:
            for stmt in self.assembly_view:
                codes += stmt.gen_simu_file()
            fout.writelines(codes)

if __name__ == "__main__":
    print("lexer.py")
