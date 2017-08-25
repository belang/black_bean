
machine_instruction = {
        'reset'                   :   "00",
        'continue'                :   "01",
        'empty'                   :   "02",
        'jump_directly'           :   "03",
        'jump_condition'          :   "04",
        'write_memory'            :   "05",
        'read_memory_to_bus_0'    :   "06",
        'read_memory_to_bus_1'    :   "07",
        'next_ins_to_bus_0'       :   "08",
        'next_ins_to_bus_1'       :   "09",
        'result_of_bus_0'         :   "0a",
        'result_of_bus_1'         :   "0b"
}

assemble_pattern = {
        'null'                  :   r'\s*'                          ,
        'comments'              :   r'^#'                           ,
        'label_ref'             :   r'^lable_[a-z0-9]+ [a-f0-9]+'         ,
        'quote_lable'           :   r'^[a-z0-9_]+ lable_[a-z0-9]+'   ,
        'normal_ins'            :   r'[a-z0-9_]+'
        }
