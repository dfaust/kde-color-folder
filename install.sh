#!/bin/bash

localprefix=`kde4-config --localprefix`
prefix=`kde4-config --prefix`
sourcepath="$( cd "$( dirname "$0" )" && pwd )"

kdialog --yesno "This will copy\ncolorfolder.desktop to $localprefix/share/kde4/services/ServiceMenus/colorfolder.desktop\nand colorfolder to $prefix/bin/colorfolder\n\nContinue?"

if [ $? != 0 ]
  then
    exit 0
fi

if [ ! -d "$localprefix/share/kde4/services/ServiceMenus" ]
  then
    mkdir -p "$localprefix/share/kde4/services/ServiceMenus"
fi

menulocation=`kdialog --combobox "Where should Color Folder be installed?" "Submenu" "Top level context menu" --default "Submenu"`

if [ $? == 0 ] && [ "$menulocation" == "Top level context menu" ]
  then
    cp "$sourcepath/colorfolder_toplevel.desktop" "$localprefix/share/kde4/services/ServiceMenus/colorfolder.desktop"
  else
    cp "$sourcepath/colorfolder.desktop" "$localprefix/share/kde4/services/ServiceMenus/colorfolder.desktop"
fi

chmod +x colorfolder

if [ `whoami` != "root" ]
  then
    if [ -e /usr/bin/kdesu ]
      then
        kdesu -c "cp '$sourcepath/colorfolder' '$prefix/bin/colorfolder'"
      else
        kdesudo -c "cp '$sourcepath/colorfolder' '$prefix/bin/colorfolder'"
    fi
  else
    cp "$sourcepath/colorfolder" "$prefix/bin/colorfolder"
fi

kbuildsycoca4

kdialog --msgbox "Installation complete"
