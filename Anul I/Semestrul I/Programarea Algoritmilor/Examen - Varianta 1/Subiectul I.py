# subpunctul a) (credit rezolvare: @vlaxcs pe GitHub)
def cuvinte_consoane(*cuvinte):
    d = {}
    for cuvant in cuvinte:
        cuvant = cuvant.lower()
        key = "".join(sorted(set([litera for litera in cuvant if litera not in "aeiou"])))
        if key not in d:
            d[key] = [cuvant]
        else:
            d[key].append(cuvant)

    lmax = 0
    for key in d:
        if len(d[key]) > lmax:
            lmax = len(d[key])

    return lmax

x = cuvinte_consoane("este", "stea", "are", "rea", "tAsta")
print(x)

# subpunctul b)
lista_numere = [800, 246, 153, 12]
prefix_5 = [x for x in lista_numere if all((x//(10**i))%5 != 0 for i in range(len(str(x))))] #nu pusesem cu all()

print(prefix_5)