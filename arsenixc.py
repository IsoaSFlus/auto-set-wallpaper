#!/usr/bin/python3

import requests
import re
import random
import subprocess
import time
import sys
from bs4 import BeautifulSoup

url_params = {'tags' : 'landscape order:random'}
arsenixc_url = 'https://arsenixc.deviantart.com/gallery/11314091/Backgrounds'
download_dir = '/home/midorikawa/Pictures/arsenixc_wallpaper/'

def is_resolution_fit(photo_resolution):
    res = re.match('(\S+) x (\S+)', photo_resolution)
    print(res.group(0))
    if int(res.group(1)) > 1600 and int(res.group(2)) > 900 and (int(res.group(1)) / int(res.group(2))) > 1.5 and (int(res.group(1)) / int(res.group(2))) < 2.1:
        return True
    else:
        return False


def get_photos_resolution_list(html_text):
    return re.findall('<span class="directlink-res">(\S+ x \S+)<.span', html_text, re.M|re.L)

def get_photos_url_list(html_text):
    return re.findall('href="(https\S+jpg)"', html_text, re.M|re.I)

def download_photo(url):
    r = requests.get(url)
    with open(download_dir + 'wallpaper.jpg', "wb") as code:
        code.write(r.content)

def check_img(img_span):
    print(img_span.get('data-super-full-width'))
    print(img_span.get('data-super-alt'))
    if int(img_span.get('data-super-full-width')) >= 1400:
        img_name = img_span.get('data-super-alt')
        f = open(download_dir + 'index.txt', 'a+')
        f.seek(0,0)
        for line in f:
#            print(line)
#            print(line.find(img_name))
            if line.find(img_name) != -1:
               return 0
        f.write(img_name+'\n')
        f.close()
        return 1
    return 0

def download_img(url):
    time_stamp = time.localtime()
    file_name = 'wallpaper-' + '%02d%02d%02d'%(time_stamp.tm_hour, time_stamp.tm_min, time_stamp.tm_sec) + '.jpg'
    cmd = 'wget -O ' + download_dir + file_name + ' %s'%url
    try:
        subprocess.call(cmd, shell = True)
    except Exception as e:
        print(e)

def main():
    fit_flag = 0
    counter = 0
    soup = BeautifulSoup(open("3.html"),"html.parser")

    for img_url in soup.find_all(class_="thumb wide"):
        img_url.get('data-super-full-img')
        fit_flag = check_img(img_url)
        counter = counter + 1
        if fit_flag == 1:
            download_img(img_url.get('data-super-full-img'))
            fit_flag = 0

    print(counter)




if __name__ == '__main__':
    main()
