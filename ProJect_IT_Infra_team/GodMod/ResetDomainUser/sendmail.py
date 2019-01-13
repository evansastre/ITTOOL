# -*- coding: utf-8 -*-
import time
import getpass
import smtplib
from email.mime.text import MIMEText
from email.header import Header


def sendmail(Resetuser):
    user=getpass.getuser() #Current User
    
    sender = 'it_Info@mail.CorpDomain'  
    #maillist = ['TestUser1@mail.CorpDomain','it@mail.CorpDomain']
    
    maillist = [user+'@mail.CorpDomain', Resetuser+'@mail.CorpDomain', 'it@mail.CorpDomain']  
    subject = u'Domain account reset operation notification'  
    #smtpserver = 'mail.CorpDomain'  
    username = 'it_Info@mail.CorpDomain'  
    password = 'Password@1' 
    
    nowtime = time.asctime(time.localtime(time.time()))
    
    
     
    
    email_info = "<html >\
                        <h4 font-size:6px> Operator: " + user + "</h4>" +\
                       "<h4>Reset account: "+ Resetuser  + "</h4>" +\
                       "<h4>TimeStamp "+ nowtime +"</h4>" +\
                       "<h4>If you are not willing to operate, please contact corp IT</h4> \
                  </html>"

    msg = MIMEText(email_info,'html','utf-8')
    #msg = MIMEText('<html><h1>aaaa_test_mesg</h1></html>','html','utf-8')
    
    
    msg['Subject'] = Header(subject,'utf-8')
    
    smtp = smtplib.SMTP('mail.CorpDomain:25')
    #smtp.connect('mail.CorpDomain:25')
    smtp.starttls()  #Internal mail does not require smtp verification
    smtp.login(username, password)
    smtp.sendmail(sender, maillist, msg.as_string())
    smtp.quit()
    
#sendmail("it_test2")
