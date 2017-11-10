#! $PATH/python

# file name: bean_parser.py
# author: lianghy
# time: 2017/11/3 15:21:56
"""parse a bean language program to python bean object."""

import os
from os.path import join
import re
import argparse
import configparser
import black_bean_common_func as bbc

class Stmt(object):
    """docstring for Stmt
    add_token: get all the statement tokens."""
    def __init__(self, value, *token_list):
        super(Stmt, self).__init__()
        self._type = value
        self._token_list = []
        self.stmt_is_complete = False
        if self._type == "assignment":
            for token in token_list:
                self._token_list.append(token)
    def add_token(self, token):
        """get all stmt token list one by one."""
        if self._type == "assignment":
            self._assg_add_token(token)
        elif self._type == "if":
            pass
        else:
            pass
    def _assg_add_token(self, token):
        """variable"""
        if token._type == "nextline":
            self._analys_assg_structure()
            self.stmt_is_complete = True
        else:
            self._token_list.append(token)
    def _analys_assg_structure(self):
        """build statement structure"""
        self.target = Variable(self._token_list[0]._value)
        #self.source = self._token_list[2:]
        for token in self._token_list[2:]:
            pass
        #next



class Expr(object):
    """docstring for Expr"""
    def __init__(self):
        super(Expr, self).__init__()
        self._type = "expr"
        

class Variable(Expr):
    """docstring for Variable"""
    def __init__(self, name):
        super(Variable, self).__init__()
        self._type = "variable"
        self.name = name
    def _check_name(self, token):
        """check if the token value is a key"""
        pass




class BeanLexer(object):
    """docstring for BeanLexer.
    _temp_stmt: is current statement object.
    _cache_token: cache some token before relize a statement type.
    _stmt_state: state machine for getting stmt type.

    
    """
    def __init__(self, arg):
        super(StmtType, self).__init__()
        self.arg = arg
        self.stmt_list = []
        self._temp_stmt = None
        self._cache_token = []
        self._var_namespace = {}
        self._current_stmt_type = "new"
        self._stmt_state = "idle"
        ### statement type
        self._stmt_type_list = {
                "new": self._new_stmt,
                "assignment": self._assg,
                "if": self._if,
                "while": self._while,
                "exit": self._exit,
                "end": self._end,
                }
        ### language fetures
        self.__bean_language_key_list = ["if", "else", "while", "break", "exit", "end"]
    def analyse_morphology(self, token_list):
        """statement regular expression."""
        self._current_stmt_type = "new"
        for token in token_list:
            if self._current_stmt_type == "new":
                self._get_new_stmt(token)
            else:
                self.stmt_list[-1].add_token(token)
                if self.stmt_list[-1].stmt_is_complete:
                    self._current_stmt_type = "new"
    ## statement type fucntion
    def _get_new_stmt(self, token):
        """new statement
        var : keys -> stmt type; var -> add to list"""
        if token[0] != "nextline":
            self._get_stmt_type(token)
            return
        if self._stmt_state == "idle":
            if token._type == "variable":
                if token._value in self.__bean_language_key_list:
                    self.stmt_list.append(Stmt(token._value))
                    self._current_stmt_type = token._value
                    self._cache_token = []
                else:
                    self._temp_stmt_state = "new var"
                    self._cache_token.add_token(token)
            else:
                raise Exception("Error in start of the statement.")
        elif self._stmt_state == "new var":
            if token._type == "operator" and token._value == "=":
                self.stmt_list.append(Stmt("assignment", self._cache_token))
                self._current_stmt_type = "assignment"
                self._cache_token = []
            else:
                raise Exception("Error in start of the statement.")
        else:
            raise Exception("Error in start of the statement.")

## Tokenizer #################################################
class Token():
    """docstring for Token"""
    def __init__(self, ttype, value):
        self._type = ttype
        self._value = value

class LineTokenizer(object):
    """docstring for LineTokenizer"""
    def __init__(self, arg):
        super(LineTokenizer, self).__init__()
        self.arg = arg
        self.token = []
        ### inner flag
        self._line_pointer = 0
        self._variable_start_pos = 0
        self._variable_stop_pos = 0
        self._data_start_pos = 0
        self._data_stop_pos = 0
        self._lien_state = "None"
        ## token type
        self.__token_type = {
                "variable": 1,
                "data": 2,
                "nextline": 3,
                "operator": 4
                }
        ###### variable
        self._alphabet_re = r"[a-z,A-Z]"
        self._var_char_re = r"[a-z,A-Z,0-9,_]"
        self._variable_re = r"[a-z,A-Z]+[a-z,A-Z,0-9,_]*"
        self.__operator = r"=|+|-|*|/|\(|\)|<"
        self.__data_item = r"0|1|2|3|4|5|6|7|8|9|\."
        self.__string = r'"'
        ## state process
        self._token_type_list = {
            "start" : self._start_of_line,
            "indent" : self._indent,
            "variable" : self._variable,
            "continue" : self._continue,
            "data" : self._data,
            }
    def analize_line(self, line):
        """analize lexcier by line."""
        self._line_state = "start"
        self._line_pointer = 0
        self.current_line = line
        for self._line_pointer, cchar in enumerate(line):
            if self._line_state == "end":
                break
            self._token_type_list[self._line_state](cchar)
    def _start_of_line(self, cchar):
        """start of line"""
        if cchar == ' ':
            self._line_state = "indent"
        elif cchar == '\n':
            self._line_state = "end"
            self.token.append(Token("nextline", None))
        elif cchar == '#':
            self._line_state = "end"
        elif re.fullmatch(self._alphabet_re, cchar):
            self._line_state = "variable"
            self._variable_start_pos = self._line_pointer
        else:
            raise Exception("unkown charactor: {}".format(cchar))
    def _indent(self, cchar):
        """the first string is empty"""
        if cchar == ' ':
            self._line_state = "indent"
        elif cchar == '\n':
            self._line_state = "end"
            self.token.append(Token("nextline", None))
        else:
            self._indent_end_pos = self._line_pointer
            if cchar == '#':
                self._line_state = "comments"
            elif re.fullmatch(self._alphabet_re, cchar):
                ##self.block.check_indent()
                self._line_state = "variable"
                self._variable_start_pos = self._line_pointer
            else:
                raise Exception("unkown charactor: {}".format(cchar))
    def _variable(self, cchar):
        """search a variable """
        if re.fullmatch(self._var_char_re, cchar):
            pass
        else:
            self._variable_stop_pos = self._line_pointer
            self.token.append(Token("variable", self.current_line[self._variable_start_pos:self._variable_stop_pos]))
            self._line_state = "continue"
            self._continue(cchar)
    def _data(self, cchar):
        """search a data"""
        if cchar in self.__data_item:
            pass
        else:
            self._data_stop_pos = self._line_pointer
            self.token.append(Token("data", self.current_line[self._data_start_pos:self._data_stop_pos]))
            self._line_state = "continue"
            self._continue(cchar)
    def _continue(self, cchar):
        """in the middle of a statement"""
        if cchar == ' ':
            self._line_state = "continue"
        elif cchar == '\n':
            self._line_state = "end"
            self.token.append(Token("nextline", None))
        elif cchar == '#':
            self._line_state = "comments"
        elif re.fullmatch(self._alphabet_re, cchar):
            self._line_state = "variable"
            self._variable_start_pos = self._line_pointer
        elif cchar in self.__data_item:
            self._line_state = "data"
            self._data_start_pos = self._line_pointer
        elif cchar in self.__operator:
            self._line_state = "continue"
            self.token.append(Token("operator", cchar))
        else:
            raise Exception("unkown charactor: {}".format(cchar))


class Program(object):
    """docstring for Program"""
    def __init__(self, arg):
        super(Program, self).__init__()
        self.arg = arg
        stmt

Bean_pattern = {
        'variable'      : r"[a-z,A-Z]+[a-z,A-Z,0-9,_]*",
        'data'          : r"\d+(.\d+)*",
        'operator'      : r"=|+|-|*|/|\(|\)|$=",
        'comments'      : r'\n#',
        'return'        : r"\n",
        }


KEY_WORDS = ["if", "else", "while", "exit", "end"]

Bean_TOKEN = '|'.join('(?P<%s>%s)' % item for item in Bean_pattern.items())



def bean_lexier(contents):
    """analyse Bean command and data pattern, return a list."""
    for one_pattern in re.finditer(Bean_TOKEN, contents):
        lexical_type = one_pattern.lastgroup
        lexical_str = one_pattern.group(lexical_type)
        yield (lexical_type, lexical_str)

def convert_bai_to_bmh(in_file, out_file):
    """convert Bean to a binary string file for initial the memory when simulating the verilog."""
    with open(in_file, 'r') as fin:
        all_content = fin.read()
    with open(out_file, 'w') as fout:
        #fout.writelines(["{}\n".format(x) for x in analyse_bmi_patter(all_content)])
        fout.writelines([x for x in analyse_bai_pattern(all_content)])

ROOT = os.path.dirname(os.path.realpath(__file__))
def parse_check_file_type(string):
    """check if it is a file or directory"""
    if os.path.isfile(string):
        return string
    else:
        raise argparse.ArgumentTypeError("{} is not a file".format(string))

## environment parse

#PARSER = argparse.ArgumentParser(description='Bean assembly instruction compiler.')
#PARSER.add_argument('input_file',
#                    type=parse_check_file_type,
#                    help='single input file or all .bba files in a directory.')
#PARSER.add_argument('-o', metavar='output directory', dest='output_file',
#                    help='single output file or directory.')
#
#ARGS = PARSER.parse_args()
#
#CONFIG = configparser.ConfigParser()
#CONFIG.read(join(ROOT, 'config.ini'))

def convert_file(fone, fout):
    """ compile one file """
    if os.stat(fone).st_size > int(CONFIG['DEFAULT']['Bean_file_size']):
        raise Exception("File size exceeds the limitation.")
    if fone.endswith('bai'):
        convert_bai_to_bmh(fone, fout)
    else:
        raise Exception("file type error.")

def bean_parser(args):
    """main process, parse one single file."""
    if args.output_file is None:
        toutput_file = "{}bao".format(args.input_file[0:-3])
    convert_file(args.input_file, toutput_file)


if __name__ == "__main__":
    print("bean_parser.py")
