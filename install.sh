#!/bin/bash

colorfolder_desktop_src='colorfolder-breeze.desktop'
colorfolder_desktop='colorfolder.desktop'
colorfolder_sh='colorfolder.sh'

combobox_kde_version=('Select your desktop version:' 'Plasma 5' 'KDE4')

kde_version=$(kdialog --title "Color Folder" --combobox "${combobox_kde_version[@]}" --default "${combobox_kde_version[1]}")

kde_config_services=()

if [ "$kde_version" == "Plasma 5" ]; then
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
elif [ "$kde_version" == "KDE4" ]; then
    if [ `which kde4-config` ]; then
        colorfolder_desktop_src='colorfolder-oxygen.desktop'
        kde_config_services=`kde4-config --path services`

        IFS=":"

        for p in $kde_config_services; do
            if [[ $p != /usr/* ]]; then
                service_path="$p/ServiceMenus"
                break
            fi
        done
    else
        kdialog --title "Color Folder" --error "Installation failed: kde4-config not found"
        exit 1
    fi
else
    exit 0
fi

if ! [ -z "$service_path" ]; then
    if ! [ -e "$service_path" ]; then
        echo "creating directory: $service_path"
        mkdir -p "$service_path"
    fi

    echo "creating file: $service_path/$colorfolder_desktop"
    echo "creating file: $service_path/$colorfolder_sh"
    cp "./$colorfolder_desktop_src" "$service_path/$colorfolder_desktop"
    cp "./$colorfolder_sh" "$service_path/$colorfolder_sh"

    search="Exec=$colorfolder_sh"
    replace="Exec=$service_path/$colorfolder_sh"
    replace=${replace//\//\\/}
    sed -i "s/$search/$replace/" "$service_path/$colorfolder_desktop"

    chmod +x "$service_path/$colorfolder_sh"

    if [ "$kde_version" == "Plasma 5" ]; then
        kbuildsycoca5
    elif [ "$kde_version" == "KDE4" ]; then
        kbuildsycoca4
    fi
else
    kdialog --title "Color Folder" --error "Installation failed: Can't find service path"
    exit 1
fi
