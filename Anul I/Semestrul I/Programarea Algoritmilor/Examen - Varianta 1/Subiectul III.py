L, k = 9, 5

l = [0, 1, 2, 4, 5, 6]
p = [0, 5, 6, 21, 22, 23]

dp = [0]*(L + 1)
prev = [-1]*(L + 1)

for i in range(1, L + 1):
    maxim = 0
    for j in range(1, k + 1):
        if i - l[j] >= 0:
            if dp[i - l[j]] + p[j] > maxim:
                maxim = dp[i - l[j]] + p[j]
                dp[i] = dp[i - l[j]] + p[j]
                prev[i] = l[j]

Rez = []
e = L
while e > 0:
    Rez.append(prev[e])
    e -= prev[e]

print(dp[L])
print(*sorted(Rez))