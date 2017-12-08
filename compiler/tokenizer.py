#! $PATH/python

# file name: tokenizer.py
# author: lianghy
# time: 2017/11/13 10:02:34
"""tokenizer: get token list from bean program by lines.
Usage::
    tn = LineTokenizer()
    for one_line in all_lines_of_program_file:
        tn_analize_line(one_line)
"""

import re

## Tokenizer #################################################
class Token():
    """docstring for Token"""
    def __init__(self, ttype, value):
        self._type = ttype
        self._value = value
        ## token type
        self.__token_type = ["variable", "data", "nextline", "operator", "indent"]
        self._new_token()
    def _new_token(self):
        """docstring for new_token"""
        if self._type == "indent":
            self._value = self._value//4

    @property
    def ttype(self):
        """get type"""
        return self._type
    @property
    def tvalue(self):
        """get value"""
        return self._value

class LineTokenizer(object):
    """docstring for LineTokenizer"""
    def __init__(self):
        super(LineTokenizer, self).__init__()
        self.token_list = []
        ### inner flag
        self._line_pointer = 0
        self._token_start_pos = 0
        self._line_state = "None"
        self._current_line = None
        ###### variable
        self.__reguler_expretion = {
            "alphabet":r"[a-z,A-Z]",
            "var_char":r"[a-z,A-Z,0-9,_]",
            "operator":r":|=|+|-|*|/|\(|\)|<",
            "data_item":r"0|1|2|3|4|5|6|7|8|9|\.",
            "string":r'"'
            }
        ## state process
        self._token_state_machine = {
            "idle" : self._state_idle,
            "indent" : self._state_indent,
            "first var": self._state_first_var,
            "variable" : self._state_variable,
            "next token" : self._state_next_token,
            "data" : self._state_data,
            }
    def analize_line(self, line):
        """analize lexcier by line."""
        print("start tokenlize.")
        self._line_state = "idle"
        self._line_pointer = 0
        self._current_line = line
        for self._line_pointer, cchar in enumerate(line):
            if self._line_state == "end line":
                break
            self._token_state_machine[self._line_state](cchar)
    def _state_idle(self, cchar):
        """start of line"""
        if cchar == ' ':
            self._line_state = "indent"
        else:
            self._state_first_var(cchar)
    def _state_indent(self, cchar):
        """the first string is empty"""
        if cchar == ' ':
            self._line_state = "indent"
        else:
            self.token_list.append(Token("indent", self._line_pointer))
            self._state_first_var(cchar)
    def _state_first_var(self, cchar):
        """the first variable"""
        self._line_state = "first var"
        if cchar == '\n' or cchar == '#':
            self.token_list.append(Token("nextline", None))
            self._line_state = "end line"
        else:
            if re.fullmatch(self.__reguler_expretion["alphabet"], cchar):
                self._line_state = "variable"
                self._token_start_pos = self._line_pointer
            else:
                print("current state: {}".format(self._line_state))
                print("current line: {}".format(self._current_line))
                print("current line position: {}".format(self._line_pointer))
                raise Exception("unkown charactor: {}".format(cchar))
    def _state_variable(self, cchar):
        """complete a variable """
        if re.fullmatch(self.__reguler_expretion["var_char"], cchar):
            pass
        else:
            self.token_list.append(Token("variable", self._current_line[self._token_start_pos:self._line_pointer]))
            self._line_state = "next token"
            self._state_next_token(cchar)
    def _state_next_token(self, cchar):
        """in the middle of a statement"""
        if cchar == ' ':
            self._line_state = "next token"
        elif cchar == '\n' or cchar == '#':
            self.token_list.append(Token("nextline", None))
            self._line_state = "end line"
        elif re.fullmatch(self.__reguler_expretion["alphabet"], cchar):
            self._line_state = "variable"
            self._token_start_pos = self._line_pointer
        elif cchar in self.__reguler_expretion["data_item"]:
            self._line_state = "data"
            self._token_start_pos = self._line_pointer
        elif cchar in self.__reguler_expretion["operator"]:
            self.token_list.append(Token("operator", cchar))
            self._line_state = "next token"
        else:
            raise Exception("unkown charactor: {}".format(cchar))
    def _state_data(self, cchar):
        """search a data"""
        if cchar in self.__reguler_expretion["data_item"]:
            pass
        else:
            self.token_list.append(Token("data", self._current_line[self._token_start_pos:self._line_pointer]))
            self._line_state = "next token"
            self._state_next_token(cchar)


if __name__ == "__main__":
    print("tokenizer.py")
