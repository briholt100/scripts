# -*- coding: utf-8 -*-
"""
Created on Fri Apr 24 22:05:21 2015

@author: brian
"""

import requests
from requests_oauthlib import OAuth1
import pprint
url = 'https://api.twitter.com/1.1/account/verify_credentials.json'
url="https://api.twitter.com/1.1/followers/ids.json?screen_name=briancholt&user_id=23893139"

auth = OAuth1('insert 4 secret keys')

r=requests.get(url, auth=auth)
pprint.pprint(r.text) 
data = r.json()
data["ids"]


url="https://api.twitter.com/1.1/users/lookup.json?user_id=31574630" #get usernames from ids'
r=requests.get(url, auth=auth)
data = r.json()
print data




"""
import twitter
api = twitter.Api(consumer_key='',
                      consumer_secret='',
                      access_token_key='',
                      access_token_secret='')

print api.VerifyCredentials()

users = api.GetFollowers()
print [u.name for u in users]

print  u.name"""