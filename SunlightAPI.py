# -*- coding: utf-8 -*-
"""
Created on Fri Apr 24 23:39:04 2015

@author: brian
"""

import requests
import pprint

query_params = { 'apikey': 'f6ab5f2e4f69444b9f2c0a44d9a5223d',
				 'per_page': 3,
				 'entity_type': 'month',
				 'entity_value': '201210',
				 "sort":"count desc"
		 		}

endpoint = 'http://capitolwords.org/api/phrases.json'

response = requests.get(endpoint, params=query_params)
data = response.json()
pprint.pprint(data)


#https://api.twitter.com/1.1/followers/list.json





requests.get('https://twitter.com', verify=True)
url = 'http://search.twitter.com/search.json?q=johnboehner'

#define a variable to store results and make the request

#passing in the above url - simple right?

results = requests.get(url)
data=response.json()
pprint.pprint(data)
