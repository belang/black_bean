#! $PATH/python

# file name: lexer_token_view.py
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

class TokenExprAtom(object):
    """Form: od0 op od1"""
    def __init__(self, atom_id=0, op=None, od0=None, od1=None):
        super(TokenExprAtom, self).__init__()
        self.opt = op
        self.od0 = od0
        self.od1 = od1
        self.atom_id = atom_id
    def formular(self, var_addr):
        """return the assembly command"""
        pass
    def value(self):
        """compute the result of the expression"""
        return (self.od0, self.opt, self.od1)
    def write_data(self):
        """docstring for write_data"""
        pass


class TokenExpr(object):
    """docstring for Expr"""
    def __init__(self, token_list):
        super(TokenExpr, self).__init__()
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
        at_id = 0
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
                            new_expr_atom = TokenExprAtom(atom_id = at_id, od1=unprocess_tk.pop(),
                                            op=unprocess_tk.pop(), od0=unprocess_tk.pop())
                            at_id = at_id+1
                            self.atom_list.append(new_expr_atom)
                            unprocess_tk.append(new_expr_atom)
                        else:
                            break
                    unprocess_tk.append(token)
                    expr_state = "idle"
                else:
                    raise Exception("Wrong expression: {}".format(token.tvalue))
        if expr_state != "operand":
            raise Exception("Wrong expression")
        elif len(unprocess_tk) == 1:
            self.atom_list.append(TokenExprAtom(atom_id=at_id, od0=unprocess_tk.pop()))
            at_id = at_id+1
        else:
            raise Exception("Wrong expression")
    def formular(self):
        """return the assembly command"""
        return self.atom_list
    def value(self):
        """compute the result of the expression"""
        return self.atom_list



class TokenStmt():
    """docstring for Stmt"""
    def __init__(self, token_list):
        self._token_list = token_list
        self.ttype = "Stmt"
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



class TokenStmtAssg(TokenStmt):
    """docstring for StmtAssg"""
    def __init__(self, token_list):
        super(TokenStmtAssg, self).__init__(token_list)
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
        self.expr = TokenExpr(self._token_list[1:])
    def formular(self):
        """return the assembly command"""
        self.target


class TokenStmtWhile(TokenStmt):
    """docstring for StmtWhile"""
    def __init__(self, token_list):
        super(TokenStmtWhile, self).__init__(token_list)
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
        self.condition = TokenExpr(self._condition_tk)
        self.block = analyse_morphology(self._block_tk)
    def formular(self):
        """return the assembly command"""
        pass
    def value(self):
        """compute the result of the expression"""
        pass


class TokenLexer():
    """docstring for BeanLexer.
    _cache_token: cache some token before relize a statement type.
    _stmt_state: state machine for getting stmt type.
    """
    def __init__(self, token_list):
        ### language fetures
        self.token_list = token_list
        self.stmt_list = []
        self.__bean_language_key_list = ["if", "else", "while", "break", "exit", "end"]

        self.stmt_list = analyse_morphology(self.token_list)
    def formular(self):
        """docstring for formular"""
        pass
    def value(self):
        """compute the result of the expression"""
        pass



if __name__ == "__main__":
    print("lexer.py")
