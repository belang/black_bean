#! $PATH/python

# file name: lib.py
# author: lianghy
# time: 2018/1/16 17:06:58

"""lib for mircocontroller program in python."""

class MicroController:
    """controller"""
    def __init__(self):
        self.code_list = []
    def generate_simu_file(self):
        """generate the files for verilog simulation"""
        pass
    def reset(self):
        """docstring for reset"""
        self.code_list.append()


if __name__ == "__main__":
    print("lib.py")
