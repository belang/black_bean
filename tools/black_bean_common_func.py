#! $PATH/python

# file name: black_bean_common_func.py
# author: lianghy
# time: 2017-8-4 17:18:11
"""There are some common functions."""

def hex_str(width, int_num):
    """convert a int type number to hexadecimal string type.
    For example, convert 10 to 0a"""
    return hex(int_num)[2:].rjust(width, '0')

if __name__ == "__main__":
    print("black_bean_common_func.py")
