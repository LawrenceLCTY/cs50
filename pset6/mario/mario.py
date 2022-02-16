while True:
    try:
        print("Height:", end = "")
        h = int(input())
        if h >= 1 and h <= 8:
            break
    except ValueError:
        continue

for i in range(1, h + 1):
    print(" " * (h-i) + "#" * (i)) #+ "  " + "#" * (i))