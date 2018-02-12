#! $PATH/python

# file name: bean_parser.py
# author: lianghy
# time: 2018/2/6 15:14:03
"""from token to assembly code with object."""

import logging
import bean_common_func as cf
import bean_lexer as lex


STMT_BLOCK_KEYS = ("if", "while", "else")
DEVICE = ("dr0", "dr1", "counter", "mc", "interrupt", "port1")
OP_REL = (">", "<", "==", ">=", "<=", "!=")
ALU = ("counter")
PORT_CODE = {
    "port0":"00",
    "port1":"01",
    "port2":"02",
    }
ALU_CODE = {
    "<" :"01",
    "==":"02",
    ">" :"03",
    "!<":"04",
    "!=":"05",
    "!>":"06",
    "true":"ff",
    "false":"00",
    "+":"10",
    "-":"11",
    "*":"12",
    "/":"13",
    "set_count":"20",
    "auto_count":"21",
    "trigger":"22",
    "reset_count":"23",
    "counter_out":"24"}

class PParser():
    """docstring for Parser"""
    def __init__(self):
        self._indent_level = 0
        self.assembly_code = []
        self._current_block = []
        self._line_count = 0 # same as current line
        self.code_list = []
        self._state = "newline"
    def __call__(self, token_list):
        for token in token_list:
            if self._state == "newline":
                self.state_newline(token)
            elif self._state == "nextline":
                self.state_nextline(token)
            elif self._state == "var":
                self.state_var(token)
            elif self._state == "end_block":
                self.state_end_block(token)
            elif self._state == "if":
                self.state_if(token)
            elif self._state == "condition_rel":
                self.state_condition_rel(token)
            elif self._state == "condition_right":
                self.state_condition_right(token)
            elif self._state == "else":
                self.state_else(token)
            elif self._state == "while":
                self.state_while(token)
            elif self._state == "dr0":
                self.state_dr0(token)
            elif self._state == "counter":
                self.state_counter(token)
            elif self._state == "mc":
                self.state_mc(token)
                #### next
            elif self._state == "port1":
                self.state_port1(token)
            else:
                raise Exception("Unkown state: {}, token value: {}, in line {}".format(
                    self._state, token.tvalue, token.line_num))
        self._indent_level = 0
        self.state_end_block(lex.Token(0, "end", "true"))

    ## code
    def add_code(self, code):
        """add one line code and increase line number"""
        self.code_list.append(code)
        self._line_count += 1

    def code_set_value(self, source, target):
        """move data: source is a token, and target is device name."""
        if source.ttype == "data":
            self.add_code("ROM {}".format(target))
            self.add_code(cf.verilog_number_to_hex(source.tvalue))
        elif source.tvalue == "interrupt":
            self.add_code("ROM PA")
            self.add_code(PORT_CODE["port0"])
            self.add_code("PD {}".format(target))
        elif source.tvalue == "counter":
            self.add_code("ROM CR")
            self.add_code(ALU_CODE["counter_out"])
            self.add_code("RE {}".format(target))
        else:
            raise Exception("Unkown token: {}, token value: {}, in line {}".format(
                source.ttype, source.tvalue, source.line_num))
    def code_set_dr0(self, token):
        """set dr0 as token value, token is a device."""
        if token.tvalue == "interrupt":
            self.add_code("ROM PA")
            self.add_code(PORT_CODE["port0"])
            self.add_code("PD DR0")
        elif token.tvalue == "counter":
            self.add_code("ROM CR")
            self.add_code(ALU_CODE["counter_out"])
            self.add_code("RE DR0")
        elif token.ttype == "data":
            self.add_code("ROM DR0")
            self.add_code(cf.verilog_number_to_hex(token.tvalue))
        else:
            raise Exception("Unkown token: {}, token value: {}, in line {}".format(
                token.ttype, token.tvalue, token.line_num))
    def code_set_cr(self, token):
        """set token value to dr0"""
        self.add_code("ROM CR")
        self.add_code(ALU_CODE[token.tvalue])
    def code_set_dr1(self, token):
        """set token value to dr1"""
        self.add_code("ROM DR1")
        self.add_code(cf.verilog_number_to_hex(token.tvalue))
    def code_condition_jump(self):
        """condition has been set, that is CR is set."""
        # in page position
        self.add_code("ROM PC")
        self.add_code("Lable")
        self.add_code("PC PC")
    def code_else(self):
        """docstring for self.code_else"""
        #set cr true
        #jump to end()
        #label the line for false condition of if.
        self.add_code("ROM PC")
        self.add_code("Lable")
        self.add_code("ROM CR")
        self.add_code("ff")
        self.add_code("PC PC")
        self.code_list[self._current_block.pop()["jump_addr"]] = cf.int_num_to_hex_str(self._line_count)
    def code_if_end(self):
        """docstring for code_if_end"""
        self.code_list[self._current_block.pop()["jump_addr"]] = cf.int_num_to_hex_str(self._line_count)
    def code_while_start(self):
        """docstring for code_while_start"""
        
    def code_while_end(self):
        """docstring for code_while_end"""
        while_block = self._current_block.pop()
        self.add_code("ROM PC")
        self.add_code(cf.int_num_to_hex_str(while_block["start_addr"]))
        self.add_code("ROM CR")
        self.add_code("00")
        self.add_code("PC PC")
        self.code_list[while_block["jump_addr"]] = cf.int_num_to_hex_str(self._line_count)

    # state
    def state_newline(self, token):
        """docstring for self.state_newline"""
        if token.ttype == "indent":
            if token.tvalue >= self._indent_level:
                self._state = "var"
            else:
                self._indent_level = token.tvalue
                self._state = "end_block"
                #self.state_end_block()
        else:
            raise Exception("lack indent in line {}, token is {}:{}".format(
                token.line_num, token.ttype, token.tvalue))
    def state_var(self, token):
        """docstring for self.state_var"""
        if token.ttype == "variable":
            if token.tvalue in STMT_BLOCK_KEYS:
                self._state = token.tvalue
            elif token.tvalue in DEVICE:
                self._state = token.tvalue
            else:
                raise Exception("NOT support token {} in line {}".format(
                    token.tvalue, token.line_num))
        else:
            raise Exception("not variable-- type:{}; value:{} in line {}".format(token.ttype, token.tvalue, token.line_num))
    def state_nextline(self, token):
        """docstring for self.state_nextline"""
        if token.ttype == "nextline":
            self._state = "newline"
        else:
            raise Exception("lack return in line {}, token is {}:{}".format(
                token.line_num, token.ttype, token.tvalue))
    def state_end_block(self, token):
        """docstring for self.state_end_block"""
        logging.debug("start end block, current indent is %s", self._indent_level)
        logging.debug(self._current_block)
        block_length = len(self._current_block)
        while block_length > 0:
            cblock = self._current_block[-1]
            if cblock["indent"] < self._indent_level:
                break
            else:
                if cblock["name"] == "if":
                    if token.tvalue == "else":
                        break
                    else:
                        self.code_if_end()
                elif cblock["name"] == "while":
                    self.code_while_end()
                else:
                    raise Exception("Unknown block")
            block_length = len(self._current_block)
        logging.debug(self._current_block)
        logging.debug("end end block")
        self._state = "var"
        if token.ttype != "end":
            self.state_var(token)
    def state_if(self, token):
        """docstring for self.state_if"""
        logging.debug("create if")
        logging.debug("current line is %s", self._line_count)
        self._current_block.append(
            {"name":"if",
             "indent":self._indent_level,
             "jump_addr":0})
        self._indent_level += 1
        if token.ttype == "variable":
            if token.tvalue in DEVICE:
                if token.tvalue == "dr0":
                    pass
                else:
                    self.code_set_dr0(token)
                self._state = "condition_rel"
            else:
                raise Exception("Unknown condition in line {}".format(token.line_num))
        else:
            raise Exception("Unknown condition in line {}".format(token.line_num))
    def state_condition_rel(self, token):
        """docstring for self.state_if"""
        if token.tvalue in OP_REL:
            self.code_set_cr(token)
            self._state = "condition_right"
        else:
            raise Exception("not a device in line {}".format(token.line_num))
    def state_condition_right(self, token):
        """docstring for self.state_if"""
        if token.ttype == "data":
            self._state = "nextline"
            self.code_set_dr1(token)
            self._current_block[-1]["jump_addr"] = self._line_count+1
            self.code_condition_jump()
        elif token.tvalue == "dr0":
            raise Exception("DR0 must be on the left side, in line {}".format(token.line_num))
        else:
            raise Exception("not a device in line {}".format(token.line_num))
        logging.debug(self._current_block)
        logging.debug("end if")
    def state_else(self, token):
        """docstring for self.state_else"""
        logging.debug("create else")
        logging.debug("current line is %s", self._line_count)
        if token.ttype == "nextline":
            self._state = "newline"
            self.code_else()
            self._current_block.append(
                {"name":"if",
                 "indent":self._indent_level,
                 "jump_addr":self._line_count-4})
            self._indent_level += 1
        else:
            raise Exception("Error of else in line {}".format(token.line_num))
        logging.debug(self._current_block)
        logging.debug("end else")
    def state_while(self, token):
        """state_while"""
        self._current_block.append(
            {"name":"while",
             "indent":self._indent_level,
             "start_addr":self._line_count,
             "jump_addr":0})
        self._indent_level += 1
        if token.ttype == "variable":
            if token.tvalue == "true":
                # while true
                self._state = "nextline"
                self.code_set_cr(lex.Token(0, "variable", "true"))
                self._current_block[-1]["jump_addr"] = self._line_count+1
                self.code_condition_jump()
            elif token.tvalue == "false":
                # while false
                self._state = "nextline"
                self.code_set_cr(lex.Token(0, "variable", "false"))
                self._current_block[-1]["jump_addr"] = self._line_count+1
                self.code_condition_jump()
            elif token.tvalue in DEVICE:
                # next compare with if and set jump back address
                if token.tvalue == "dr0":
                    pass
                else:
                    self.code_set_dr0(token)
                self._state = "condition_rel"
            else:
                raise Exception("Unknown condition in line {}".format(token.line_num))
        else:
            raise Exception("Unknown condition in line {}".format(token.line_num))

    ## device
    def state_counter(self, token):
        """docstring for self.state_counter"""
        if token.ttype == "data":
            self.add_code("ROM DR0")
            self.add_code(cf.verilog_number_to_hex(token.tvalue))
            self.add_code("ROM CR")
            self.add_code("20")
        elif token.tvalue in DEVICE:
            self.code_set_dr0(token)
            self.add_code("ROM CR")
            self.add_code("20")
        elif token.tvalue == "trigger":
            self.add_code("ROM CR")
            self.add_code("22")
        else:
            raise Exception("Unknown counter commond: {}, in line {}".format(token.tvalue, token.line_num))
        self._state = "nextline"

    def state_dr0(self, token):
        """docstring for self.state_dr0"""
        self._state = "nextline"
        if token.ttype == "data":
            self.add_code("ROM DR0")
            self.add_code(cf.verilog_number_to_hex(token.tvalue))
        elif token.tvalue in DEVICE:
            self.code_set_dr0(token)
        else:
            pass

    def state_mc(self, token):
        """This is setting the microcontroller."""
        if token.ttype == "data":
            self.add_code("ROM DR0")
            self.add_code(cf.verilog_number_to_hex(token.tvalue))
            self.add_code("ROM CR")
            self.add_code("20")
        elif token.tvalue == "reset":
            self.add_code("NULL PC")
            self.add_code("NULL PC")
            self.add_code("ROM CR")
            self.add_code("00")
            self.add_code("PC PC")
        else:
            pass
        self._state = "nextline"

    def state_port1(self, token):
        """This is setting the port1 output."""
        self.code_set_value(token, "PD")
        self.add_code("ROM PA")
        self.add_code("01")
        self._state = "nextline"

def parse(token_list):
    """main"""
    par = PParser()
    print("start parser")
    par(token_list)
    return par


if __name__ == "__main__":
    print("bean_parser.py")
