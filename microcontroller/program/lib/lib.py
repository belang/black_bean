#! $PATH/python

# file name: lib.py
# author: lianghy
# time: 2018/1/15 14:22:37

"""lib for microcontroller"""

import bean

class Couter:
    def __init__(self):
        """counter"""
        self.code_list = []
    def set(self, start=0, stop=0):
        """set"""
        code_list = []
        if isinstance(start, int):
            # immediate data
            code_list.append("ROM DR0")
            code_list.append(hex(start))
        elif isinstance(start, str):
            if start.startswith('0x'):
                # data memory address
                code_list.append("ROM DR0")
                code_list.append(start)
            elif ns.has_var(start):
                # variable name
                code_list.append(load(start, "DR0"))
            else:
                raise Exception("unknow string: {}".format(start))
        else:
            raise Exception("unknow counter start value: {}".format(start))
        if isinstance(stop, int):
            # immediate data
            code_list.append("ROM DR0")
            code_list.append(hex(stop))
        elif isinstance(stop, str):
            if stop.startswith('0x'):
                # data memory address
                code_list.append("ROM DR0")
                code_list.append(stop)
            elif ns.has_var(stop):
                # variable name
                code_list.append(load(stop, "DR0"))
            else:
                raise Exception("unknow string: {}".format(stop))
        else:
            raise Exception("unknow counter stop value: {}".format(stop))


if __name__ == "__main__":
    print("lib.py")

