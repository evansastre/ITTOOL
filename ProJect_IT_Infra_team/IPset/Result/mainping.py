#-*- coding:gb18030 -*-
'''
#�ж��ļ�ping.txt�е�ip�Ƿ���pingͨ�����ҽ�ͨ�벻ͨ��ip�ֱ�д�������ļ���ip_True.txt��ip_False.txt
���ip_False�����ԭping.txt
#�ļ��е�ipһ��һ��
'''

import subprocess   
import socket
import time,os
start_Time=int(time.time()) #��¼��ʼʱ��
def ping_Test():
    ips=open('ping.txt','r')
    ip_True = open('ip_True.txt','a')
    ip_False = open('ip_False.txt','w')
    count_True,count_False=0,0
    lines=ips.readlines()
    
    for ip in lines:
        #ip = ip.replace('\n','')  #�滻�����з�
        ip = ip.strip()
        return1=subprocess.call('ping  -n 2 -w 1 %s'%ip,shell=True) #ÿ��ip ping2�Σ��ȴ�ʱ��Ϊ1s

        #print return1

        if return1:
            print 'ping %s is fail'%ip
            ip_False.write(ip+"\n")  #��ping��ͨ��д��ip_False.txt��
            #ip_False.write(socket.gethostbyaddr(ip))
            count_False += 1
        else:
            print 'ping %s is ok'%ip
            #ip_True.write(ip)  #��pingͨ��ipд��ip_True.txt��
            
            try:
                result = socket.gethostbyaddr(ip)
                #print result
                ip_True.write(result[0].split(".")[0])
                ip_True.write(" ")
                ip_True.write(result[2][0])
                ip_True.write("\n")
            except socket.herror: #�޷���ȡ�������������ֱ��д��IP
                ip_True.write("GetHostNameFail "+ip+"\n")
            count_True += 1
           
    ip_True.close()
    ip_False.close()
    ips.close()

    filename= 'ping.txt'
    os.remove(filename)
    os.rename('ip_False.txt','ping.txt')
    
    end_Time = int(time.time())  #��¼����ʱ��
    print "time(��)��",end_Time - start_Time,"s"  #��ӡ�������õ�ʱ��
    print "pingͨ����",count_True,"   ping��ͨ��ip����",count_False
ping_Test()
