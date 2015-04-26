# -*- coding: utf-8 -*-
"""
Created on Fri Apr 24 22:05:21 2015

@author: brian
"""

import twitter
api = twitter.Api(consumer_key='',
                      consumer_secret='',
                      access_token_key='',
                      access_token_secret='')

print api.VerifyCredentials()

users = api.GetFollowers()
print [u.name for u in users]

print  u.name