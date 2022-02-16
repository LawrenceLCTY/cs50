while True:
    try:
        print("Change owed: ", end = "")
        c = float(input())
        if c >= 0:
            break
    except ValueError:
        continue

c = int(c * 100)
tot = c // 25
c %= 25
tot += c // 10
c %= 10
tot += (c // 5 + c % 5)
print(tot)