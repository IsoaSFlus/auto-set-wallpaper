#!/usr/bin/python3
from github import Github
import multiprocessing
import subprocess
import os

def wallpaper_dl(url):
    print('Start downloading...')
    cmd = "wget '{}' -q  -P arsenixc_wallpaper".format(url)
    subprocess.call(cmd, shell = True)

g = Github()
n = g.get_user('IsoaSFlus')
n.bio
r = n.get_repo('Wallpapers')
r.get_contents('general')
pics = r.get_contents('general')

try:
    files = os.listdir('./arsenixc_wallpaper')
except FileNotFoundError:
    print('No wallpaper dir!')
    files = []


pool = multiprocessing.Pool(processes = 20)

for pic in pics:
    if pic.name in files:
        continue
    else:
        pool.apply_async(wallpaper_dl, (pic.download_url, ))

pool.close()
pool.join()
