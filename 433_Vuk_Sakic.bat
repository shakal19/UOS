@echo off
::Podrazumevao sam da batch skriptu pokrecem iz 
:: direktorijum u kome se nalazi batch fajl i csv fajl
:: Ova for petlja ce kreirati novi fajl
:: indeksi.csv u kome ce se upisivati indeksi
:: brojevi indeksa svih studenta koji su polagali ispite 
:: bez duplikata
::Prva linija koja se upisuje je naziv kolone ali se ona preskace
::Ukoliko se indeks kao podstring ne nalazi u fajlu indeksi.csv
::upisace se fajl
echo brIndeksa, >> indeksi.csv
for /f "skip=1 delims=, tokens=1" %%a in (%1) do (
    find "%%a" indeksi.csv > nul
    if errorlevel 1 (
        echo %%a, >> indeksi.csv
    )
)
:: Ova ugnjezdena for petlja ce u fajl brIndeksa.txt upisati onoliko
:: linija koliko je student sa tim brojem indeksa  polzio ispita (ukupno)
:: u prvoj for petlji se kao parametri navode svi brojevi indeksa po jednom
for /f "skip=1 delims=, tokens=1" %%a in (indeksi.csv) do (
    for /f "skip=1 delims=, tokens=1-3" %%A in (%1) do (
        if %%a == %%A (
            echo Student %%B %%C sa indeksom %%a je polozio ispit >> %%a.txt
        )
    )
)
:: Ova for petlja ce stvoriti fajl student_brIndeksa u 
::kojem ce se upisati Student Ime Prezime
:: takav fajl se kreira samo jedom za svakog studenta
for /f "skip=1 delims=, tokens=1-3" %%a in (%1) do (
    if not exist student_%%a.txt (
        echo Student %%b %%c > student_%%a.txt
    )
)
::Ova for petlja ce za svakog studenta u svaki fajl broj_linija_brIndeksa.txt 
:: izbrojati koliko se puta javlja brojIndeksa kao string u
:: odgovarajucem fajlu brIndeksa.txt
for /f "skip=1 delims=, tokens=1" %%a in (indeksi.csv) do (
    find /c "%%a" %%a.txt >> broj_linija_%%a.txt
)
:: For petlja ispod ce za svaki broj indeksa ispitati da li 
::se u fajlovima broj_linija_brIndeksa ispitati da li se u tim fajlovima kao
:: podstring nalaze stringovi "TXT: 2" i "TXT: 3" . Uzeo sam u obzir da se uvek kao 
:: rezultat find komande vraca "TXT: NUMBER"
::ukoliko se ova dva podstriga ne nalaze u datim fajlovima student je polozio bar 
:: 3 ispita i onda se to upisuje u fajl domaci1.txt
:: Jedino formatiranje linija u fajlu domaci1.txt je malo drugacije
for /f "skip=1 delims=, tokens=1" %%a in (indeksi.csv) do (
        find "TXT: 2" broj_linija_%%a.txt > nul
        if errorlevel 1 (
            find "TXT: 1" broj_linija_%%a.txt > nul
            if errorlevel 1 (
                type student_%%a.txt >> domaci1.txt
                echo sa indeksom %%a je polozio bar 3 ispita. >> domaci1.txt
            )

        )
    )
:: Ukoliko fajl domaci1.txt ne postoji onda nijedan
:: student nije polozio vise od 2 ispita
if not exist domaci1.txt (
    echo Niko nije polozio vise od 2 ispita. >> domaci1.txt
)
del indeksi.csv
        



