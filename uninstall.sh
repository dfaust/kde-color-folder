#!/bin/bash

colorfolder_desktop='colorfolder.desktop'
colorfolder_sh='colorfolder.sh'

if [ `which kde4-config` ]; then
    kde_config_services=`kde4-config --path services`

    IFS=":"

    for p in $kde_config_services; do
        colorfolder_desktop_path="$p/ServiceMenus/$colorfolder_desktop"
        colorfolder_sh_path="$p/ServiceMenus/$colorfolder_sh"

        if [ -f "$colorfolder_desktop_path" ]; then
            echo "removing file: $colorfolder_desktop_path"
            rm "$colorfolder_desktop_path"
        fi

        if [ -f "$colorfolder_sh_path" ]; then
            echo "removing file: $colorfolder_sh_path"
            rm "$colorfolder_sh_path"
        fi
    done

    prefix=`kde4-config --prefix`

    if [ -f "$prefix/bin/colorfolder" ]; then
        if [ `which kdesu` ]; then
            echo "removing file: $prefix/bin/colorfolder"
            kdesu -c "rm '$prefix/bin/colorfolder'"
        elif [ `which kdesudo` ]; then
            echo "removing file: $prefix/bin/colorfolder"
            kdesudo -c "rm '$prefix/bin/colorfolder'"
        fi
    fi
fi

if [ `which kf5-config` ]; then
    kde_config_services=`kf5-config --path services`

    IFS=":"

    for p in $kde_config_services; do
        colorfolder_desktop_path="$p/$colorfolder_desktop"
        colorfolder_sh_path="$p/$colorfolder_sh"

        if [ -f "$colorfolder_desktop_path" ]; then
            echo "removing file: $colorfolder_desktop_path"
            rm "$colorfolder_desktop_path"
        fi

        if [ -f "$colorfolder_sh_path" ]; then
            echo "removing file: $colorfolder_sh_path"
            rm "$colorfolder_sh_path"
        fi
    done
fi
