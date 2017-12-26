#! $PATH/python

# file name: bean_language.py
# author: lianghy
# time: 2017/12/14 10:59:12

"""
global config of language
"""

COMPARE_OPERATOR = (">", "<", "=", ">=", "<=", "!=", "==")
OPERATOR_ORDER = {"+":1, "-":1, "*":2, "/":2, "**":3}
OPERATOR = ("+", "-", "*", "/", "**", ">", "<", "=", ">=", "<=", "!=", "==")
OP_CODE = {
    "<" :"01",
    "=" :"02",
    ">" :"03",
    ">=":"04",
    "!=":"05",
    "<=":"06",
    "+":"11",
    "-":"12",
    "*":"13",
    "/":"14",
    }

if __name__ == "__main__":
    print("bean_language.py")
