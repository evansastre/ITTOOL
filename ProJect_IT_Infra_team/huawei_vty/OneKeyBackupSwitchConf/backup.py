# -*- coding: utf-8 -*-   
# coding=utf-8
import telnetlib
import subprocess
import os
import threading
import time
# 配置选项
username = 'ITSuperAdmin'   # 登录用户名  
password = 'Password@2'  # 登录密码  
user_view = '<' # 用户视图
system_view='['  #系统视图
#commands ='tftp 192.168.104.241 put vrpcfg.zip ../402/vrpcfg.zip'

backup_server = '192.168.104.241' #备份服务器地址
#backup_server = '192.168.109.207' #备份服务器地址

import win32com.client  #检测本机tftpserver是否打开，否则开启
def check_exsit(process_name):
    WMI = win32com.client.GetObject('winmgmts:')
    processCodeCov = WMI.ExecQuery('select * from Win32_Process where Name="%s"' % process_name)
    if len(processCodeCov) <= 0:
        try:
            subprocess.Popen('Cisco_TFTP_Server\TFTPServer.exe') #非阻塞方式打开tftpserver
            #subprocess.Popen('Cisco_TFTP_Server\TFTPServer.exe').wati(3); #阻塞.
            #time.sleep(3) #设定延时3秒确保启动
        except:
            print "打开 tftpserver失败" 
            exit()
        #time.sleep(3) #设定延时3秒确保启动
        #check_exsit('TFTPServer.exe') 

check_exsit('TFTPServer.exe')


def IsFolder(iHost):
    a=os.path.exists(iHost)
    if not a: os.system("mkdir "+ iHost)
           
def One_Step (tn,iread,iwrite):
    tn.read_until(iread)
    tn.write(iwrite+ '\n')
     
def login(tn,iusername,ipassword):
    One_Step(tn,'Username:',iusername)# 输入登录用户名
    One_Step(tn,'Password:',ipassword)# 输入登录密码

def Commands(iHost,conf,tn,iuser_view):
    tftp_put ='tftp '+ backup_server + ' put '+ conf +' ../'+iHost+'/'+conf
    One_Step(tn,iuser_view,tftp_put)   #
    
def backup(iHost,conf,iusername,ipassword,iuser_view):
    IsFolder(iHost)
    try:
        tn = telnetlib.Telnet(iHost,port=23,timeout=10)# connectTelnet服务器  
    except:
        print iHost+"  Request timeout \n"
        return
            
    login(tn,iusername,ipassword)
    Commands(iHost,conf,tn,iuser_view)
    tn.read_until(iuser_view) 
    tn.close() # tn.write('exit\n')
    print iHost + " backup done. \n"
    
f = open('Hosts.ini','r')
while 1:
    ip = f.readline()
    if not ip:
        break
    pass
    iHost=ip.split()[0]  #只切取IP部分，后半留作注释用
    conf=ip.split()[1]
    a=threading.Thread(target=backup,args=(iHost,conf,username,password,user_view))
    a.start() #开启线程
    
os.system("ping -n 600 127.1 >nul") #暂停界面600s，展示执行结果.这里不用pause,服务器计划执行无法关闭



