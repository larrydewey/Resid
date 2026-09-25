import sys
n = int(sys.argv[1])
s = ""
for i in range(n):
    s = s + str(i) + ","
print(len(s))
