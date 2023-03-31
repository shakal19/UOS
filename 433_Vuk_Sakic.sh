#Sve je isto kao sto sam uradio u batch fajlu samo prilagodeno bash fajlu
#generisanje indeksa bez duplikata
echo BrIndeksa, >> indeksi.csv
tail -n +2 "$1" | while IFS=, read -r col1 col2 col3 col4 
do 
    grep "$col1" indeksi.csv > /dev/null
    if [ $? -eq 1 ]
    then 
        echo $col1, >> indeksi.csv
    fi
done
#broj polozenih ispita po studentu
tail -n +2 indeksi.csv | while IFS=, read -r col1
do 
    tail -n +2 "$1" | while IFS=, read -r COL1 COL2 COL3 COL4
    do 
        if [ "$col1" == "$COL1" ]
        then
            echo Student $COL2 $COL3 sa indeksom $col1 je polozio ispit >> $col1.txt
        fi
    done 
done
#stvaranje fajlova student ime_prezime.txt koji sadrze ime 
#i prezime studenta sa odgovarajucim brojem indeksa
tail -n +2 "$1" | while IFS=, read -r col1 col2 col3 col4
do 
    if ! [ -f "student\_$col1" ]
    then
        echo Student $col2 $col3 > student\_$col1.txt
    fi
done

#broj linija u indeks.txt
tail -n +2 indeksi.csv | while IFS=, read -r col1 
do 
    grep -c "$col1" $col1.txt >> broj_linija\_$col1.txt
done
## Ispitavanje ko je polozio vise od 3 ispita
tail -n +2 indeksi.csv | while IFS=, read -r col1
do 
    grep "2" broj_linija\_$col1.txt > /dev/null
    if [ $? -eq 1 ] 
    then 
        grep "1" broj_linija\_$col1.txt > /dev/null
        if [ $? -eq 1 ]
        then 
        cat student\_$col1.txt >> domaci1.txt
        echo sa indeksom $col1 je polozio bar 3 ispita >> domaci1.txt
        fi
    fi
done 
## Ukoliko niko nije polozio vise od 2 ispita
if ! [ -f "domaci1.txt" ]
then
    echo Niko nije polozio vise od 2 ispita > domaci1.txt
fi
rm indeksi.csv 
