#! $PATH/python

# file name: change_syntex.py
# author: lianghy
# time: 2016-8-30 14:15:04

import os

source_type = 'wiki'
target_type = 'md'
dirlist = ['.']
for dirpath, dirnames, filenames in os.walk('.'):
    for one_file in filenames:
        if one_file[-1*len(source_type):] == source_type:
            new_file = os.path.join(dirpath,
                    one_file[:-1*len(source_type)]+target_type)
            print("rename {} to {}".format(one_file,new_file))
            os.rename(os.path.join(dirpath,one_file), new_file)

if __name__=="__main__":
    print("change_syntex.py")
