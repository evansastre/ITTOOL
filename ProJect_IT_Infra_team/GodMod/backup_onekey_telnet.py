# -*- coding: utf-8 -*-
# coding=gb2312
import telnetlib
import os
import time
import sys

# Config Opt
username = 'CorpDomain\ITSuperAdmin'   
password = 'Password@4'  
user_view = '>' 
server = 'ITTOOL_node2' #server addr

sysCharType = sys.getfilesystemencoding()

def login(itn,iusername,ipassword):
    One_Step(itn,'login: ',iusername)
    One_Step(itn,'password: ',ipassword)
    
def One_Step (itn,iread,iwrite):
    itn.read_until(iread)
    itn.write(iwrite+ '\r\n')    
def show(itn):
    started_time=time.clock()
    while True:
        r = itn.read_some()      
        #r = "execution result:%s" %p.stdout.read()
        if any(x in r for x in["backup"]):
            #started_time=0 #Reset start time
            print r   # 
        if (time.clock()-started_time-5 > 0 ): #Close within 5 secs if there's no message 
            print  "Switch backup done. \r\n"
            #r = itn.read_very_eager()
            #print r.decode(sysCharType).encode('utf-8') 
            itn.close() # tn.write('exit\r\n')
            break

def backup(iHost,iuser_view):
    
    try:
        tn = telnetlib.Telnet(iHost,port=23,timeout=10)# connect Telnet server
    except:
        print iHost+"  Request timeout \r\n"
        return
            
    login(tn,username,password)

    One_Step (tn,iuser_view,"E:")
    
    #One_Step (tn,iuser_view,"mkdir "+ "中文测试".decode('utf-8').encode('gb2312'))  #Window 的命令行窗口只能正确显示 GBK/GB2312 的编码
    mydir = r"cd E:\IT_Share\Huawei_Switch_Conf"   # r代表原文带入
    #print  u"cd E:\IT_Share\Huawei_Switch_Conf"   # u代表中文转义
    One_Step (tn,iuser_view, mydir )
    #One_Step (tn,iuser_view, "dir")
    One_Step (tn,iuser_view,"backup.exe")
    
    #time.sleep(10)
    show(tn)
    
    
    r = tn.read_very_eager()
    print r.decode(sysCharType).encode('utf-8') 
    

    #time.sleep(10)
    
  #  print  "Switch backup done. \r\n"

backup(server,user_view)

#os.system("ping -n 600 127.1 >nul") #Pause 600s，show result.



