#!/bin/bash

colorfolder_desktop_src='colorfolder-breeze.desktop'
colorfolder_desktop='colorfolder.desktop'
colorfolder_sh='colorfolder.sh'

combobox_kde_version=('Select your desktop version:' 'Plasma 5' 'KDE4')

kde_version=$(kdialog --caption "Desktop version" --title "Color Folder" --combobox "${combobox_kde_version[@]}" --default "${combobox_kde_version[1]}")

if [ "$kde_version" == "Plasma 5" ]; then
    kde_config_services=`kf5-config --path services`
    
    IFS=":"

    for p in $kde_config_services; do
        if [[ $p != /usr/* ]]; then
            service_path="$p"
            break
        fi
    done
elif [ "$kde_version" == "KDE4" ]; then
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
    exit 0
fi

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
