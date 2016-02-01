#!/bin/bash

localprefix=`kde4-config --localprefix`
prefix=`kde4-config --prefix`

kdialog --yesno "Do you really want to uninstall Color Folder?"

if [ $? != 0 ]
  then
    exit 0
fi

rm "$localprefix/share/kde4/services/ServiceMenus/colorfolder.desktop"

if [ `whoami` != "root" ]
  then
    if [ -e /usr/bin/kdesu ]
      then
        kdesu -c "rm '$prefix/bin/colorfolder'"
      else
        kdesudo -c "rm '$prefix/bin/colorfolder'"
    fi
  else
    rm "$prefix/bin/colorfolder"
fi

kdialog --msgbox "Color Folder uninstalled"
