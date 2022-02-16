from cs50 import SQL
from sys import argv

if len(argv) != 2:
    print("Usage: python roster.py houses")

db = SQL("sqlite:///students.db")
students = db.execute("SELECT * FROM students WHERE house = ? ORDER BY last, first", argv[1])

for s in students:
    if s['middle'] == None:
        s['middle'] = ''
    else:
        s['middle'] += " "

    print(f"{s['first']} {s['middle']}{s['last']}, born {s['birth']}")
