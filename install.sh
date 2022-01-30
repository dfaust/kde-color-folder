#!/bin/bash

desktop_file_src='colorfolder-breeze.desktop'
desktop_file='colorfolder.desktop'
script_file='colorfolder.sh'

kde_config_services=()

if [ `which kf5-config` ]; then
    kde_config_services=`kf5-config --path services`

    IFS=":"

    for p in $kde_config_services; do
        if [[ $p != /usr/* ]]; then
            service_path="$p"
            break
        fi
    done
else
    kdialog --title "Color Folder" --error "Installation failed: kf5-config not found"
    exit 1
fi

if ! [ -z "$service_path" ]; then
    if ! [ -e "$service_path" ]; then
        echo "creating directory: $service_path"
        mkdir -p "$service_path"
    fi

    echo "creating file: $service_path/$desktop_file"
    echo "creating file: $service_path/$script_file"
    cp "./$desktop_file_src" "$service_path/$desktop_file"
    cp "./$script_file" "$service_path/$script_file"

    search="$script_file"
    replace="$service_path/$script_file"
    replace=${replace//\//\\/}
    sed -i "s/$search/$replace/" "$service_path/$desktop_file"

    chmod +x "$service_path/$script_file"

    kbuildsycoca5
else
    kdialog --title "Color Folder" --error "Installation failed: Can't find service path"
    exit 1
fi
