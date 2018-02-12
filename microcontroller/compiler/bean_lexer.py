#! $PATH/python

# file name: lexer.py
# author: lianghy
# time: 2017/11/13 10:02:34
"""tokenizer: get token list from bean program by lines.
Usage::
    tn = LineTokenizer()
    for one_line in all_lines_of_program_file:
        tn_analize_line(one_line)
"""

import re
import logging
import bean_common_func as cf
import bean_language


## Tokenizer #################################################
class Token():
    """docstring for Token"""
    def __init__(self, line_num, ttype, value=None):
        self.line_num = line_num
        self._type = ttype
        logging.debug("new token: %s %s .", ttype, value)
        try:
            self._value = "".join(value)
        except TypeError:
            self._value = None
        ## token type
        self.__token_type = ["variable", "data", "nextline", "operator", "indent"]
        self._new_token()
    def _new_token(self):
        """docstring for new_token"""
        if self._type == "indent":
            self._value = len(self._value)//4
        elif self._type == "data":
            if "h" in self._value:
                pass
            else:
                self._value = cf.int_str_to_hex_str(self._value)
        elif self._type == "operator":
            if self._value not in bean_language.OPERATOR:
                raise Exception("Unkown operator {}, in line {}".format(self._value, self.line_num))
        else:
            pass

    @property
    def ttype(self):
        """get type"""
        return self._type
    @property
    def tvalue(self):
        """get value"""
        return self._value

class Lexer():
    """docstring for Lexer"""
    def __init__(self):
        super(Lexer, self).__init__()
        self._token_state_machine = {
            "newline" : self._state_newline,
            "next" : self._state_next_token,
            "comment" : self._state_comment,
            "variable" : self._state_variable,
            "data" : self._state_data,
            "operator" : self._state_operator,
            }
        self.token_list = []
        self._line_num = 1
        ### inner flag
        self._cache_string = []
        self._state = "newline"
        ###### variable
        self.__single_char_class = {
            "alphabet":r"[a-z,A-Z]",
            "var_char":r"[a-z,A-Z,0-9,_]",
            "operator":r"[=,\+,-,\*,/,<,!]",
            "number":r"[0-9]",
            "dot":r"\.",
            "left_parenthesis":r"\(",
            "right_parenthesis":r"\)",
            "data_item":r"0|1|2|3|4|5|6|7|8|9|'|h|a|b|c|d|e|f",
            "string":r'"'
            }
    def __call__(self, chars):
        """docstring for __call__"""
        for char in chars:
            self._token_state_machine[self._state](char)
    def _state_newline(self, char):
        """start of line"""
        if char == '#':
            self._state = "comment"
        elif char == ' ':
            self._cache_string.append(" ")
        elif char == '\n':
            self._line_num = self._line_num+1
        else:
            self.token_list.append(Token(self._line_num, "indent", self._cache_string))
            self._cache_string.clear()
            self._state_next_token(char)
            self._state = "next"
    def _state_comment(self, char):
        """docstring for _state_comment"""
        if char == "\n":
            self._line_num = self._line_num+1
            self._state = "newline"
            self._cache_string.clear()
    def _state_variable(self, char):
        """complete a variable """
        if re.fullmatch(self.__single_char_class["var_char"], char) is None:
            self.token_list.append(Token(self._line_num, "variable", self._cache_string))
            self._cache_string.clear()
            self._state = "next"
            self._state_next_token(char)
        else:
            self._cache_string.append(char)
    def _state_data(self, char):
        """search a data"""
        if char not in self.__single_char_class["data_item"]:
            self.token_list.append(Token(self._line_num, "data", self._cache_string))
            self._cache_string.clear()
            self._state = "next"
            self._state_next_token(char)
        else:
            self._cache_string.append(char)
    def _state_operator(self, char):
        """search an operator"""
        if re.fullmatch(self.__single_char_class["operator"], char) is None:
            self.token_list.append(Token(self._line_num, "operator", self._cache_string))
            self._cache_string.clear()
            self._state = "next"
            self._state_next_token(char)
        else:
            self._cache_string.append(char)
    def _state_next_token(self, char):
        """in the middle of a statement"""
        if char == ' ':
            pass
        elif char == '\n':
            self._state = "newline"
            self.token_list.append(Token(self._line_num, "nextline", None))
            self._line_num = self._line_num+1
            self._cache_string.clear()
        elif char == '#':
            self._state = "comment"
        elif re.fullmatch(self.__single_char_class["alphabet"], char):
            self._state = "variable"
            self._state_variable(char)
        elif re.fullmatch(self.__single_char_class["number"], char):
            self._state = "data"
            self._state_data(char)
        elif re.fullmatch(self.__single_char_class["operator"], char):
            self._state = "operator"
            self._state_operator(char)
        elif char == r"\.":
            self.token_list.append(Token(self._line_num, "dot", None))
        elif char == r"\(":
            self.token_list.append(Token(self._line_num, "left_parenthesis", None))
        elif char == r"\)":
            self.token_list.append(Token(self._line_num, "right_parenthesis", None))
        else:
            raise Exception("unkown charactor: {}, in line {} with former token {}".format(
                char, self.token_list[-1].line_num, self.token_list[-1].tvalue))


def analyze(chars):
    """analize lexcier by line."""
    lex = Lexer()
    print("start tokenlize.")
    lex(chars)
    return lex

if __name__ == "__main__":
    print("lexer.py")
