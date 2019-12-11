#!/bin/bash

showmenu=$(more flags/showmenu.flag | grep -m1 '^[0-9]')
switchcase=$(more flags/switchrun.flag | grep -m1 '^[0-9]')

echo ${showmenu}

if [ $showmenu -eq 1 ]
then

while :
do
    clear
    cat<<EOF
    ==============================
    	   PROJEKT KIOSK
    ------------------------------
    Please enter your choice:

    (0) Uruchomienie wybranego program 
    (1) Uruchomienie wybranej prezentacji 
    (2) Uruchomienie wybranego filmu
    (3) Uruchomienie wybranego wygaszacza ekranu i muzyki w tle
           (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
    "0")  echo "Podaj nazwe programu wraz z parametrami uruchomienia go:";
          sed -i 's/^[0-9]/0/' flags/switchrun.flag;
	  sed -i '$ d' flags/cases/0.case;
	  read appname; echo "$appname" >> flags/cases/0.case;
	  sed -i 's/^[0-9]/0/' flags/showmenu.flag;;
    "1")  echo "Podaj sciezke do pliku prezentacji";
	  sed -i 's/^[0-9]/1/' flags/switchrun.flag;
          sed -i '$ d' flags/cases/1.case;
	  read filename; echo "$filename" >> flags/cases/1.case;
	  sed -i 's/^[0-9]/0/' flags/showmenu.flag;;
    "2")  echo "Podaj sciezke do filmu";
	  sed -i 's/^[0-9]/2/' flags/switchrun.flag;
	  sed -i '$ d' flags/cases/2.case;
	  read filename; echo "$filename" >> flags/cases/2.case;
          sed -i 's/^[0-9]/0/' flags/showmenu.flag;;
    "3")  echo "Podaj sciezke do muzyki";
          sed -i 's/^[0-9]/3/'flags/switchrun.flag;
          sed -i '$ d' flags/cases/3.case; 
	  read filename; echo "$filename" >> flags/cases/3.case;
	  sed -i 's/^[0-9]/0/' flags/showmenu.flag;
	  gnome-control-center background;;
    "Q")  exit                      ;;
    "q")  echo "case sensitive!!"   ;; 
     * )  echo "invalid option"     ;;
    esac
    sleep 1
done

else
    case "$switchcase" in
    "0") $(sed -n 2p flags/cases/0.case);;
    "1") libreoffice --impress --show $(sed -n 2p flags/cases/1.case);;
    "2") ;;
    "3") gnome-screensaver-command -l;;
fi


