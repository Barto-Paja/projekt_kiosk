#!/bin/bash

if [ "$1" == "--install" ]
then
  echo "Install files $1";
  echo "Prepare GRUB";
  sed -i 's/^GRUB_CMDLINE_LINUX_DEFAULT=".*/GRUB_CMDLINE_LINUX_DEFAULT=\" quiet splash \"/' /etc/default/grub;
  if [ $? -ne 0 ]
  then
    echo "SED error: $?";
    exit 2;
  fi
  sed -i 's/^GRUB_CMDLINE_LINUX=".*/GRUB_CMDLINE_LINUX=\" quiet splash \"/' /etc/default/grub;
  if [ $? -ne 0 ]
  then
    echo "SED error: $?";
    exit 2;
  fi
  echo "Install flags";
  cp -a flags/ $HOME/flags/
  if [ $? -ne 0 ]
  then
    echo "CP error: $?";
    exit 2;
  fi
  echo "Add autostart command";
  cp gnome-terminal.desktop $HOME/.config/autostart
  if [ $? -ne 0 ]
  then
    echo "CP error: $?";
    exit 2;
  fi
  echo "Create media storage";
  mkdir $HOME/media
  if [ $? -ne 0 ]
  then
    echo "CP error: $?";
    exit 2;
  fi
  exit 0
else
  #do nothing - do start process
  #exit 1;
  echo ""
fi

showmenu=$(more flags/showmenu.flag | grep -m1 '^[0-9]')
switchcase=$(more flags/switchrun.flag | grep -m1 '^[0-9]')

if [ $showmenu -eq 1 ]
then
  while [[ true ]]; do
    clear
    cat<<EOF
    ==============================
       PROJEKT KIOSK
    ------------------------------
    Please enter your choice:

    (0) Uruchomienie wybranego programu
    (1) Uruchomienie wybranej prezentacji
    (2) Uruchomienie wybranego filmu
    (3) Uruchomienie wybranego wygaszacza ekranu i muzyki w tle
    (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
      "0" ) echo "Wybierz program, ktory ma zostac uruchomiony.";
      echo "1) Mozilla Firefox";
      echo "2) Thunderbird (klient pocztowy)";
      echo "3) Kalendarz";
      echo "*) Wpisanie roznego od 1-3 spowoduje uruchomienie kalendarza";
      sed -i 's/^[0-9]/0/' flags/switchrun.flag;
      sed -i '$ d' flags/cases/0.case;
      read appname; echo "$appname" >> flags/cases/0.case;
      sed -i 's/^[0-9]/0/' flags/showmenu.flag;
      shutdown -r now;;
      "1" ) echo "Lista plikow:";
      ls media -l;
      echo "Podaj nazwe pliku z prezentacja, ktora chcesz uruchomic";
      sed -i 's/^[0-9]/1/' flags/switchrun.flag;
      sed -i '$ d' flags/cases/1.case;
      read filename; echo "$filename" >> flags/cases/1.case;
      sed -i 's/^[0-9]/0/' flags/showmenu.flag;
      shutdown -r now;;
      "2" ) echo "Lista plikow:";
      ls media -l;
      echo "Podaj nazwe pliku filmu";
      sed -i 's/^[0-9]/2/' flags/switchrun.flag;
      sed -i '$ d' flags/cases/2.case;
      read filename; echo "$filename" >> flags/cases/2.case;
      sed -i 's/^[0-9]/0/' flags/showmenu.flag;
      shutdown -r now;;
      "3" ) echo "Lista plikow:";
      ls media -l;
      echo "Podaj nazwe pliku z muzyka";
      sed -i 's/^[0-9]/3/' flags/switchrun.flag;
      sed -i '$ d' flags/cases/3.case;
      read filename; echo "$filename" >> flags/cases/3.case;
      sed -i 's/^[0-9]/0/' flags/showmenu.flag;
      gnome-control-center background;
      echo "Nacisnij downolny klawisz, aby kontynuowac";
      read p;
      shutdown -r now;;
      "Q" ) exit;;
      "q" ) echo "Case Sensitive!";;
       *  ) echo "Invalid option";;
    esac
    sleep 1
  done
else
  case "$switchcase" in
    "0" ) sed -i 's/^[0-9]/1/' flags/showmenu.flag;
    case "$(sed -n 2p flags/cases/0.case)" in
      "1" ) firefox;;
      "2" ) thunderbird;;
      * ) gnome-calendar;;
    esac;;
    "1" ) sed -i 's/^[0-9]/1/' flags/showmenu.flag;
    libreoffice --impress --show "/home/ubuntu/media/$(sed -n 2p flags/cases/1.case)";;
    "2" ) sed -i 's/^[0-9]/1/' flags/showmenu.flag;
    ffplay -fs "/home/ubuntu/media/$(sed -n 2p flags/cases/2.case)";;
    "3" ) sed -i 's/^[0-9]/1/' flags/showmenu.flag;
    gnome-screensaver-command -l;
    ffplay "/home/ubuntu/media/$(sed -n 2p flags/cases/3.case)";;
  esac
fi
