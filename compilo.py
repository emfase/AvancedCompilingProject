import lark

grammaire = lark.Lark(r"""
exp : SIGNED_NUMBER              -> exp_nombre
| IDENTIFIER                     -> exp_var
| IDENTIFIER "." IDENTIFIER      -> exp_var_struct
| exp OPBIN exp                  -> exp_opbin
| "(" exp ")"                    -> exp_par
| IDENTIFIER "(" var_list ")"    -> exp_function
com : dec                        -> declaration
| IDENTIFIER "=" exp ";"         -> assignation
| IDENTIFIER "." IDENTIFIER "=" exp ";" -> assignation_struct_var
| "if" "(" exp ")" "{" bcom "}"  -> if
| "while" "(" exp ")" "{" bcom "}"  -> while
| "print" "(" exp ")" ";"              -> print
| "printf" "(" exp ")" ";"             -> printf
| IDENTIFIER "(" exp_list ")" ";"
bdec : (dec)*
bcom : (com)*
dec : TYPE IDENTIFIER ";" -> declaration
| TYPE IDENTIFIER "=" exp ";" -> declaration_expresion
| "struct" IDENTIFIER IDENTIFIER ";" -> declaration_struct
struct : "struct" IDENTIFIER "{" bdec "}" ";"
function : TYPE IDENTIFIER "(" var_list ")" "{" bcom "return" exp ";" "}" 
| "void" IDENTIFIER "(" var_list ")" "{" bcom "}" 
bstruct : (struct)*
bfunction : (function)*
prg : bstruct bfunction "int" "main" "(" var_list ")" "{" bcom "return" "(" exp ")" ";"  "}"
exp_list: -> vide
| exp ("," exp)*  -> aumoinsune
var_list :                       -> vide
| (TYPE IDENTIFIER) | ("struct" IDENTIFIER IDENTIFIER) ("," (TYPE IDENTIFIER) | ("struct" IDENTIFIER IDENTIFIER))*  -> aumoinsune
IDENTIFIER : /[a-zA-Z][a-zA-Z0-9]*/
TYPE : "int" | "double" | "float" | "bool" | "char" | "long" | "struct" IDENTIFIER
OPBIN : /[+\-*>]/
%import common.WS
%import common.SIGNED_NUMBER
%ignore WS
""",start="prg")

op = {'+' : 'add', '-' : 'sub'}

def asm_exp(e):
    if e.data == "exp_nombre":
        return f"mov rax, {e.children[0].value}\n"
    elif e.data == "exp_var":
        return f"mov rax, [{e.children[0].value}]\n"
    elif e.data == "exp_par":
        return asm_exp(e.children[0])
    else:
        E1 = asm_exp(e.children[0])
        E2 = asm_exp(e.children[2])
        return f"""
        {E2}
        push rax
        {E1}
        pop rbx
        {op[e.children[1].value]} rax, rbx
        """

def pp_exp(e):
    if e.data in {"exp_nombre", "exp_var"}:
        return e.children[0].value
    elif e.data == "exp_par":
        return f"({pp_exp(e.children[0])})"
    else:
        return f"{pp_exp(e.children[0])} {e.children[1].value} {pp_exp(e.children[2])}"

def vars_exp(e):
    if e.data  == "exp_nombre":
        return set()
    elif e.data ==  "exp_var":
        return { e.children[0].value }
    elif e.data == "exp_par":
        return vars_exp(e.children[0])
    else:
        L = vars_exp(e.children[0])
        R = vars_exp(e.children[2])
        return L | R

cpt = 0
def next():
    global cpt
    cpt += 1
    return cpt

def asm_com(c):
    if c.data == "assignation":
        E = asm_exp(c.children[1])
        return f"""
        {E}
        mov [{c.children[0].value}], rax        
        """
    elif c.data == "if":
        E = asm_exp(c.children[0])
        C = asm_bcom(c.children[1])
        n = next()
        return f"""
        {E}
        cmp rax, 0
        jz fin{n}
        {C}
fin{n} : nop
"""
    elif c.data == "while":
        E = asm_exp(c.children[0])
        C = asm_bcom(c.children[1])
        n = next()
        return f"""
        debut{n} : {E}
        cmp rax, 0
        jz fin{n}
        {C}
        jmp debut{n}
fin{n} : nop
"""
    elif c.data == "print":
        E = asm_exp(c.children[0])
        return f"""
        {E}
        mov rdi, fmt
        mov rsi, rax
        call printf
        """

def pp_com(c):
    if(c.data == "declaration"):
        print("Declaration")
    elif c.data == "assignation":
        return f"{c.children[0].value} = {pp_exp(c.children[1])};"
    elif c.data == "if":
        x = f"\n{pp_bcom(c.children[1])}"
        return f"if ({pp_exp(c.children[0])}) {{{x}}}"
    elif c.data == "while":
        x = f"\n{pp_bcom(c.children[1])}"
        return f"while ({pp_exp(c.children[0])}) {{{x}}}"
    elif c.data == "print":
        return f"print({pp_exp(c.children[0])})"


def vars_com(c):
    if c.data == "assignation":
        R = vars_exp(c.children[1])
        return {c.children[0].value} | R
    elif c.data in {"if", "while"}:
        B = vars_bcom(c.children[1])
        E = vars_exp(c.children[0]) 
        return E | B
    elif c.data == "print":
        return vars_exp(c.children[0])

def asm_bcom(bc):
    return "".join([asm_com(c) for c in bc.children])

def pp_bcom(bc):
    return "\n".join([pp_com(c) for c in bc.children])

def vars_bcom(bc):
    S = set()
    for c in bc.children:
        S = S | vars_com(c)
    return S

def pp_var_list(vl):
    return ", ".join([t.value for t in vl.children])

def asm_prg(p):
    f = open("moule.asm")
    moule = f.read()
    C = asm_bcom(p.children[1])
    moule = moule.replace("BODY", C)
    E = asm_exp(p.children[2])
    moule = moule.replace("RETURN", E)
    D = "\n".join([f"{v} : dq 0" for v in vars_prg(p)])
    moule = moule.replace("DECL_VARS", D)
    s = ""
    for i in range(len(p.children[0].children)):
        v = p.children[0].children[i].value
        e = f"""
        mov rbx, [argv]
        mov rdi, [rbx + { 8*(i+1)}]
        xor rax, rax
        call atoi
        mov [{v}], rax
        """
        s = s + e
    moule = moule.replace("INIT_VARS", s)    
    return moule

def vars_prg(p):
    L = set([t.value for t in p.children[0].children])
    C = vars_bcom(p.children[1])
    R = vars_exp(p.children[2])
    return L | C | R

def pp_prg(p):
    L = pp_var_list(p.children[0])
    C = pp_bcom(p.children[1])
    R = pp_exp(p.children[2])
    return "main( %s ) { %s return(%s);\n}" % (L, C, R)

def pp_struct(s):
    print(s)

def pp_dec(d):
    print(d)

def pp_bdec(bdec):
    print(bdec)

def pp_function(f):
    print(f)

ast = grammaire.parse("""
struct Books {
   char  title;
   char  author;
   char  subject;
   int   bookId;
};

void printBook( struct Books book ) {

   printf( book.title);
   printf( book.author);
   printf( book.subject);
   printf( book.bookId);
}

int main( ) {

   struct Books Book1;        
   struct Books Book2;        
   Book1.bookId = 6495407;
   Book2.bookId = 6495700;
 
   printBook( Book1 );

   printBook( Book2 );

   return (0);
}
""")
asm = pp_dec(ast)
print(asm)
#f = open("ouf.asm", "w")
#f.write(asm)
#f.close()

