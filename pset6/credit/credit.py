while True:
    try:
        print("Number: ", end = "")
        card = int(input())
        if card > 0:
            card = str(card)
            break
    except ValueError:
        continue

#reverse to calculate from 'behind'
card = card[::-1]
tot = 0
for i in range(len(card)):
    if i % 2 == 1:
        tot += ((int(card[i]) * 2 // 10) + (int(card[i]) * 2 % 10))
    else:
        tot += int(card[i])

#reverse again to check 'front' numbers
card = card[::-1]
if tot % 10 == 0:
    if len(card) == 15 and card[0:2] in ['34', '37']:
        print("AMEX")
    elif len(card) == 16 and card[0:2] in ['51', '52', '53', '54', '55']:
        print("MASTERCARD")
    elif len(card) in range(13,17) and card[0] == '4':
        print("VISA")
    else:
        print("INVALID")
else:
    print("INVALID")