# -*- coding: utf-8 -*-
"""
Created on Sun Aug 23 13:56:15 2015

@author: TestUser1
"""

from distutils.core import setup
import py2exe
import sys
sys.argv.append('py2exe')

options = {
    "includes" :["sip"], 
    #"dll_excludes": ["MSVCP90.dll",],
    "compressed": 1, #compression  
    "optimize": 2,  
    "ascii": 0,
    #"bundle_files": 1 #Package all files into an exe file
    }

setup(  
     
    name = 'resetAccount', 
    version = '1.0', 
    windows=["Dialog.py", ],    
    zipfile=None,
    options={'py2exe': options}
    
    )
    #service=["PyWindowsService"], 
