#! /bin/bash
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus" 


basepath=$(cd `dirname $0`; pwd)
breeze_colorful_path="${HOME}/src/breeze-colorful/"
cd "${basepath}/arsenixc_wallpaper"

if [ $(date +%H) -ge 6 -a $(date +%H) -lt 17 ]
then
    period="d"
elif [ $(date +%H) -ge 17 -a $(date +%H) -lt 19 ]
then
    period="s"
else
    period="n"
    if [ $(date +%H) -eq 19 ]
    then
        period="n"
    fi
fi

if [ ! -f ./.selected ]
then
    echo '=day=
=sunset=
=night=' > ./.selected
fi

if [ $(ls | grep ${period}- | wc -l) -le $(cat ./.selected | grep ${period}- | wc -l) ]
then
    if [[ ${period} == "d" ]]
    then
        line_begin=`expr $(sed -n '/=day=/=' ./.selected) + 1`
        line_end=`expr $(sed -n '/=sunset=/=' ./.selected) - 1`
        sed -i "${line_begin},${line_end}d" ./.selected
    elif [[ ${period} == "s" ]]
    then
        line_begin=`expr $(sed -n '/=sunset=/=' ./.selected) + 1`
        line_end=`expr $(sed -n '/=night=/=' ./.selected) - 1`
        sed -i "${line_begin},${line_end}d" ./.selected
    else
        line_begin=`expr $(sed -n '/=night=/=' ./.selected) + 1`
        sed -i "${line_begin},\$d" ./.selected
    fi
fi


check_exist="1"
while [[ "$check_exist" != "" ]] ; do
    selected_wallpaper=$(ls "${period}"-*| shuf -n1)
    if [ "$(cat ./.selected | grep "${selected_wallpaper}")" == "" ]
    then
        check_exist=""
        if [[ ${period} == "d" ]]
        then
            sed -i "/=day=/a\ ${selected_wallpaper}" ./.selected
        elif [[ ${period} == "s" ]]
        then
            sed -i "/=sunset=/a\ ${selected_wallpaper}" ./.selected
        else
            sed -i "/=night=/a\ ${selected_wallpaper}" ./.selected
        fi
    fi
done

if [[ $1 == "unsplash" ]]
then
    if [[ $(curl -s --max-time 10 -I baidu.com | grep 'HTTP/1.1 200 OK') == '' ]]
    then
        exit
    fi
    rm "${basepath}/arsenixc_wallpaper/"unsplash-*
    selected_wallpaper="unsplash-$(date +%H-%M).jpg"
    wget "$(python3 ${basepath}/unsplash.py)" -O "${basepath}/arsenixc_wallpaper/${selected_wallpaper}"
fi

script="var a = desktops();\
  for(i = 0; i < a.length; i++){\
    d = a[i];d.wallpaperPlugin = \"org.kde.image\";\
    d.currentConfigGroup = Array(\"Wallpaper\", \"org.kde.image\", \"General\");\
    d.writeConfig(\"Image\", \"file://${basepath}/arsenixc_wallpaper/${selected_wallpaper}\");\
    d.writeConfig(\"FillMode\", 2);\
    d.writeConfig(\"Color\", \"#000\");\
  }"
qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "${script}"
# kwriteconfig5 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 20 --group Wallpaper --group org.kde.image --group General --key Image --type string "file://${basepath}/arsenixc_wallpaper/${selected_wallpaper}"

sleep 2
if [[ $1 == "new_blur" ]]
then
    if [[ `echo ${selected_wallpaper} | grep "ikdark"` != "" ]]
    then
        kwriteconfig5 --file plasmarc --group Theme --key name --type string breeze-light
    else
        kwriteconfig5 --file plasmarc --group Theme --key name --type string default
    fi
fi

if [[ $1 == "colorful" ]]
then
    cp /home/midorikawa/.config/kdeglobals /tmp/kgs.old
    /usr/local/bin/kcmcolorfulhelper "${basepath}/arsenixc_wallpaper/${selected_wallpaper}"
    cp /home/midorikawa/.config/kdeglobals /tmp/kgs.new
    diff /tmp/kgs.old /tmp/kgs.new > /tmp/kgs.diff
    
fi

if [[ $1 == "unsplash" ]]
then
    "${breeze_colorful_path}/change_theme.sh" "${basepath}/arsenixc_wallpaper/${selected_wallpaper}" 
fi
