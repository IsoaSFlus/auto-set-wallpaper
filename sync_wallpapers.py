#!/usr/bin/python3
import sys
from github import Github
import multiprocessing
import subprocess
import os

if len(sys.argv) > 1:
    if sys.argv[1] == 'moebuta':
        label = sys.argv[1]
else:
    label = 'general'

def wallpaper_dl(url, label):
    print('Start downloading...')
    cmd = "wget '{}' -q  -P '{}'".format(url, label)
    subprocess.call(cmd, shell = True)

g = Github()
n = g.get_user('IsoaSFlus')
r = n.get_repo('Wallpapers')
pics = r.get_contents(label)

try:
    files = os.listdir('./{}'.format(label))
except FileNotFoundError:
    print('No wallpaper dir!')
    files = []


pool = multiprocessing.Pool(processes = 20)

for pic in pics:
    if pic.name in files:
        continue
    else:
        pool.apply_async(wallpaper_dl, (pic.download_url, label))

pool.close()
pool.join()
