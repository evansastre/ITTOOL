#! python3
# -*- coding: utf-8 -*-

import sys
from PyQt5.QtWidgets import *
#from PyQt5 import QtCore

#from PyQt5.QtCore import pyqtSignature
#import pyqtSignature

from PyQt5 import QtCore, QtGui, QtWidgets
#from PyQt5.QtGui import QDialog
from Ui_dspwd import Ui_Dialog

import telnetlib
from sendmail import *
from work_rec import *

# Config Opt
username = "CorpDomain\itbat"   
password = "Password@4" 
user_view = '>' 
server = 'dc4' 

sysCharType = sys.getfilesystemencoding()

def login(itn,iusername,ipassword):
    One_Step(itn,'login: ',iusername)
    One_Step(itn,'password: ',ipassword)
    
def One_Step (itn,iread,iwrite):
    itn.read_until(iread)
    itn.write(iwrite+ '\r\n')    


def resetAccount(iHost,iuser_view, samid):
    #samid=samid.encode()
    #print(samid)
    #print(type(samid))
    dlg.label.setText(u"Checking if accout exist")
    try:
        tn = telnetlib.Telnet(iHost,port=23,timeout=10)# connect Telnet Server  
    except:
        dlg.label.setText(u"can not connect") 
        return
        
    login(tn,username,password) 
    #r = tn.read_some()
    #print r

    mycmd = r"dsquery user -samid " + samid  #Checking if accout exist
    One_Step (tn,iuser_view, mycmd )
    
    #print samid
    
	#The result of reading the display with "CN=" is the flag. If the execution is unsuccessful, this flag is not returned, but there is still a return value. It is necessary to judge whether the flag character is included in the return value.
    res = tn.read_until("CN=", 2)      
    if any(x in res for x in["CN="]):
        print ("Account Exist")
        dlg.label.setText(u"Account exists, in the search status") 
    else:
        print ("Account Not Exist")
        dlg.label.setText(u"The account does not exist, please re-enter") 
        tn.close()
        return 
    
    
    UTF8Input='Account activation'.decode('utf-8').encode(sysCharType)  
	#Input command for Chinese must be converted to system code
    mycmd = r'net user '+ samid + r' | find "' + UTF8Input + '"'  #Query account status    
    One_Step (tn,iuser_view, mycmd )
    
    res = tn.read_until(">", 1) 
    res = res.decode(sysCharType).encode('utf-8')
    #print res
    
    if "No" in res :
        print ("Account is not active")
        dlg.label.setText(u"The account has been disabled and cannot be unlocked") 
        tn.close()
        return 
    elif "Locked" in res :
        print ("Account is Locked")
        mycmd= r'net user ' + samid + r' /active' 
        tn.write( mycmd + '\r\n')  # There is already a read state before, you can no longer read things with read, so write directly
        sendmail(samid)
        work_rec("UnlockDomainUser")
        print ("Unlock done")
        dlg.label.setText(u"Unlocked successfully") 
    elif "Yes" in res :
        print ("No need to Unlock")
        dlg.label.setText(u"The account is normal, no need to unlock") 
    else :
        print ("Unknown mistake")
        dlg.label.setText(u"Unknown mistake") 
    #
    #it_test2
    #tn.write("exit\r\n")
    #One_Step (tn,iuser_view, "exit()")
    
    tn.close()
    
    #print "all: " +tn.read_all()   #.decode(sysCharType).encode('utf-8')



class Dialog(QDialog, Ui_Dialog):
    """
    Class documentation goes here.
    """
    def __init__(self, parent=None):
        """
        Constructor
        @param parent reference to the parent widget (QWidget)
        """
        QDialog.__init__(self, parent)
        self.setupUi(self)

    #@pyqtSignature("")
    def on_pushButton_clicked(self):
    
        
        samid= self.lineEdit.text()
        if samid=="" : 
            self.label.setText(u"No input") 
        else:
            resetAccount(server,user_view, str(samid))   
             #The str conversion for samid is necessary here because the type obtained from QT is QSTRING
             
             #dlg.close()    #Since the result of the operation is to be displayed in the window, no automatic exit is set.
        
if __name__ == "__main__":  
    #app = PyQt5.QtGui.QApplication(sys.argv)   
    app = QApplication(sys.argv)   
    #app = QtGui.QApplication(sys.argv)   
    dlg = Dialog()   
    dlg.show()   
    sys.exit(app.exec_())  
    
