
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
        'data'          : r"\d+'h[a-c0-9]+",
        'command'       : r"ACTION_\w* ((UNIT_\w*)|(ALU_\w*))"
        }

BMI_map = {
        'ACTION_PAUSE'    : '00',
        'ACTION_WRITE'    : '01',
        'ACTION_READ_AR'  : '10',
        'ACTION_READ_PC'  : '11',
        'UNIT_NULL'       : '000000',
        'UNIT_IR'         : '000001',
        'UNIT_AR'         : '000010',
        'UNIT_DR0'        : '000011',
        'UNIT_DR1'        : '000100',
        'UNIT_CR'         : '000101',
        'UNIT_PC'         : '000110',
        'ALU_COMPARER'    : '100001',
        'ALU_JUMP_COND'   : '100010'
}

BMI_TOKEN_EX = '|'.join('(?P<%s>%s)' % item for item in BMI_pattern.items())
