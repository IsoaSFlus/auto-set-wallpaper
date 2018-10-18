#! /bin/bash
export DBUS_SESSION_BUS_ADDRESS="unix:path=/run/user/1000/bus" 


basepath=$(cd `dirname $0`; pwd)
breeze_colorful_path="${HOME}/src/breeze-colorful/"
selected_wallpaper=""
cd "${basepath}/"

function general_wallpaper()
{
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

    if [ ! -f ./general/.selected ]
    then
        echo  '=day=
=sunset=
=night=' > ./general/.selected
    fi

    if [ $(ls ./general | grep ${period}- | wc -l) -le $(cat ./general/.selected | grep ${period}- | wc -l) ]
    then
        if [[ ${period} == "d" ]]
        then
            line_begin=`expr $(sed -n '/=day=/=' ./general/.selected) + 1`
            line_end=`expr $(sed -n '/=sunset=/=' ./general/.selected) - 1`
            sed -i "${line_begin},${line_end}d" ./general/.selected
        elif [[ ${period} == "s" ]]
        then
            line_begin=`expr $(sed -n '/=sunset=/=' ./general/.selected) + 1`
            line_end=`expr $(sed -n '/=night=/=' ./general/.selected) - 1`
            sed -i "${line_begin},${line_end}d" ./general/.selected
        else
            line_begin=`expr $(sed -n '/=night=/=' ./general/.selected) + 1`
            sed -i "${line_begin},\$d" ./general/.selected
        fi
        echo "New image cycle."
    fi


    check_exist="1"
    while [[ "$check_exist" != "" ]] ; do
        selected_wallpaper=$(ls ./general/${period}-* | shuf -n1)
        if [ "$(cat ./general/.selected | grep "${selected_wallpaper}")" == "" ]
        then
            check_exist=""
            if [[ ${period} == "d" ]]
            then
                sed -i "/=day=/a\ ${selected_wallpaper}" ./general/.selected
            elif [[ ${period} == "s" ]]
            then
                sed -i "/=sunset=/a\ ${selected_wallpaper}" ./general/.selected
            else
                sed -i "/=night=/a\ ${selected_wallpaper}" ./general/.selected
            fi
        fi
    done
    echo ${selected_wallpaper}
}

function moebuta_wallpaper()
{
    if [ ! -f ./moebuta/.selected ]
    then
        echo '' > ./moebuta/.selected
    fi

    if [ `expr $(ls ./moebuta | wc -l) - 1` -le $(cat ./moebuta/.selected | wc -l) ]
    then
        echo '' > ./moebuta/.selected
        echo "New image cycle."
    fi


    check_exist="1"
    while [[ "$check_exist" != "" ]] ; do
        selected_wallpaper=$(ls ./moebuta/* | shuf -n1)
        if [ "$(cat ./moebuta/.selected | grep "${selected_wallpaper}")" == "" ]
        then
            check_exist=""
            sed -i "1i\ ${selected_wallpaper}" ./moebuta/.selected
        fi
    done
    echo ${selected_wallpaper}
}

function set_wallpaper()
{
    script="var a = desktops();\
  for(i = 0; i < a.length; i++){\
    d = a[i];d.wallpaperPlugin = \"org.kde.image\";\
    d.currentConfigGroup = Array(\"Wallpaper\", \"org.kde.image\", \"General\");\
    d.writeConfig(\"Image\", \"file://${basepath}/${1}\");\
    d.writeConfig(\"FillMode\", 2);\
    d.writeConfig(\"Color\", \"#000\");\
  }"
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "${script}"
    # kwriteconfig5 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 20 --group Wallpaper --group org.kde.image --group General --key Image --type string "file://${basepath}/arsenixc_wallpaper/${selected_wallpaper}"

    sleep 2
}


if [[ $1 == "unsplash" ]]
then
    if [[ $(curl -s --max-time 10 -I baidu.com | grep 'HTTP/1.1 200 OK') == '' ]]
    then
        exit
    fi
    # rm "${basepath}/arsenixc_wallpaper/"unsplash-*
    selected_wallpaper="unsplash-$(date +%H-%M).jpg"
    aria2c -s100  "$(python3 ${basepath}/unsplash.py)" -d /tmp -o "${selected_wallpaper}"
    script="var a = desktops();\
  for(i = 0; i < a.length; i++){\
    d = a[i];d.wallpaperPlugin = \"org.kde.image\";\
    d.currentConfigGroup = Array(\"Wallpaper\", \"org.kde.image\", \"General\");\
    d.writeConfig(\"Image\", \"file:///tmp/${selected_wallpaper}\");\
    d.writeConfig(\"FillMode\", 2);\
    d.writeConfig(\"Color\", \"#000\");\
  }"
    qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript "${script}"
    # kwriteconfig5 --file plasma-org.kde.plasma.desktop-appletsrc --group Containments --group 20 --group Wallpaper --group org.kde.image --group General --key Image --type string "file://${basepath}/arsenixc_wallpaper/${selected_wallpaper}"

    sleep 2
    /usr/local/bin/kcmcolorfulhelper -p "/tmp/${selected_wallpaper}"
    exit
fi

if [[ $2 == "moebuta" ]]
then
    moebuta_wallpaper
else
    general_wallpaper
fi

set_wallpaper "${selected_wallpaper}"

if [[ $1 == "colorful" ]]
then
    /usr/local/bin/kcmcolorfulhelper -p "${basepath}/${selected_wallpaper}"
fi
