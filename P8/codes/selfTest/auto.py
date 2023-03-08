import os
mips_code_path = "Exam01.asm"
mips_handler_path = "Exam01.asm"

def run_mars():
    os.system("java -jar Mars.jar nc a db mc CompactDataAtZero dump 0x00003000-0x0000417c HexText text.txt " + mips_code_path)
    os.system("java -jar Mars.jar nc a db mc CompactDataAtZero dump 0x00004180-0x00004f00 HexText ktext.txt " + mips_handler_path)
    with open(r"text.txt","r") as textfile:
        with open(r"ktext.txt","r") as ktextfile:
            with open(r"code.txt","w") as codefile:
                for i in range(0x3000,0x4180,4) :
                    ret1 =textfile.readline()
                    if(ret1):
                        codefile.write(ret1)
                    else:
                        codefile.write("00000000\n")
                codefile.write(ktextfile.read())
    os.remove("text.txt")
    os.remove("ktext.txt")

if __name__ == '__main__':
    run_mars()

    with open("code.txt", "r") as f:
        data = f.readlines()

    for i in range(len(data)):
        if i != len(data) - 1:
            data[i] = data[i][:-1] + ",\n"
        else:
            data[i] = data[i][:-1] + ";\n"

    with open(mips_code_path[:-3] + "coe", "w") as f:
        f.write("memory_initialization_radix=16;\nmemory_initialization_vector=\n")
        f.writelines(data)