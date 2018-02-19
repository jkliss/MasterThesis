import Bio.KEGG.REST
import time
import sys

def writeAll(outfile, list):
    for line in list:
        outfile.write(line)


input = sys.argv[-1]
file = open(input, "r")
out = open(input + ".conv", "w")

for module in file:
    module = module.strip("\n").split("\t")[0]
    data = ""
    try:
        data = Bio.KEGG.REST.kegg_link("genes", module).readlines()
    except:
        print(module + " http err")
    while len(data) < 1:
        try:
            data = Bio.KEGG.REST.kegg_link("genes", module).readlines()
        except:
            print(module + " http err")
            time.sleep(15)
        print(module + " redo")
        time.sleep(1)
    writeAll(out, data)
    out.flush()
out.flush()
out.close()
