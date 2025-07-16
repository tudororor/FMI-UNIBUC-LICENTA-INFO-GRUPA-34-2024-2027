#!/bin/bash

#HTMLPrettyPrinter

#Verificare input valid
if [ "$#" -ne 1 ]; then
    echo "Input invalid! Numar de argumente gresit!"
    exit 1
fi

#variabila fisier
input_file=$1

#Verific daca fisierul exista
if [ ! -f "$input_file" ]; then
    echo "Eroare: Fisierul '$input_file' nu exista in memorie"
    exit 1
fi

#Generam numele fisierului output
output_file="${input_file%.*}_formatted.html"

#Creez un fisier intermediar
preprocessed_file=$(mktemp)

#Adaug in fisierul intermediar fiecare tag pe cate o linie noua
awk '
{
#cand incepe un tag nou, adaug newline inainte de el
gsub(/</, "\n<",$0)
#cand se termina un tag, adaug newline dupa el
gsub(/>/, ">\n",$0)
print
}
' "$input_file" | sed '/^[[:space:]]*$/d' > "$preprocessed_file"

#Numarul de tab necesar
nr_tab=0

#functie indentare: adauga tab(4 spatii)
indent() {
    local nr=$1
    for((i=0;i<nr;i++));do
        printf "    "
    done
}

{
    while IFS= read -r line; do
        #curata spatiile de la inceputul si sfarsitul liniei
        line=$(echo "$line" | sed -e 's/^[[:space:]]*//' -e 's/[[:space:]]*$//')

        #Tag de inchidere
         if echo "$line" | grep -qE '^</'; then
            ((nr_tab--))
        fi

        #Introduc nr de tab iar apoi afisez linia
        indent $nr_tab
        echo "$line"

        #tag de deschidere(fara comentarii si autoinchise)
        if echo "$line" | grep -qE '^<[^/!][^>]*>$'; then
            ((nr_tab++))
        fi
        
         if echo "$line" | grep -qE '^<[^/!][^>]*/>$'; then
            ((nr_tab--))
        fi
        
    done
}  < "$preprocessed_file" > "$output_file"

#Sterg fisierul temporar
rm "$preprocessed_file"

echo "HTML-ul formatat a fost salvat in '$output_file'."
