import Bio.KEGG.REST
import sys

def writeAll(outfile, list):
    for line in list:
        outfile.write(line)


def checkComplete(buffer, result):
    split = buffer.split("+")
    if protSeqAvail(buffer):
        notFound = []
        for i in split:
            fnd = 0
            for line in result:
                if i in line:
                    fnd = 1
                    break
            if fnd == 0:
                if protSeqAvail(i):
                    notFound.append(i)
        return notFound
    else:
        return []


def protSeqAvail(identifier):
    try:
        genedata = Bio.KEGG.REST.kegg_get(identifier)
        for i in genedata:
            if "AASEQ" in i:
                return True
        return False
    except:
        print("REST ERROR" +identifier)
        pass
        return True


input = sys.argv[-1]
file = open(input, "r")
out = open(input+".seq", "w")
missing = open(input+".seq.missing", "w")

buffer = ""
buffer_count = 0

missingX = []

for line in file:
    id = line.replace("\n", "")
    if(buffer_count == 0):
        buffer_count += 1
        buffer += id
    elif(buffer_count < 9):
        buffer_count += 1
        buffer += "+" + id
    else:
        try:
            data = Bio.KEGG.REST.kegg_get(buffer, "aaseq")
            result = data.readlines()
            unfound = checkComplete(buffer, result)
            for element in unfound:
                missingX.append(element)
            writeAll(out, result)
        except:
            missing.write(buffer + "\n")
            pass
        buffer = ""
        buffer_count = 0
        out.flush()

try:
    data = Bio.KEGG.REST.kegg_get(buffer, "aaseq")
    result = data.readlines()
    unfound = checkComplete(buffer, result)
    for element in unfound:
        missingX.append(element)
    writeAll(out, data)
except:
    missing.write(buffer + "\n")
    pass
out.close()

### SEARCH MISSING
for x in missingX:
    try:
        data = Bio.KEGG.REST.kegg_get(x, "aaseq")
        result = data.readlines()
        while len(result) < 1:
            data = Bio.KEGG.REST.kegg_get(x, "aaseq")
            result = data.readlines()
        writeAll(out, result)
    except:
        print("REST ERROR:" + x)
        pass
