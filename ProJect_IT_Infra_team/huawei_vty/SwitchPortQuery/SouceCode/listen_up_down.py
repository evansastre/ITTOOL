# -*- coding: utf-8 -*-   
import telnetlib  
import threading
import os
import time
#import pexpect

# 

#Host = '192.168.*.*' # Telnet Server IP 
username = 'ITSuperAdmin'   
password = 'Password@2' 
user_view = '<' 
system_view='[' 
#commands = open('commands.txt','r')


def One_Step(itn,iread,iwrite):
    itn.read_until(iread)
    itn.write(iwrite+ '\n')
     
def login(tn,iusername,ipassword):
    One_Step(tn,'Username:',iusername)# 
    One_Step(tn,'Password:',ipassword)# 
    
def getname(itn):
    One_Step(itn,"<","")
    #global name
    name=itn.read_until("<")
    itn.write('\n') ############
    switchname = name.split(">")[0]  
    return switchname

    

def Commands(itn,iname):
    #One_Step(itn,user_view,"sys")    #Enter system-view as needed to adjust this sentence
    '''
    while 1:
        line = commands.readline()
        if not line:
            break
        pass
        One_Step(itn,user_view,line)
        msg=itn.read_until(user_view)
        #itn.write('\n') ############
        #print '<'+ msg[:-1]       
    '''
    
    One_Step(itn,user_view,"terminal monitor") # open terminal monitor
    print iname + " is working"
    #print user_view + "!!!!!!!!!!!!!!!"
    '''
    try:
        response = itn.read_until('DOWN',timeout=30) 
        itn.write('\n')
    except EOFError as e:
        print "Connection closed: %s" % e
 
    if 'DOWN' in response:
        print "DOWN"
    else:
        print "no"
    '''
    #while timeout=40
    #really you should set some sort of a timeout here.
   # print started_time
    started_time=time.clock()
    
    while True:
        r = itn.read_very_eager()      
        
        if any(x in r for x in["DOWN","UP"]):
            started_time=0 #Reset initial time
            print r.split(".")[0]  
        if (time.clock()-started_time-120 > 0 ):
            print iname + " have no message about up&down. Time out.\n"
            break
        
    itn.read_until(user_view)    #close connect
    itn.close() # tn.write('exit\n')
#Commands()

def listen_up_down(iHost,iusername,ipassword):
    try:
        tn = telnetlib.Telnet(iHost,port=23,timeout=60 )# connect Telnet Server
		#Interrupt connect without any information returned within 60 seconds
    except:
        print iHost+"  Request timeout \n"
        return
    try:
        login(tn,iusername,ipassword)
        name=getname(tn)
        Commands(tn,name)
    except:
        print iHost+" "+name + " disconnected"
        return
    
    
#listen_up_down(Host,username,password)

def mainfunc():
    f = open('Hosts.ini','r')
    print "start monitoring...\n"
    while 1:
        ip = f.readline()
        if ip == '':
            return
        #pass
    
        #cut=ip.split() 
        #Host=cut[0]    
        try:
            iHost=ip.split()[0] 
            print iHost
            a=threading.Thread(target=listen_up_down,args=(iHost,username,password))
            a.start() #Open thread
        except:
            print "get no IP in this line "
               #print "Host"
        
mainfunc()
os.system("ping -n 600 127.1 >nul") #Pause the interface 600s, show the execution results. No need to pause here, the server plan execution can not be closed





