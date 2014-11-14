#!/usr/bin/env python3
'''
File: citrix_hotfix.py
Author: Kristoffer Dalby
Description: Script to download hotfixes from citrix website, takes the citrix hostfix article as argument
'''
"""
Requirements:
beautifulsoup4==4.3.2
requests==2.4.3
"""

import os
import sys
import requests
from bs4 import BeautifulSoup

def insert_dl_data(url):
    index = url.find("net/")
    new = url[:index+4] + "akdlm/" + url[index+4:]
    return new

article_url = sys.argv[1]

article_r = requests.get(article_url)

#f = open('derp.txt','r').read()

soup = BeautifulSoup(article_r.text)

dllink = soup.find(class_="downLinkBtn")["href"]
dlurl = insert_dl_data(dllink)

os.system("wget %s" % dlurl)

