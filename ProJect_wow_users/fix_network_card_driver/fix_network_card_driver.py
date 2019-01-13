#-*-coding:utf-8 -*-
"""
Created on Tue Sep 08 16:54:51 2015

@author: TestUser1
"""

#from subprocess import Popen, PIPE
#import re
import subprocess
import _winreg
import os
import sys



sysCharType = sys.getfilesystemencoding()
info=os.popen('systeminfo').read()
info=info.decode(sysCharType).encode('utf-8')  #以系统编码解码字符，再以utf8重新编码
try :
    a=info.find("OptiPlex 3020")
except EOFError as e:
    a=-1
    
if a>0 :
    #print "True"
    pass
else:
    #print "False"
    sys.exit()



IsReg=1
i=0
IsDriverExists=0
while 1 :
    try:
        if i<10:
            j='0'+str(i)
            #print j
        else:
            j=str(i)
            #print j
        DriverVersion = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE, 'SYSTEM\\CurrentControlSet\\Control\\Class\\{4D36E972-E325-11CE-BFC1-08002BE10318}\\00'+j, 0, _winreg.KEY_READ)
        DriverDesc    = _winreg.OpenKey(_winreg.HKEY_LOCAL_MACHINE, 'SYSTEM\\CurrentControlSet\\Control\\Class\\{4D36E972-E325-11CE-BFC1-08002BE10318}\\00'+j, 0, _winreg.KEY_READ)
        i = i+1
    except:
        #print "read end"
        tip=u"正在修复网卡驱动，请稍等 \n"   
        print(tip)
        #print tip.decode(sysCharType).encode('utf-8')            
        tmp=os.environ["TMP"]
        subprocess.call(tmp+"\dell_Network_Driver_7THT6_WN_7886172014_A01.EXE /s",shell=False)
        tip=u"已完成修复 \n"
        print(tip)
        os.system("ping -n 3 127.1 >nul")
        #print tip.decode(sysCharType).encode('utf-8')  
        
        break
    
    (value1, valuetype1) = _winreg.QueryValueEx(DriverVersion, 'DriverVersion')
    (value2, valuetype2) = _winreg.QueryValueEx(DriverVersion, 'DriverDesc')
    if value1=='7.88.617.2014' and value2=='Realtek PCIe GBE Family Controller':
        IsDriverExists=1
     
        tip=u"已经是最新版驱动 \n"   
        #print tip.decode(sysCharType).encode('utf-8') 
        print(tip)
        #print "DriverExist"
        os.system("ping -n 3 127.1 >nul")
        break    

#print tip.decode(sysCharType).encode('utf-8')      


    
