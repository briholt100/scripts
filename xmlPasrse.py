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

tree.xpath('//presentation/flow/material/mattext[@mattext/text()')

[@title="buyer-name"]/text()

root2 = tree.getroot()

expr =  '//presentation/flow/material/*[local-name() =$name]'

root2.xpath(expr, name = "mattext")[0].tag



mattext texttype="text/html"






find_text = etree.XPath("//text()")
find_text(root2)[299]






import os

dir="/media/brian/dater_bridge2/work/Lifespan/quizzes/ch10/QIZ_5553724_M/data/"
os.chdir(dir)


from lxml import etree

def print_elems(root, path):
    print( '\033[92m{} \033[96m{}\033[0m'.format(root, path))
    for i, elem in enumerate(root.xpath(path), 1):
        print('\t{:2d}: {}'.format(i, elem))
    print()

with open('1xml.txt') as xml_file:
    tree = etree.parse(xml_file)  # tree container object
    root_node = tree.getroot()    # root node
    resp_node = root_node.find('.//response_lid')  # 1st response_lid node

# various tests

print_elems(tree,      '/presentation/flow/material/mattext[@texttype="text/html"]/text()')
print_elems(tree,      '//presentation/flow/material/mattext[@texttype="text/html"]/text()')
print_elems(root_node, './flow/material/mattext[@texttype="text/html"]/text()')
print_elems(tree,      '//mattext[@texttype="text/html"]/text()')
print_elems(root_node, './/mattext[@texttype="text/html"]/text()')
print_elems(resp_node, './/mattext[@texttype="text/html"]/text()')


for elem in tree.iterfind("./flow"):
    print etree.tostring(elem[0])
    
print resp_node.xpath("text()")
tree.getroot().tag
tree2=etree.XML(tree.xpath("string()"))

print etree.tostring(root_node)

children=list(root_node)

for child in root_node:
    print (child.tag)
    
    
print(etree.iselement(root_node))  # test if it's some kind of Element

if len(root_node):                 # test if it has children
   print("The root element has children")








from lxml import etree

color_dict = {    'grey': '\033[90m',      'red': '\033[91m',
                 'green': '\033[92m',   'yellow': '\033[93m',
                  'blue': '\033[94m',  'magenta': '\033[95m',
                  'cyan': '\033[96m',    'white': '\033[97m',
               'default': '\033[0m' }

line_plain = '{}{}:{}{}'    # indentation/tag/text/attrib
# tag green, text cyan, attrib dict yellow
line_colors = '{{}}{green}{{}}{default}:{cyan}{{}}{default}{yellow}{{}}{default}'.format(**color_dict)
line = line_colors

def print_recursive(node, indent=0):
    pad = ' '*indent
    tag = node.tag.split('}')[-1]
    attr = ' ({})'.format(node.attrib) if node.attrib else ''
    text = ' "{}"'.format(node.text.strip()) if node.text else ''     
    print(line.format(pad, tag, text, attr))       
    for n in node:
        print_recursive(n, indent=indent+4)


with open('ch10.xml') as xml_file:
    tree = etree.parse(xml_file)  # tree container object
    root_node = tree.getroot()    # root node

print_recursive(root_node)


