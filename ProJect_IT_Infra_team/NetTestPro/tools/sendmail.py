# -*- coding: utf-8 -*-
"""
Created on Mon Jul 25 11:02:15 2016

@author: TestUser1
"""

# -*- coding: utf-8 -*-
"""
Created on Mon Jul 25 11:01:16 2016

@author: TestUser1
"""

#! python2.7
#-*-coding:utf-8 -*-
import time
import socket  
import getpass
import smtplib
import os.path  
from email.mime.text import MIMEText
from email.header import Header

import email.MIMEMultipart# import MIMEMultipart  
import email.MIMEText# import MIMEText  
import email.MIMEBase# import MIMEBase  
import mimetypes  
import email.MIMEImage# import MIMEImage  
import tempfile

tempdir=tempfile.gettempdir()
file_name = tempdir+"\winMTRresult.txt" #附件名
file_Info = tempdir+"\Info.txt" #INfo文件
user=getpass.getuser() #当前运行的主机用户
hostname = socket.gethostname()  
ip = socket.gethostbyname(hostname)  
nowtime = time.asctime(time.localtime(time.time()))


def sendmail(Resetuser):
    
    #发送地址和接收地址
    sender = '黄世磊<hzhuangshilei@corp.corpname.com>'      
    #maillist = ['hzhuangshilei@corp.corpname.com','zliangpeng@corp.corpname.com']  #发送给操作者，被操作账号，IT三方 #  ,'zliangpeng@corp.corpname.com'
    maillist = ['wow_it@list.nie.corpname.com']  #发送给操作者，被操作账号，IT三方 #  ,'zliangpeng@corp.corpname.com'
    #maillist = ['hzhuangshilei@corp.corpname.com']  #发送给操作者，被操作账号，IT三方 #  ,'zliangpeng@corp.corpname.com'
    
 
    
    # 构造MIMEMultipart对象做为根容器  
    main_msg = email.MIMEMultipart.MIMEMultipart()  
        
     
    username = 'hzhuangshilei'  
    password = 'dcacdsj1989' 
    smtp = smtplib.SMTP('corp.corpname.com')
    smtp.login(username, password)
    
    
 
    if  os.path.exists(file_Info):
        #message = 'OK, the  file exists.'
        all_the_text = open(file_Info)
        message=""
        for line in all_the_text.readlines():
            message +=line + "\n"
        import sys
        sysCharType = sys.getfilesystemencoding()
        message=message.decode(sysCharType).encode('utf-8')
        #print message
    
        
   # else:
       # message = "Sorry, I cannot find the  file."
        
    
    #

    email_info = "<html >\
                        <h4 font-size:6px> " + message + "</h4>" +\
                        "<h4>操作账户 "+ user + "</h4>" +\
                        "<h4>主机名 "+ Resetuser  + "</h4>" +\
                        "<h4>ip "+ ip  + "</h4>" +\
                       "<h4>时间: "+ nowtime +"</h4>" +\
                       "<h4>测试结果见附件</h4> \
                  </html>"
 
    #邮件正文
   
    # 构造MIMEText对象做为邮件显示内容并附加到根容器  
    text_msg = MIMEText(email_info,'html','utf-8')
    main_msg.attach(text_msg)
    
    # 构造MIMEBase对象做为文件附件内容并附加到根容器  
    ctype,encoding = mimetypes.guess_type(file_name)  
    if ctype is None or encoding is not None:  
        ctype='application/octet-stream'  
    maintype,subtype = ctype.split('/',1)  
    file_msg=email.MIMEImage.MIMEImage(open(file_name,'rb').read(),subtype)  
    
    #msg = MIMEText('<html><h1>aaaa_test_mesg</h1></html>','html','utf-8')
    
    
    
    # 设置附件头  
    basename = os.path.basename(file_name)  
    file_msg.add_header('Content-Disposition','attachment', filename = basename)  
    main_msg.attach(file_msg)  
    
    # 设置根容器属性  
    #main_msg['From'] = sender  
    #main_msg['Reply-to'] = maillist  
    subject = u'黄金系列赛场地网络测试结果'  
    main_msg['Subject'] = Header(subject,'utf-8')
    #main_msg['Date'] = email.Utils.formatdate()  
    
    smtp.sendmail(sender, maillist, main_msg.as_string())
    smtp.quit()
    
    
sendmail(hostname)
