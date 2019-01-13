#-*- coding:gb18030 -*-
'''
#判断文件ping.txt中的ip是否能ping通，并且将通与不通的ip分别写到两个文件中ip_True.txt和ip_False.txt
最后ip_False会替代原ping.txt
#文件中的ip一行一个
'''

import subprocess   
import socket
import time,os
start_Time=int(time.time()) #记录开始时间
def ping_Test():
    ips=open('ping.txt','r')
    ip_True = open('ip_True.txt','a')
    ip_False = open('ip_False.txt','w')
    count_True,count_False=0,0
    lines=ips.readlines()
    
    for ip in lines:
        #ip = ip.replace('\n','')  #替换掉换行符
        ip = ip.strip()
        return1=subprocess.call('ping  -n 2 -w 1 %s'%ip,shell=True) #每个ip ping2次，等待时间为1s

        #print return1

        if return1:
            print 'ping %s is fail'%ip
            ip_False.write(ip+"\n")  #把ping不通的写到ip_False.txt中
            #ip_False.write(socket.gethostbyaddr(ip))
            count_False += 1
        else:
            print 'ping %s is ok'%ip
            #ip_True.write(ip)  #把ping通的ip写到ip_True.txt中
            
            try:
                result = socket.gethostbyaddr(ip)
                #print result
                ip_True.write(result[0].split(".")[0])
                ip_True.write(" ")
                ip_True.write(result[2][0])
                ip_True.write("\n")
            except socket.herror: #无法获取主机名的情况就直接写入IP
                ip_True.write("GetHostNameFail "+ip+"\n")
            count_True += 1
           
    ip_True.close()
    ip_False.close()
    ips.close()

    filename= 'ping.txt'
    os.remove(filename)
    os.rename('ip_False.txt','ping.txt')
    
    end_Time = int(time.time())  #记录结束时间
    print "time(秒)：",end_Time - start_Time,"s"  #打印并计算用的时间
    print "ping通数：",count_True,"   ping不通的ip数：",count_False
ping_Test()
