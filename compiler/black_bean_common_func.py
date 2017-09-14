#! $PATH/python

# file name: black_bean_common_func.py
# author: lianghy
# time: 2017-8-4 17:18:11
"""There are some common functions."""

def hex_str(width, int_num):
    """convert a int type number to hexadecimal string type.
    For example, convert 10 to 0a"""
    return hex(int_num)[2:].rjust(width, '0')

def verilog_number_to_binary_string(vstr):
    """convert a verilog number such as 8'h9a to a binary string as 10011010."""
    try:
        tvlist = vstr.split("'h")
        tvalue = bin(int('0x'+tvlist[1], base=16))
    except:
        raise Exception("a wrong data type: {}".format(vstr))
    if len(tvalue[2:]) <= int(tvlist[0]):
        tnew = tvalue[2:].rjust(int(tvlist[0]), '0')
    else:
        tnew = tvalue[-1*int(tvlist[0]):]
    return tnew

def verilog_number_to_hexadecimal_string(vstr):
    """convert a verilog number such as 8'h9a to a binary string as 9a."""
    try:
        tvlist = vstr.split("'h")
    except:
        raise Exception("a wrong data type: {}".format(vstr))
    bit_len = int(int(tvlist[0])/4)
    if len(tvlist[1]) <= bit_len:
        tnew = tvlist[1].rjust(bit_len, '0')
    else:
        tnew = tvlist[-1*bit_len:]
    return tnew

if __name__ == "__main__":
    print("black_bean_common_func.py")
