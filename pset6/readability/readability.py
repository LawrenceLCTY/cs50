print("Text: ", end = "")
txt = input().lower()
l = 0
w = 1
s = 0
for t in txt:
    if t >= 'a' and t <= 'z':
        l += 1
    elif t == " ":
        w += 1
    elif t in ['.', '?', '!']:
        s += 1

ix = round(0.0588 * l * 100 / w - 0.296 * s * 100 / w - 15.8)
if ix < 1:
    print("Before Grade 1")
elif ix >= 16:
    print("Grade 16+")
else:
    print("Grade", ix)
