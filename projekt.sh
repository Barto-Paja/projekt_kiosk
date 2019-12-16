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
  exit 0
else
  echo "Invalid argument";
  exit 1;
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

    (0) Uruchomienie wybranego program
    (1) Uruchomienie wybranej prezentacji
    (2) Uruchomienie wybranego filmu
    (3) Uruchomienie wybranego wygaszacza ekranu i muzyki w tle
    (Q)uit
    ------------------------------
EOF
    read -n1 -s
    case "$REPLY" in
      "0" ) echo "Podaj nazwe programu wraz z parametrami uruchomienia go";
      echo "Np.: ls -l";
      sed -i 's/^[0-9]/0/' flags/switchrun.flag;
      sed -i '$ d' flags/cases/0.case;
      read appname; echo "$appname" >> flags/cases/0.case;
      sed -i 's/^[0-9]/0/' flags/showmenu.flag;
      shutdown -r now;;
      "1" ) echo "Podaj sciezke do pliku prezentacji";
      sed -i 's/^[0-9]/1/' flags/switchrun.flag;
      sed -i '$ d' flags/cases/1.case;
      read filename; echo "$filename" >> flags/cases/1.case;
      sed -i 's/^[0-9]/0/' flags/showmenu.flag;
      shutdown -r now;;
      "2" ) echo "Podaj sciezke do filmu";
      sed -i 's/^[0-9]/2/' flags/switchrun.flag;
      sed -i '$ d' flags/cases/2.case;
      read filename; echo "$filename" >> flags/cases/2.case;
      sed -i 's/^[0-9]/0/' flags/showmenu.flag;
      shutdown -r now;;
      "3" ) echo "Podaj sciezke do muzyki";
      sed -i 's/^[0-9]/3/'flags/switchrun.flag;
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
    "0" ) $(sed -n 2p flags/cases/0.case);;
    "1" ) libreoffice --impress --show $(sed -n 2p flags/cases/1.case);;
    "3" ) gnome-screensaver-command -l;
     ffplay "$(sed -n 2p flags/cases3.case)";;
  esac
fi
