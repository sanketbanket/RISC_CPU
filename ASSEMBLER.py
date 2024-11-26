from sys import argv

opcodes = {
    "ADD" : "0001",
    "SUB" : "0010",
    "OR" : "0011",
    "AND" : "0100",
    "NOT" : "0101",
    "JMP" : "0110",
    "LD" : "0111",
    "STR" : "1000",
    "CMP" : "1001",
    "MOV" : "1011",
    "MOVI" : "1100",
    "SKIP" : "1010",
    "STRPC" : "1101",
    "LDPC" : "1110",
    "HALT" : "1111"
}
cds = {
    "EQ" : "000",
    "NE" : "111",
    "LT" : "010",
    "LE" : "011",
    "GT" : "100",
    "GE" : "101"
}

def convert(code : str):
    words = code.split()
    #print(words)
    out = ""
    try : out = "16'b"+opcodes[words[0].upper()]
    except KeyError : 
        print("wrong instruction", words[0])
        return ""

    n = int(opcodes[words[0].upper()], 2)
    if n in [1, 2, 3, 4 ]:  #handle 3 regs
        a = int(words[1][1:])
        b = int(words[2][1:])
        c = int(words[3][1:])

        out += "_000"
        out += "_" + f"{a:03b}" +"_" +  f"{b:03b}" + "_" + f"{c:03b}"
        return out
    
    if n in [5, 7, 8, 11]  and words[2][0] != '#': #handle 2 regs
        a = int(words[1][1:])
        b = int(words[2][1:])

        out += "_000"
        out += "_" + f"{a:03b}" +"_" +  f"{b:03b}" + "_" + "000"

        return out
    if n == 9 :
        a = int(words[1][1:])
        b = int(words[2][1:])
        out += "_000"
        out += "_000_" + f"{a:03b}" + "_" + f"{b:03b}"
        return out 
    if n in [6, 13, 14]:
        a = int(words[1][1:])
        out += "_000"
        out += "_" + f"{a:03b}" +"_000_000"
        return out

    if n == 15 : 
        out += "_000_000_000_000"
        return out
    
    if n == 12 or (n == 11 and words[2][0] == "#"):  #mov immediate
        out = "16'b1100"
        out += "_000"
        a = int(words[1][1:])
        out += "_" + f"{a:03b}" + "_000_000"
        num = int(words[2][1:])
        if(num < 0) : 
            num += (1<<16)
        num = f"{num:016b}"
        num = "16'b" + num[0:4] + "_" + num[4 : 8] + "_" + num[8 : 12] + "_" + num[12 :]

        return out, num
    if n == 10:  #skip if true
        out += "_" + cds[words[1].upper()]
        out += "_000_000_000"
        return out

    return ""


if __name__ == "__main__":

    filein = argv[1]
    #fileout = argv[2]
    with open(filein, 'r') as f:
        lines = f.readlines()
        f.close()

    lines = [x[:-1] if x[-1] == '\n' else x for x in lines ]
    lines = [x for x in lines if len(x) > 0]

    for i, j in enumerate(lines):
        a = j.find('%')
        if j.find('%') != -1:
            nocomment = j[:a]
            if(nocomment.count(' ') == len(nocomment)):
                lines[i] = ''
            else :
                lines[i] = nocomment
    lines = [x for x in lines if len(x) > 0]


    pc = 0
    output = []
    for i in lines : 
        x = convert(i)
        temp = "" 
        if(len(x) == 2):
            temp = f"ram[{pc}]" + " = " + x[0]
            output.append(temp + f"  ; //{i}")

            temp = f"ram[{pc + 1}]" " = " + x[1]
            output.append(temp + ';')
        else :
            temp = f"ram[{pc}]" + " = " + x
            output.append(temp + f"  ; //{i}")
        pc += 2
    for i in output:
        print(i)

    if(len(argv) > 2) : 
        with open(argv[2]+'.txt', 'w') as f:
            for i in output:
                f.write(i + "\n")
            f.close()