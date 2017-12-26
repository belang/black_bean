#! $PATH/python

# file name: lexer.py
# author: lianghy
# time: 2017/11/13 10:51:57

"""build statement structure from token list"""


def create_new_stmt(token, token_list=None):
    """create a statement by the type and cached token."""
    if token.tvalue == "=":
        return StmtAssg(token_list)
    elif token.tvalue == "while":
        return StmtWhile(token_list)
    else:
        raise Exception("Unkown statement type: {}:{}".format(token.ttype, token.tvalue))


class ExprAtom(object):
    """Form: od0 op od1"""
    def __init__(self, atom_id=0, op=None, od0=None, od1=None):
        super(ExprAtom, self).__init__()
        self.op = op
        self.od0 = od0
        self.od1 = od1
        self.atom_id = atom_id
    def formular(self, var_addr):
        """return the assembly command"""
        pass
    def value(self):
        """compute the result of the expression"""
        return (self.od0, self.op, self.od1)


def ananlyze_expr_structure(token_list):
    """analyse expression."""
    atom_list = []
    expr_state = "operand"
    unprocess_tk = []
    at_id = 0
    for token in token_list:
        if expr_state == 'operand':
            if token.ttype == "variable" or token.ttype == "data":
                unprocess_tk.append(token)
                expr_state = "operator"
                continue
        elif expr_state == "operator":
            if token.ttype == "operator":
                while len(unprocess_tk) > 2:
                    import bean_language
                    if bean_language.OPERATOR_ORDER[unprocess_tk[-2].tvalue] < bean_language.OPERATOR_ORDER[token.tvalue]:
                        break
                    new_expr_atom = ExprAtom(atom_id=at_id, od1=unprocess_tk.pop(),
                                             op=unprocess_tk.pop(), od0=unprocess_tk.pop())
                    at_id = at_id+1
                    atom_list.append(new_expr_atom)
                    unprocess_tk.append(new_expr_atom)
                unprocess_tk.append(token)
                expr_state = "operand"
                continue
        else:
            raise Exception("Unkown expr_state")
        raise Exception("Wrong expression: {}".format(token.tvalue))
    if expr_state == "operand":
        raise Exception("The end of the expression is an operator!")
    while len(unprocess_tk) > 2:
        new_expr_atom = ExprAtom(atom_id=at_id, od1=unprocess_tk.pop(),
                                 op=unprocess_tk.pop(), od0=unprocess_tk.pop())
        at_id = at_id+1
        atom_list.append(new_expr_atom)
        unprocess_tk.append(new_expr_atom)
    import tokenizer
    if isinstance(unprocess_tk[0], tokenizer.Token):
        new_expr_atom = ExprAtom(atom_id=at_id, od1=None,
                                 op=None, od0=unprocess_tk.pop())
        atom_list.append(new_expr_atom)
    return atom_list


class CompareEpxr():
    """docstring for CompareEpxr"""
    def __init__(self, token_list):
        self.left = 0
        self.right = 0
        self.cop = "!="
        self.ananlyze_compare_structure(token_list)
    def ananlyze_compare_structure(self, token_list):
        """docstring for ananlyze_condition_structure"""
        state = "left"
        for token in token_list:
            if state == "left":
                if token.ttype is "variable" or token.ttype is "data":
                    self.left = token
                    state = "cop"
                    continue
            elif state == "cop":
                import bean_language
                if token.tvalue in bean_language.COMPARE_OPERATOR:
                    self.cop = token
                    state = "right"
                    continue
            elif state == "right":
                self.right = token
                state = "finish"
            else:
                raise Exception("Fatal Error")
        if state == "right":
            raise Exception("Wrong condition {}".format(" ".join([t.tvalue for t in token_list])))


class Stmt():
    """docstring for Stmt"""
    def __init__(self, token_list):
        self.ttype = "Stmt"
        self.block_keys = ("if", "while")
        self.indent_level = 0
        self.stmt_is_complete = False
        if token_list is None:
            self._token_list = []
        else:
            if token_list[0].ttype == "indent":
                self.indent_level = token_list[0].tvalue//4
                self._token_list = token_list[1:]
            else:
                self._token_list = token_list
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



class StmtAssg(Stmt):
    """docstring for StmtAssg"""
    def __init__(self, token_list):
        super(StmtAssg, self).__init__(token_list)
        self.ttype = "assignment"
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
        self.target = self._token_list[0]
        self.expr = ananlyze_expr_structure(self._token_list[1:])


class StmtWhile(Stmt):
    """docstring for StmtWhile"""
    def __init__(self, token_list):
        super(StmtWhile, self).__init__(token_list)
        self.ttype = "while"
        self.condition = None
        self.block = []
        self._state = "condition"
        self._condition_tk = []
        self._block_tk = []
        self._sub_block = 0
    def add_token(self, token):
        """get tokens of while"""
        if self._state == "condition":
            if token.tvalue is None:
                self._state = "block"
            else:
                self._condition_tk.append(token)
        elif self._state == "block":
            if token.tvalue in self.block_keys:
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
        self.condition = CompareEpxr(self._condition_tk)
        self.block = lexer(self._block_tk)
    def formular(self):
        """return the assembly command"""
        pass
    def value(self):
        """compute the result of the expression"""
        pass

def lexer_idle(token, cached_tk, stmt_list):
    """idle state process"""
    __statement_key_list = ["if", "while"]
    state = "idle"
    if token.ttype == "nextline":
        return state
    if token.ttype == "indent":
        cached_tk.append(token)
        return state
    if token.ttype == "variable":
        if token.tvalue in __statement_key_list:
            stmt_list.append(create_new_stmt(token, None))
            cached_tk.clear()
            state = "add token"
        else:
            state = "catch one var"
            cached_tk.append(token)
    else:
        raise Exception("Error in start of the statement.")
    return state

def lexer(token_list):
    """main process"""
    print("start lexer.")
    stmt_list = []
    #__bean_language_key_list = ["if", "else", "while", "break", "exit", "end"]
    state = "idle"
    cached_tk = []
    for token in token_list:
        if state == "idle":
            state = lexer_idle(token, cached_tk, stmt_list)
        elif state == "add token":
            stmt_list[-1].add_token(token)
            if stmt_list[-1].stmt_is_complete is True:
                state = "idle"
        elif state == "catch one var":
            if token.ttype == "operator" and token.tvalue == "=":
                stmt_list.append(create_new_stmt(token, cached_tk))
                cached_tk = []
                state = "add token"
            else:
                raise Exception("Wrong statement state.")
        else:
            raise Exception("Wrong statement state.")
    return stmt_list



if __name__ == "__main__":
    print("lexer.py")
