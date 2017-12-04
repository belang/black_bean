#! $PATH/python

# file name: tc_1.py
# author: lianghy
# time: 2017-9-22 16:12:36

import sys

sys.path.append("E:/project/black_bean/compiler")
from assembly_parser import AssemblyParser as ap

tc1 = ap()

tc1.let('DR0',"8'h01")
tc1.set_block('a')
tc1.add1()
tc1.jump('a')
tc1.generate_BMI('tc_1.bmi')

if __name__ == "__main__":
    print("tc_1.py")
