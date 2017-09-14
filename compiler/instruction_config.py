
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

BMI_pattern = {
        'return'        : r"\n",
        'data'          : r"\d+'h[a-c0-9]+",
        'command'       : r"(CORE_\S*)|(IOSC_\S*)|(ALU_\S*)"
        }

BMI_map = {
        'CORE_NULL'       : '0',
        'CORE_IR'         : '1',
        'CORE_PC'         : '2',
        'CORE_AR'         : '3',
        'CORE_DR0'        : '4',
        'CORE_DR1'        : '5',
        'CORE_CR'         : '6',
        'CORE_EMPTY'      : '7',
        'ALU_RE'          : '8',
        'ALU_AD'          : '9',
        'CORE_EMPTY'      : 'a',
        'CORE_EMPTY'      : 'b',
        'IOSC_INS_PC'     : 'c',
        'IOSC_INS_AR'     : 'd',
        'IOSC_OTH'        : 'e',
        'IOSC_NULL'       : 'f'

}

BMI_TOKEN_EX = '|'.join('(?P<%s>%s)' % item for item in BMI_pattern.items())
