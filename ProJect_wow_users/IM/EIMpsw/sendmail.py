# -*- coding: utf-8 -*-
import time
import getpass
import smtplib
from email.mime.text import MIMEText
from email.header import Header


def sendmail(Resetuser):
    user=getpass.getuser() #当前运行的主机用户
    
    sender = 'it_Info@mail.CorpDomain'  
    #maillist = ['TestUser1@mail.CorpDomain','it@mail.CorpDomain']
    
    maillist = [user+'@mail.CorpDomain', Resetuser+'@mail.CorpDomain', 'it@mail.CorpDomain']  #发送给操作者，被操作账号，IT三方
    subject = u'即时通密码自助修改操作通知'  
    #smtpserver = 'mail.CorpDomain'  
    username = 'it_Info@mail.CorpDomain'  
    password = 'Password@1' 
    
    nowtime = time.asctime(time.localtime(time.time()))
    
    
     
    
    email_info = "<html >\
                        <h4 font-size:6px> 操作人： " + user + "</h4>" +\
                       "<h4>被重置账号： "+ Resetuser  + "</h4>" +\
                       "<h4>时间: "+ nowtime +"</h4>" +\
                       "<h4>账号已解锁，如继续尝试密码后依然失败，请联系IT重置密码</h4> \
                  </html>"
    '''
    邮件正文
    '''
    msg = MIMEText(email_info,'html','utf-8')
    #msg = MIMEText('<html><h1>aaaa_test_mesg</h1></html>','html','utf-8')
    
    
    msg['Subject'] = Header(subject,'utf-8')
    
    smtp = smtplib.SMTP('mail.CorpDomain:25')
    #smtp.connect('mail.CorpDomain:25')
    smtp.starttls()  #内邮不需要smtp验证
    smtp.login(username, password)
    smtp.sendmail(sender, maillist, msg.as_string())
    smtp.quit()
    
#sendmail("it_test2")
