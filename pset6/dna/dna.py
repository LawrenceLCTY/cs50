from csv import reader, DictReader
from sys import argv

#check usage
if len(argv) != 3:
    print("Usage: python dna.py data.csv.sequence.txt")
    exit()

#open and load dna row
with open(argv[2]) as dnafile:
    dnaread = reader(dnafile)
    for row in dnaread:
        dnalist = row

dna = dnalist[0]
sequence = {}

#open and load all dna data
with open(argv[1]) as pplfile:
    ppl = reader(pplfile)
    for row in ppl:
        data = row
        data.pop(0)
        break

for d in data:
    sequence[d] = 1

#compare and count longest STR
for key in sequence:
    length = len(key)
    maxc = 0
    count = 0
    for i in range(len(dna)):
        while count > 0:
            count -= 1
            continue

        if dna[i: i + length] == key:
            while dna[i - length: i] == dna[i: i + length]:
                i += length
                count += 1

            if maxc < count:
                maxc = count

    sequence[key] += maxc

#search mathing person
with open(argv[1], newline = '') as pplfile:
    ppl = DictReader(pplfile)
    for person in ppl:
        same = 0
        for dna in sequence:
            if sequence[dna] == int(person[dna]):
                same += 1
        if same == len(sequence):
            print(person['name'])
            exit()

    print("No match")


