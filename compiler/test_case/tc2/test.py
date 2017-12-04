import sys
sys.path.append("D:/lhy/project/black_bean/compiler")
import tokenizer
import lexer_token_view as ltv
import lexer_assembly_view as lav
#from bean_parser import LineTokenizer

class testClass:
    def setup(self):
        pass
    def tearDown(self):
        pass
    def test_c1(self):
        lt = tokenizer.LineTokenizer()
        with open("tc.b", 'r') as fin:
            for x in fin.readlines():
                lt.analize_line(x)
        #for token in lt.token_list:
            #print(token.ttype, ';', token.tvalue)
        tv = ltv.TokenLexer(lt.token_list)
        for stmt in sv.stmt_list:
            print(stmt._type)
        for token in sv.stmt_list[0].expr.atom_list:
            print(token)
            print(token.od0.ttype, token.od0.tvalue)
        av = lav.AssemblyLexer(tv)
        print()
        #lx = lexer.BeanLexer()
        #lx.analyse_morphology(lt.token_list)
        #print(lx.stmt_list)
        pass

#lt = bp.LineTokenizer("h")
#with open("tc.b", 'r') as fin:
#    for x in fin.readlines():
#        lt.analize_line(x)
#print(lt.token)
