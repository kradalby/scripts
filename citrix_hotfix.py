#!/usr/bin/env python3
"""
Requirements:
beautifulsoup4==4.3.2
requests==2.4.3
"""

import sys
import requests
from bs4 import BeautifulSoup


article_url = sys.argv[1]
print(article_url)

article_r = requests.get(article_url)
print(article_r)
print(article_r.data)

soup = article_r.data

print(soup.prettify())
