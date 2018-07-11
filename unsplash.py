#!/usr/bin/python3
import requests
import json

url = 'https://api.unsplash.com/photos/random?client_id=520df61c2c64c200b7ba82aabba8c69a7ed3b39c1f2a49357231abe4d11867c3&query=landscape&count=30&featured=true'

if __name__ == '__main__':
    r = requests.get(url)
    # print(r.content)
    j = json.loads(r.content)
    for photo in j:
        if photo['width'] > photo['height'] and photo['height'] > 1080:
            print(photo['urls']['full'])
            exit(0)
