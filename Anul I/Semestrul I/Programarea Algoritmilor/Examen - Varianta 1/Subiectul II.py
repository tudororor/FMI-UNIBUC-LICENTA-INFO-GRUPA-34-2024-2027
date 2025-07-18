n = 8
N = [20, 15, 10, 82, 30, 58, 70, 15]
m = 6
M = [10, 5, 40, 17, 90, 25]

Masini = [(N[i], i) for i in range(n)]
Canistre = [(M[i], i) for i in range(m)]
Masini.sort(key = lambda t: t[0])
Canistre.sort(key = lambda t: t[0])

cate = 0
Rez = [-1]*n
i = j = 0
while i < n and j < m:
    if Canistre[j][0] >= Masini[i][0]:
        Rez[Masini[i][1]] = Canistre[j][1]
        cate += 1
        i += 1
        j += 1
    else:
        j += 1

print(cate)
for i in range(n):
    if Rez[i] != -1:
        print(f'M{i + 1} -> C{Rez[i] + 1}')
    else:
        print(f'M{i + 1} -> niciuna')