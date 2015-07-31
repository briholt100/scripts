# -*- coding: utf-8 -*-
"""
Created on Wed Jul 29 17:31:27 2015

@author: brian
"""

import lxml
try:
  from lxml import etree
  print("running with lxml.etree")
except ImportError:
  try:
    # Python 2.5
    import xml.etree.cElementTree as etree
    print("running with cElementTree on Python 2.5+")
  except ImportError:
    try:
      # Python 2.5
      import xml.etree.ElementTree as etree
      print("running with ElementTree on Python 2.5+")
    except ImportError:
      try:
        # normal cElementTree install
        import cElementTree as etree
        print("running with cElementTree")
      except ImportError:
        try:
          # normal ElementTree install
          import elementtree.ElementTree as etree
          print("running with ElementTree")
        except ImportError:
          print("Failed to import ElementTree from any known place")
          
          

from lxml import etree
from lxml import objectify
import os
from io import StringIO, BytesIO


directory="/media/brian/dater_bridge2/work/Lifespan/quizzes/ch11/QIZ_5553724_M/data/"
f = "ch11.xml"  
f_loc=os.path.join(directory,f)
os.listdir(directory)

tree = etree.parse(f_loc)
tree.xpath('//presentation/flow/material/mattext')
tree.xpath('//presentation/*/mattext[@texttype="text/html"]/text()')

tree.xpath('//presentation/flow/material/mattext/text()')

[@title="buyer-name"]/text(

root2 = tree.getroot()

expr =  '//presentation/flow/material/*[local-name() =$name]'

root2.xpath(expr, name = "mattext")[0].tag



mattext texttype="text/html"






find_text = etree.XPath("//text()")
find_text(root2)[299]