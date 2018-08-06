#!/bin/bash

desktop_file='colorfolder.desktop'
script_file='colorfolder.sh'

if [ `which kde4-config` ]; then
    kde_config_services=`kde4-config --path services`

    IFS=":"

    for p in $kde_config_services; do
        desktop_file_path="$p/ServiceMenus/$desktop_file"
        script_file_path="$p/ServiceMenus/$script_file"

        if [ -f "$desktop_file_path" ]; then
            echo "removing file: $desktop_file_path"
            rm "$desktop_file_path"
        fi

        if [ -f "$script_file_path" ]; then
            echo "removing file: $script_file_path"
            rm "$script_file_path"
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
        desktop_file_path="$p/$desktop_file"
        script_file_path="$p/$script_file"

        if [ -f "$desktop_file_path" ]; then
            echo "removing file: $desktop_file_path"
            rm "$desktop_file_path"
        fi

        if [ -f "$script_file_path" ]; then
            echo "removing file: $script_file_path"
            rm "$script_file_path"
        fi
    done
fi
