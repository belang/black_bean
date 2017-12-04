#!/usr/bin/env python
# -*- coding: utf-8 -*-

import os
#sys.path.append('..')

class testClass:
    def setup(self):
        pass
    def tearDown(self):
        pass
    def test_c1(self):
        os.system("python tc_1.py")
        os.system("python ../../machine_instruction_parser.py tc_1.bmi")
        test_flag = 0
        with open("tc_1", 'r') as fexa, open("tc_1.bmi", 'r') as fbmi, open("tc_1.bmh", 'r') as fbmh:
            for line in fexa.readlines():
                if line=="\n":
                    if test_flag==0:
                        test_flag = 1
                    else:
                        test_flag = 2
                else:
                    if test_flag==0:
                        continue
                    elif test_flag==1:
                        assert line==fbmi.readline()
                    elif test_flag==2:
                        assert line==fbmh.readline()
                    else:
                        assert False

