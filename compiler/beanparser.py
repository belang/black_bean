#! $PATH/python

# file name: parser.py
# author: lianghy
# time: 2017/11/13 10:51:57

"""build statement structure from token list"""

import bean_assembly_code_package as bap
import bean_language


#### name space
class NSVar(object):
    """docstring for NAVar"""
    def __init__(self, name):
        super(NSVar, self).__init__()
        self.name = name
        self.size = 1
        self.domain = "private"
        self.physical_addr = -1
        #self.mem = mem

class LineLabel(object):
    """docstring for Location"""
    def __init__(self):
        super(LineLabel, self).__init__()
        self.physical_addr = 0

class NameSpace():
    """docstring for NameSpace"""
    def __init__(self, nas):
        self.parrent_nas = nas
        self.sub_nas = []
        self.var_list = []
        self.label_list = []
        self.mem = Memory()
        if self.parrent_nas is not None:
            self.parrent_nas.sub_nas.append(self)
    def has_var(self, name):
        """check if there is a variable in the space. If not create it."""
        #print("has var--var name is:", name)
        for one_var in self.var_list:
            if one_var.name == name:
                return True
        return False
    def new_var(self, name):
        """docstring for new_var"""
        nvar = NSVar(name)
        self.var_list.append(nvar)
    def get_var(self, name):
        """search the NSVar, and return it."""
        #print("var: ", name)
        for var in self.var_list:
            if var.name == name:
                return var
        #print("could not find variable: "+"var")
        return None
    def get_var_size(self):
        """get all variable count."""
        return sum([var.size for var in self.var_list])
    ######## label
    def new_label(self):
        """docstring for new_label"""
        nlabel = LineLabel()
        self.label_list.append(nlabel)
        return nlabel
    ######## memory
    def allocate_mem_space(self, code_size):
        self.mem.allocate_mem_space(code_size, self.get_var_size())


class MemDataPage(object):
    """docstring for MemDataPage"""
    def __init__(self):
        super(MemDataPage, self).__init__()
        self.first_line = 0
        self.current_position = 0
        self.variable_size = 0


class Memory(object):
    """docstring for Memory:
        data_page: a list, False meanas no value."""
    def __init__(self, total_size=256):
        self.total_size = total_size
        self.code_page = []
        self.data_page = MemDataPage()
    def allocate_mem_space(self, code_size, static_var_size):
        """caculate the start line of data page."""
        lines = code_size//8+1
        self.data_page.first_line = lines
        static_lines = static_var_size//8+1
        self.data_page.variable_size = static_lines+lines
        #if self.data_page.variable_size > self.total_size:
            #raise Exception("momory is not enough. code size is {}, variable size is {}".format(lines, static_lines))
        self.data_page.current_position = 8*self.data_page.first_line
        print("data page starts at {}".format(self.data_page.first_line))


#### assignment
class Assignment(object):
    """docstring for Assignment"""
    def __init__(self, nas):
        super(Assignment, self).__init__()
        self.nas = nas
        self.target = None
        self.code_list = []
        self.data_width = 1
    def parse_variable(self):
        """init"""
        if not self.nas.has_var(self.target.tvalue):
            self.nas.new_var(self.target.tvalue)
    def generate_code_with_var(self):
        """docstring for generate_code_with_var"""
        pass
    def get_code_size(self, code_size):
        """docstring for allocate_mem_space"""
        for code in self.code_list:
            code_size += code.code_size
        return code_size
    def caculate_physical_addr(self):
        """docstring for caculate_physical_addr"""
        var = self.nas.get_var(self.target.tvalue)
        if var.physical_addr == -1:
            var.physical_addr = self.nas.mem.data_page.current_position
            self.nas.mem.data_page.current_position += self.data_width
    def gen_simu_code(self):
        codes = []
        for code in self.code_list:
            codes += code.gen_simu_code()
        return codes


class SetData(Assignment):
    """docstring for Data"""
    def __init__(self, nas, stmt):
        super(SetData, self).__init__(nas)
        self.target = stmt.target
        self.source = stmt.expr[0]
    def generate_code_with_var(self):
        """docstring for generate_code_with_var"""
        self.code_list.append(bap.SetData(self.source.od0.tvalue, bap.DR0))
        self.code_list.append(bap.SaveData(bap.DR0, self.nas.get_var(self.target.tvalue)))


class SetVar(Assignment):
    """docstring for SetVar"""
    def __init__(self, nas, stmt):
        super(SetVar, self).__init__(nas)
        self.target = stmt.target
        self.source = stmt.expr[0]
    def caculate_physical_addr(self):
        """point to the source physical address."""
        var = self.nas.get_var(self.target.tvalue)
        if var.physical_addr == -1:
            var.physical_addr = self.nas.get_var(self.source.tvalue).physical_addr


class Arithmetic(Assignment):
    """docstring for StmtAssg"""
    def __init__(self, nas, stmt):
        super(Arithmetic, self).__init__(nas)
        self.target = stmt.target
        self.expr = stmt.expr
        self.last_op = "00"
    def generate_code_with_var(self):
        """docstring for generate_code_with_var"""
        state = "idle"
        for atom in self.expr:
            if state == "idle":
                self._arith_code(atom)
                last_atom_id = atom.atom_id
                state = "arith"
            elif state == "arith":
                import lexer
                if isinstance(atom.od0, lexer.ExprAtom) and last_atom_id == atom.od0.atom_id:
                    self.code_list.append(bap.RegOp(bap.RE, bap.DR0))
                    if atom.od1.ttype is "data":
                        self.code_list.append(bap.SetData(atom.od1.tvalue, bap.DR1))
                    else:
                        self.code_list.append(bap.LoadData(self.nas.get_var(atom.od1.tvalue), bap.DR1))
                    state = "arith"
                elif isinstance(atom.od1, lexer.ExprAtom) and last_atom_id == atom.od1.atom_id:
                    self.code_list.append(bap.RegOp(bap.RE, bap.DR1))
                    if atom.od0.ttype is "data":
                        self.code_list.append(bap.SetData(atom.od0.tvalue, bap.DR0))
                    else:
                        self.code_list.append(bap.LoadData(self.nas.get_var(atom.od0.tvalue), bap.DR0))
                    state = "arith"
                else:
                    self._cache_result(atom)
                    state = "two arith"
                last_atom_id = atom.atom_id
            elif state == "tow arith":
                self._compute_two_arith(atom)
                state = "arith"
            self._set_op(atom.op.tvalue)
        self.code_list.append(bap.SaveRE(self.nas.get_var(self.target.tvalue)))
    def _arith_code(self, atom):
        """one arithmetic"""
        if atom.od0.ttype is "data":
            self.code_list.append(bap.SetData(atom.od0.tvalue, bap.DR0))
        else:
            self.code_list.append(bap.LoadData(self.nas.get_var(atom.od0.tvalue), bap.DR0))
        if atom.od1.ttype is "data":
            self.code_list.append(bap.SetData(atom.od1.tvalue, bap.DR1))
        else:
            self.code_list.append(bap.LoadData(self.nas.get_var(atom.od1.tvalue), bap.DR1))
        self._set_op(atom.op.tvalue)
    def _cache_result(self, atom):
        """cache data to data reg 2"""
        self.code_list.append(bap.RegOp(bap.RE, bap.DR2))
    def _compute_two_arith(self, atom):
        """docstring for _compute_two_arith"""
        self.code_list.append(bap.RegOp(bap.RE, bap.DR0))
        self.code_list.append(bap.RegOp(bap.DR2, bap.DR1))
        self._set_op(atom.op.tvalue)
    def _set_op(self, opv):
        """set operator"""
        temp_op = bean_language.OP_CODE[opv]
        if self.last_op != temp_op:
            self.code_list.append(bap.SetCR(temp_op))
            self.last_op = temp_op


#### branch
class Brancher():
    """docstring for Brancher"""
    def __init__(self, nas, condition, end_location):
        super(Brancher, self).__init__()
        self.nas = nas
        self.left = condition.left
        self.right = condition.right
        self.cop = condition.cop
        self.end_location = end_location
        self.code_list = []
    def parse_variable(self):
        """init"""
        if self.left.ttype is "data":
            pass
        elif self.nas.has_var(self.left.tvalue):
            pass
        else:
            raise Exception("condition variables are not found in: "
                            +self.left.tvalue+self.cop.tvalue+self.right.tvalue)
        if self.right.ttype is "data":
            pass
        elif self.nas.has_var(self.right.tvalue):
            pass
        else:
            raise Exception("condition variables are not found in: "
                            +self.left.tvalue+self.cop.tvalue+self.right.tvalue)
    def generate_code_with_var(self):
        """docstring for generate_code_with_var"""
        if self.left.ttype is "data":
            self.code_list.append(bap.SetData(self.left.tvalue, bap.DR0))
        else:
            self.code_list.append(bap.LoadData(self.nas.get_var(self.left.tvalue), bap.DR0))
        if self.right.ttype is "data":
            self.code_list.append(bap.SetData(self.right.tvalue, bap.DR1))
        else:
            self.code_list.append(bap.LoadData(self.nas.get_var(self.right.tvalue), bap.DR1))
        self.code_list.append(bap.SetCR(bean_language.OP_CODE[self.cop.tvalue]))
        self.code_list.append(bap.SetAR(self.end_location))
        self.code_list.append(bap.ConditionBranch())
    def get_code_size(self, code_size):
        """docstring for get_code_size"""
        for code in self.code_list:
            code_size += code.code_size
        return code_size
    def gen_simu_code(self):
        codes = []
        for code in self.code_list:
            codes += code.gen_simu_code()
        return codes


#### while
class StmtWhile():
    """local nas for condition."""
    def __init__(self, nas, stmt):
        self.nas = nas
        self.start_location = self.nas.new_label()
        self.end_location = self.nas.new_label()
        self.condition = Brancher(self.nas, stmt.condition, self.end_location)
        self.block = CodeBlock(self.nas, stmt.block)
        self.end_code = []
    def parse_variable(self):
        """in name space, add new var;
        in memory, allocate space for data; link the variable and the data."""
        self.condition.parse_variable()
        self.block.parse_variable()
    def generate_code_with_var(self):
        """docstring for generate_code_with_var"""
        self.condition.generate_code_with_var()
        self.block.generate_code_with_var()
        self.end_code.append(bap.Jump(self.start_location))
    def get_code_size(self, code_size):
        """docstring for get_code_size"""
        self.start_location.physical_addr = code_size
        code_size = self.condition.get_code_size(code_size)
        code_size = self.block.get_code_size(code_size)
        code_size += self.end_code[0].code_size        # jump back, only one bap
        self.end_location.physical_addr = code_size
        return code_size
    def caculate_physical_addr(self):
        self.block.caculate_physical_addr()
    def gen_simu_code(self):
        codes = []
        codes += self.condition.gen_simu_code()
        codes += self.block.gen_simu_code()
        codes += self.end_code[0].gen_simu_code()
        return codes

class CodeBlock(object):
    """docstring for CodeBlock"""
    def __init__(self, nas, stmt_list):
        super(CodeBlock, self).__init__()
        self.nas = nas
        self.stmt_list = []
        for stmt in stmt_list:
            if stmt.ttype == "assignment":
                if stmt.expr[0].op is None:
                    if stmt.expr[0].od0.ttype is "data":
                        self.stmt_list.append(SetData(nas, stmt))
                    else:
                        self.stmt_list.append(SetVar(nas, stmt))
                else:
                    self.stmt_list.append(Arithmetic(nas, stmt))
            elif stmt.ttype == "while":
                self.stmt_list.append(StmtWhile(nas, stmt))
            else:
                pass
    def get_code_size(self, code_size):
        """docstring for get_code_size"""
        for stmt in self.stmt_list:
            code_size = stmt.get_code_size(code_size)
        return code_size
    def __call__(self):
        self.parse_variable()
        self.generate_code_with_var()
        self.allocate_mem_space()
        self.caculate_physical_addr()
        #self.gen_simu_file()
    def parse_variable(self):
        """in name space, add new var;
        in memory, allocate space for data; link the variable and the data."""
        for stmt in self.stmt_list:
            stmt.parse_variable()
    def generate_code_with_var(self):
        """docstring for generate_code_with_var"""
        for stmt in self.stmt_list:
            stmt.generate_code_with_var()
    def allocate_mem_space(self):
        """allocate the memory to the page."""
        code_size = 0
        code_size = self.get_code_size(code_size)
        print("code size is {}".format(code_size))
        #if code_size > 256:
            #raise Exception("momory is not enough. code size is {}".format(code_size))
        self.nas.allocate_mem_space(code_size)
    def caculate_physical_addr(self):
        """allocate physical address to variable in namespace."""
        for stmt in self.stmt_list:
            stmt.caculate_physical_addr()
    def gen_simu_code(self):
        """generate assembly code for simulation"""
        codes = []
        for stmt in self.stmt_list:
            codes += stmt.gen_simu_code()
        return codes


class Parser():
    """docstring for BeanLexer.
    _cache_token: cache some token before relize a statement type.
    _stmt_state: state machine for getting stmt type.
    """
    def __init__(self, stmt_list, nas=None):
        ### language fetures
        self.__bean_language_key_list = ["if", "else", "while", "break", "exit", "end"]
        if nas is None:
            self.nas = NameSpace(None)
        else:
            self.nas = nas
        self.code_block = CodeBlock(self.nas, stmt_list)
        print("start parser")
        self.code_block()
    def write_simu_file(self, oufile):
        """docstring for write_simu_file"""
        try:
            with open(oufile, "w") as fout:
                codes = self.code_block.gen_simu_code()
                fout.writelines(codes)
                fout.write(bap.ir(bap.NULL, bap.NULL))
        except:
            print(codes)


if __name__ == "__main__":
    print("parser.py")
