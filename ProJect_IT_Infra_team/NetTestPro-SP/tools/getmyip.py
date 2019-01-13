###-*-coding:utf-8 -*-
import re
import urllib2

print("hello")
class Getmyip:
    def getip(self):
        try:
            myip = self.visit("http://www.myip.cn/")
            
        except:
            try:
                myip = self.visit("http://www.ipip.net/")
                
            except:
                try:
                    myip = self.visit("http://www.ip138.com/ips1388.asp")
                except:
                    myip = "Fail to get IP."
        print("myip:"+myip)
        return myip
        
    def getlocation(self, myip):
        '''
        #从IP138获取的完整步骤
        url = "http://www.ip138.com/ips138.asp?ip=%s&action=2" % myip
        u = urllib2.urlopen(url)
        s = u.read() 
        result = re.findall(r'(<li>.*?</li>)',s)
        r=result[0]
        print r
        r = r[16:-5]        
        import sys
        sysCharType = sys.getfilesystemencoding() #获取系统的编码方式 
        print  r.decode('gbk').encode("utf-8")
        r= r.decode('gb2312').encode(sysCharType)
        return r  
        
        '''
        url = "http://www.myip.cn/"
        #u = urllib2.urlopen(url)
        u = urllib2.urlopen(url)
        s = u.read() 
       
        result = re.findall(r'(location=.*?")',s)
        r=result[0]
        r = r[9:-2]        
        print (r)
        
        import sys
        sysCharType = sys.getfilesystemencoding() #获取系统的编码方式 
        #print  r.decode('gbk').encode("utf-8")
        r= r.decode('utf-8').encode(sysCharType)
        
        
        return r  
        
    def visit(self,url):
        opener = urllib2.urlopen(url)
        if url == opener.geturl():
            str = opener.read()
        #print str
        if url=="http://www.ipip.net/" :
            ip = re.search('您当前的IP：\d+\.\d+\.\d+\.\d+',str).group(0) #首次筛选出准确的IP
        ip = re.search('\d+\.\d+\.\d+\.\d+',ip).group(0) #再次将中文晒掉
        #print ip
        return ip 
        
getmyip = Getmyip()
ip = getmyip.getip()
location = getmyip.getlocation(ip)
#print type(ip)
#print ip, "\n", location

import tempfile
tempdir=tempfile.gettempdir()
file_name = tempdir+"\NetTestPro_speed.txt" #附件名

f = open(file_name , 'a') 
try:
    f.write (ip + "\n" +location+ "\n")
finally:
    f.close()
