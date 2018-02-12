#! $PATH/python

# file name: device.py
# author: lianghy
# time: 2018/1/16 17:06:58

"""mircocontroller device program in python."""

from lib import draft

ALU = {"counter" : "0xf0"
        }
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

class Counter(object):
    """Counter: 
        set dr0 xx
        set dr1 xx
        set cr  ALU["counter"]"""
    def __init__(self, draft):
        super(Counter, self).__init__()
        self.draft = draft
    def set(self, dr0=0, dr1=0):
        """docstring for set"""
        
        

mc = MicroController()
counter = Counter(draft)

if __name__ == "__main__":
    print("device.py")
