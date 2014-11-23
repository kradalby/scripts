#!/usr/bin/env python
'''
File: hjorner.py
Author: Kristoffer Dalby
Description: Watch NTNU hjorner at finn.no to check if something interesting is added
Requirements:
    requests
    beautifulsoup4
'''

import requests
from bs4 import BeautifulSoup

NTNU_HJORNER = "http://www.finn.no/hjorner/corners/1"
KEYS = ['lerret', 'whiteboard', 'tavle', 'white', 'data', 'server', ]
AGE = '1 dag'

r = requests.get(NTNU_HJORNER)
soup = BeautifulSoup(r.text)

elements = soup.findAll(class_="line pam")

for element in elements:
    text = element.findChildren()[0].findChildren()[0].getText()
    url = element.findChildren()[0].findChildren()[0]['href']
    time = element.findChildren()[3].findChildren()[3].findChildren()[4].get_text()
    for key in KEYS:
        if key in text or key[0].upper() + key[1:]in text:
            print(text.strip())
            print("http://finn.no" + url)
            print(time.strip())


