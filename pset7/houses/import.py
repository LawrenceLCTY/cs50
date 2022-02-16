from cs50 import SQL
from sys import argv
from csv import reader

if len(argv) != 2:
    print("Usage: python import.py characters.csv")
    exit()

db = SQL("sqlite:///students.db")

with open(argv[1], newline = '') as file:
    chars = reader(file)
    for c in chars:
        if c[0] != "name":
            fname = c[0].split()
            if len(fname) == 2:
                mid = None
                last = fname[1]
            else:
                mid = fname[1]
                last = fname[2]
            db.execute("INSERT INTO students(first, middle, last, house, birth) VALUES(?,?,?,?,?)", fname[0], mid, last, c[1], c[2])
