# -*- coding: utf-8 -*-
"""
Created on Sun Aug 23 13:56:15 2015

@author: h5371
"""

from distutils.core import setup
import py2exe

options = {"py2exe":{"compressed": 1, #压缩  
                     "optimize": 2,  
                     "bundle_files": 1 #所有文件打包成一个exe文件  
                     }}  

setup(  
     
    options=options,  
    zipfile=None,
    console=["backup.py"])   
    
    
    
    #service=["PyWindowsService"], 