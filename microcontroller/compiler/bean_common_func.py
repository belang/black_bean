#! $PATH/python

# file name: black_bean_common_func.py
# author: lianghy
# time: 2017-8-4 17:18:11
"""There are some common functions."""

def minus_data(int_str, width=8):
    """docstring for minus_data"""
    value = int(int_str)
    return data

def int_str_to_hex_str(int_str, width=8):
    """For example, convert 10 to 0a"""
    #data = int(int_str)
    #if data > 2**width:
        #raise Exception("data exceed: ", int_str)
    return hex(int(int_str))[2:].rjust(width//4, '0')

def int_num_to_hex_str(int_num, width=8):
    """convert a int type number to hexadecimal string type.
    For example, convert 10 to 0a"""
    return hex(int_num)[2:].rjust(width//4, '0')

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

def verilog_number_to_hex(vstr):
    """convert a verilog number such as 8'h9a to a hexadecimal string as 9a."""
    try:
        tvlist = vstr.split("'h")
    except:
        raise Exception("a wrong data type: {}".format(vstr))
    bit_len = int(int(tvlist[0])/4)
    if len(tvlist[1]) <= bit_len:
        tnew = tvlist[1].rjust(bit_len, '0')
    else:
        tnew = tvlist[1][-1*bit_len:]
    return tnew

def int_str_to_verilog_hex(vstr, width=8):
    """10 to 8'h0a"""
    return "{}'h{}".format(width, hex(vstr)[2:].rjust(width//4, '0'))

if __name__ == "__main__":
    print("black_bean_common_func.py")
