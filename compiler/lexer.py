#! $PATH/python

# file name: lexer.py
# author: lianghy
# time: 2017/11/13 10:51:57

"""build statement structure from token list"""

__statement_key_list = ["if", "while"]

def create_new_stmt(token, token_list=None):
    """create a statement by the type and cached token."""
    if token.tvalue == "=":
        return StmtAssg(token_list)
    elif token.tvalue == "while":
        return StmtWhile(token_list)
    else:
        raise Exception("Unkown statement type: {}:{}".format(token.ttype, token.tvalue))

def analyse_morphology(token_list):
    """main function"""
    state = "idle"
    stmt_list = []
    cached_tk = []
    for token in token_list:
        if state == "idle":
            if token.ttype == "nextline":
                continue
            if token.ttype == "indent":
                cached_tk.append(token)
                continue
            if token.ttype == "variable":
                if token.tvalue in __statement_key_list:
                    stmt_list.append(create_new_stmt(token, None))
                    cached_tk = []
                    state = "add token"
                else:
                    state = "variable"
                    cached_tk.append(token)
            else:
                raise Exception("Error in start of the statement.")
        elif state == "add token":
            stmt_list[-1].add_token(token)
            if stmt_list[-1].stmt_is_complete is True:
                state = "idle"
        elif state == "variable":
            if token.ttype == "operator" and token.tvalue == "=":
                stmt_list.append(create_new_stmt(token, cached_tk))
                cached_tk = []
                state = "add token"
            else:
                raise Exception("Wrong statement state.")
        else:
            raise Exception("Wrong statement state.")
    return stmt_list

def save_data(data, mem_addr):
    """write the data to the mem_addr"""
    bl.

def load_data(reg, data):
    """ """

def config_op(data):
    """ """

def write_result(mem_addr):
    """ """


class ExprAtom(object):
    """Form: od0 op od1"""
    def __init__(self, op=None, od0=None, od1=None):
        super(ExprAtom, self).__init__()
        self.opt = op
        self.od0 = od0
        self.od1 = od1
    def formular(self, var_addr):
        """return the assembly command"""
        if self.opt is None:
            save_data(self.od0, var_addr)
        else:
            load_data(self.od0)
            load_data(self.od1)
            config_op(self.opt)
            write_result(var_addr)
        return (self.od0, self.opt, self.od1)
    def value(self):
        """compute the result of the expression"""
        return (self.od0, self.opt, self.od1)
    def write_data(self):
        """docstring for write_data"""
        pass


class Expr(object):
    """docstring for Expr"""
    def __init__(self, token_list):
        super(Expr, self).__init__()
        self.atom_list = []
        self._token_list = token_list
        self.__operator_order = {
            "+":1, "-":1,
            "*":2, "/":2,
            "**":3,
            }
        self._lexical_analyse()
    def _lexical_analyse(self):
        """docstring for expr_lexer"""
        expr_state = "idle"
        unprocess_tk = []
        for token in self._token_list:
            if expr_state == 'idle':
                if token.ttype == "variable" or token.ttype == "data":
                    unprocess_tk.append(token)
                    expr_state = "operand"
                else:
                    raise Exception("Wrong expression: {}".format(token.tvalue))
            elif expr_state == "operand":
                if token.ttype == "operator":
                    while len(unprocess_tk) > 3:
                        if self.__operator_order[unprocess_tk[-2]] >= self.__operator_order[token]:
                            new_expr_atom = ExprAtom(od1=unprocess_tk.pop(),
                                                     op=unprocess_tk.pop(), od0=unprocess_tk.pop())
                            self.atom_list.append(new_expr_atom)
                            unprocess_tk.append(new_expr_atom)
                    unprocess_tk.append(token)
                    expr_state = "idle"
                else:
                    raise Exception("Wrong expression: {}".format(token.tvalue))
        if expr_state != "operand":
            raise Exception("Wrong expression")
        elif len(unprocess_tk) == 1:
            self.atom_list.append(ExprAtom(od0=unprocess_tk.pop()))
        else:
            raise Exception("Wrong expression")
    def formular(self):
        """return the assembly command"""
        return self.atom_list
    def value(self):
        """compute the result of the expression"""
        return self.atom_list



class Stmt():
    """docstring for Stmt"""
    def __init__(self, token_list):
        self._token_list = token_list
        self._type = "Stmt"
        self.__block_keys = ("if", "while")
        self.indent_level = 0
        self.stmt_is_complete = False
        if self._token_list is not None:
            if self._token_list[0].ttype == "indent":
                self.indent_level = self._token_list[0].tvalue//4
                self._token_list.pop(0)
    def add_token(self, token):
        """get all statement tokens."""
        pass
    def _analyse_structure(self):
        """build statement structure"""
        pass
    def formular(self):
        """return the assembly command"""
        raise Exception("Formular must be rewritten.")
    def value(self):
        """compute the result of the expression"""
        pass


class Variable():
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


class StmtAssg(Stmt):
    """docstring for StmtAssg"""
    def __init__(self, token_list):
        super(StmtAssg, self).__init__(token_list)
        self._type = "assignment"
        self.target = ""
        self.expr = None
    def add_token(self, token):
        """get all stmt token list one by one."""
        if token.ttype == "nextline":
            self._analyse_structure()
            self.stmt_is_complete = True
        else:
            self._token_list.append(token)
    def _analyse_structure(self):
        """build statement structure"""
        self.target = Variable(self._token_list[0])
        self.expr = Expr(self._token_list[1:])
    def formular(self):
        """return the assembly command"""
        self.target


class StmtWhile(Stmt):
    """docstring for StmtWhile"""
    def __init__(self, token_list):
        super(StmtWhile, self).__init__(token_list)
        self._type = "while"
        self.condition = None
        self.block = []
        self._state = "condition"
        self._condition_tk = []
        self._block_tk = []
        self._sub_block = 0
    def add_token(self, token):
        """get tokens of while"""
        if self._state == "condition":
            if token.tvalue == ":":
                self._state = "block"
            else:
                self._condition_tk.append(token)
        elif self._state == "block":
            if token.tvalue in self.__block_keys:
                self._sub_block = self._sub_block+1
            elif token.tvalue == "end":
                if self._sub_block > 0:
                    self._sub_block = self._sub_block-1
                else:
                    self._analyse_structure()
                    self.stmt_is_complete = True
            self._block_tk.append(token)
        else:
            self._token_list.append(token)
    def _analyse_structure(self):
        """build statement structure"""
        self.condition = Expr(self._condition_tk)
        self.block = analyse_morphology(self._block_tk)
    def formular(self):
        """return the assembly command"""
        pass
    def value(self):
        """compute the result of the expression"""
        pass


class Lexer():
    """docstring for BeanLexer.
    _cache_token: cache some token before relize a statement type.
    _stmt_state: state machine for getting stmt type.
    """
    def __init__(self, token_list):
        ### language fetures
        self.token_list = token_list
        self.assembly_code = []
        self.__bean_language_key_list = ["if", "else", "while", "break", "exit", "end"]

        import lexer_token_view
        self.token_view = lexer_token_view.TokenLexer(token_list)
        import lexer_assembly_view
        self.assembly_view = lexer_assembly_view.AssemblyLexer(self.token_view)



if __name__ == "__main__":
    print("lexer.py")
