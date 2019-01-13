# -*- coding: utf-8 -*-
"""
Module implementing Dialog.
"""
#import PyQt4, PyQt4.QtGui, sys 
import PyQt4, PyQt4.QtGui, sys 
from PyQt4.QtCore import pyqtSignature
from PyQt4.QtGui import QDialog
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
    dlg.label.setText(u"Checking if the account is exist")
    try:
        tn = telnetlib.Telnet(iHost,port=23,timeout=10)# connect Telnet Server
    except:
        dlg.label.setText(u"can not connect") 
        return
        
    login(tn,username,password) 
    #r = tn.read_some()
    #print r

    mycmd = r"dsquery user -samid " + samid  #First check if the account exists
    One_Step (tn,iuser_view, mycmd )
    
    #print samid
    
    res = tn.read_until("CN=", 2)      
	#The result of reading the display with "CN=" is the flag. If the execution is unsuccessful, this flag is not returned, but there is still a return value. It is necessary to judge whether the flag character is included in the return value.
    if any(x in res for x in["CN="]):
        print "success"
        dlg.label.setText(u"The account exists and is being reset") 
        mycmd=r"dsquery user -samid " + samid + r" | dsmod user -pwd Password@1 -mustchpwd yes && net user " + samid +r" /active" 
        One_Step (tn,iuser_view, mycmd )
        sendmail(samid)
        work_rec("ResetDomainUser")
        dlg.label.setText(u"Reset successful") 
    else:
        print "fail"
        dlg.label.setText(u"The account does not exist, please re-enter") 
        tn.close()
        return

    #tn.write("exit\r\n")
    #One_Step (tn,iuser_view, "exit()")
    #print tn.read_all()   #.decode(sysCharType).encode('utf-8')
    tn.close()



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

    @pyqtSignature("")
    def on_pushButton_clicked(self):
    
        
        samid= self.lineEdit.text()
        if samid=="" : 
            self.label.setText(u"No Input") 
        else:
              
            resetAccount(server,user_view, str(samid))   
             #The str conversion for samid is necessary here because the type obtained from QT is QSTRING
             
             #dlg.close()    #Since the result of the operation is to be displayed in the window, no automatic exit is set.
        
if __name__ == "__main__":  
    app = PyQt4.QtGui.QApplication(sys.argv)   
    dlg = Dialog()   
    dlg.show()   
    sys.exit(app.exec_())  
    
